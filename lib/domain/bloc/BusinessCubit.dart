import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/repositories/AbstractBusinessRepository.dart';
import 'package:gest_inventory/domain/usecases/business/GetBusinessUseCase.dart';
import 'package:gest_inventory/domain/usecases/business/UpdateBusinessMapUseCase.dart';
import 'package:gest_inventory/domain/usecases/business/UpdateBusinessUseCase.dart';
import 'package:gest_inventory/domain/usecases/user/GetUserUseCase.dart';
import 'package:gest_inventory/domain/usecases/user/UpdateUserMapUseCase.dart';
import 'package:gest_inventory/utils/enums.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import '../../data/models/Address.dart';
import '../../data/models/Business.dart';
import '../../data/models/User.dart';
import '../../data/repositories/AbstractStorageRepository.dart';
import '../../data/repositories/AbstractUserRepository.dart';
import '../usecases/business/AddBusinessUseCase.dart';
import '../usecases/storage/UploadBusinessPhotoUseCase.dart';
import '../../utils/arguments.dart';
import '../../utils/image_picker_utils.dart';
import '../../utils/resources.dart';
import '../../utils/strings.dart';

class BusinessCubit extends Cubit<BusinessState> {
  final AbstractBusinessRepository businessRepository;
  final AbstractUserRepository userRepository;
  final AbstractStorageRepository storageRepository;

  late AddBusinessUseCase _addBusinessUseCase;
  late UpdateBusinessUseCase _updateBusinessUseCase;
  late GetBusinessUseCase _getBusinessUseCase;
  late GetUserUseCase _getUserUseCase;
  late UpdateUserMapUseCase _updateUserMapUseCase;
  late UploadBusinessPhotoUseCase _uploadBusinessPhotoUseCase;
  late UpdateBusinessMapUseCase _updateBusinessMapUseCase;

  final _pickerUtils = ImagePickerUtils();

  final nameController = TextEditingController();
  final ownerController = TextEditingController();
  final phoneController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final suburbController = TextEditingController();
  final cpController = TextEditingController();
  final addressController = TextEditingController();
  final numberController = TextEditingController();

  BusinessCubit({
    required this.businessRepository,
    required this.userRepository,
    required this.storageRepository,
  }) : super(BusinessState());

  void init(Map<dynamic, dynamic> args) {
    _addBusinessUseCase = AddBusinessUseCase(businessRepository: businessRepository);
    _updateBusinessUseCase = UpdateBusinessUseCase(businessRepository: businessRepository);
    _updateUserMapUseCase = UpdateUserMapUseCase(userRepository: userRepository);
    _getBusinessUseCase = GetBusinessUseCase(businessRepository: businessRepository);
    _uploadBusinessPhotoUseCase = UploadBusinessPhotoUseCase(storageRepository: storageRepository);
    _updateBusinessMapUseCase = UpdateBusinessMapUseCase(businessRepository: businessRepository);
    _getUserUseCase = GetUserUseCase(userRepository: userRepository);

    if (args.isEmpty) {
      return;
    }
     _initValues(args);
  }

  void reset() => emit(BusinessState());

  void setActionType(ActionType action) => _newState(actionType: action);

  String? validator(String? value) =>
      value!.isEmpty ? textfield_error_general : null;

  String? phoneValidator(String? value) => value!.isEmpty
      ? textfield_error_phone_empty
      : value.isPhoneValid()
          ? null
          : textfield_error_phone;

  String? cpValidator(String? value) => value!.isEmpty
      ? textfield_error_cp_empty
      : value.isCPValid()
          ? null
          : textfield_error_cp;

  void _showToast(String message, bool error) =>
      _newState(message: message, error: error);

  Future<void> setProfilePhoto(String response) async {
    switch (response) {
      case button_take_photo:
        final photoImage = await _pickerUtils.pickImageFromCamera();

        if (photoImage != null) {
          _newState(photoFile: photoImage, profilePhoto: FileImage(photoImage));
        }
        break;

      case button_pick_picture:
        final photoImage = await _pickerUtils.pickImageFromGallery();

        if (photoImage != null) {
          _newState(photoFile: photoImage, profilePhoto: FileImage(photoImage));
        }
        break;

      case button_delete_photo:
        _newState(
            photoFile: null,
            profilePhoto: NetworkImage(image_business_default));
        break;
    }
  }

  Future<void> registerBusiness() async {
    if (state.actionType == ActionType.add) {
      _newState(
        business: Business(
          ownerId: state.viewer!.id,
          name: nameController.text.trim(),
          phone: int.parse(phoneController.text.trim()),
          address: Address(
            cp: int.parse(cpController.text.trim()),
            state: stateController.text.trim(),
            town: cityController.text.trim(),
            suburb: suburbController.text.trim(),
            street: addressController.text.trim(),
            num: int.parse(numberController.text.trim()),
          ),
        ),
      );
      await _addBusiness();
    } else {
      state.business!.name = nameController.text.trim();
      state.business!.phone = int.parse(phoneController.text.trim());
      state.business!.address.cp = int.parse(cpController.text.trim());
      state.business!.address.state = stateController.text.trim();
      state.business!.address.town = cityController.text.trim();
      state.business!.address.suburb = suburbController.text.trim();
      state.business!.address.street = addressController.text.trim();
      state.business!.address.num = int.parse(numberController.text.trim());

      _newState(business: state.business);
      await _updateBusiness();
    }
  }

  Future<void> _addBusiness() async {
    if (state.business != null) {
      String? id = await _addBusinessUseCase.add(state.business!);

      if (id == null) {
        _showToast(text_add_business_not_success, false);
        return;
      }

      state.business?.id = id;
      state.viewer?.idBusiness = id;
      _newState(business: state.business, viewer: state.viewer);

      _showToast(text_add_business_success, true);

      await _uploadPhoto();

      if (await _updateUser()) {
        _newState(complete: true);
      }
    }
  }

  Future<void> _updateBusiness() async {
    if (state.business != null) {
      if (await _updateBusinessUseCase.update(state.business!)) {
        _showToast(text_update_data, true);

        await _uploadPhoto();

        _newState(complete: true);
      }
    }
  }

  Future<bool> _updateUser() async {
    if (state.business != null &&
        state.business!.id.isNotEmpty &&
        state.viewer != null) {

      final changes = {
        User.FIELD_ID_BUSINESS: state.business!.id,
        User.FIELD_ADMIN: true,
      };

      bool result = await _updateUserMapUseCase.update(state.viewer!.id, changes);

      return result;
    }
    return false;
  }

  Future<void> _uploadPhoto() async {
    if (state.business != null &&
        state.business!.id.isNotEmpty &&
        state.photoFile != null) {
      final result = await _uploadBusinessPhotoUseCase.upload(
          state.business!.id, state.photoFile!);

      if (result == null) {
        _showToast(alert_error_load_image, false);
      } else {
        _updatePhotoUrl(result);
      }
    }
  }

  void _updatePhotoUrl(String photoUrl) async {
    if (state.business != null && state.business!.id.isNotEmpty) {
      final changes = {
        Business.FIELD_PHOTO: photoUrl,
      };

      await _updateBusinessMapUseCase.update(state.business!.id, changes);
    }
  }

  void _initValues(Map<dynamic, dynamic> args) async {
    ActionType action = args[action_type_args];

    if (action == ActionType.add) {
      User user = args[user_args];

      ownerController.text = user.name;

      _newState(owner: user, viewer: user, actionType: action);
      return;
    }

    if (action == ActionType.open) {
      User user = args[user_args];

      final business = await _getBusinessUseCase.get(user.idBusiness);

      if (business != null) {
        if (business.ownerId == user.id) {
          ownerController.text = user.name;

          _newState(business: business, owner: user, viewer: user, actionType: action);
        } else {
          User? owner = await _getUserUseCase.get(business.ownerId);

          ownerController.text = owner!.name;
          _newState(business: business, owner: owner, viewer: user, actionType: action);
        }

        _loadInfo(business);
      }
      return;
    }
  }

  void _loadInfo(Business business) {
    _newState(profilePhoto: NetworkImage(business.photoUrl));

    nameController.text = business.name;
    phoneController.text = business.phone.toString();
    stateController.text = business.address.state;
    cityController.text = business.address.town;
    suburbController.text = business.address.suburb;
    cpController.text = business.address.cp.toString();
    addressController.text = business.address.street;
    numberController.text = business.address.num.toString();
  }

  void _newState({
    ActionType? actionType,
    User? viewer,
    User? owner,
    Business? business,
    ImageProvider? profilePhoto,
    File? photoFile,
    String? message,
    bool? error,
    bool? complete,
  }) {
    emit(BusinessState(
      actionType: actionType ?? state.actionType,
      viewer: viewer ?? state.viewer,
      owner: owner ?? state.owner,
      business: business ?? state.business,
      profilePhoto: profilePhoto ?? state.profilePhoto,
      photoFile: photoFile ?? state.photoFile,
      message: message,
      error: error ?? state.error,
      complete: complete ?? state.complete,
    ));
  }

  @override
  Future<void> close() {
    nameController.dispose();
    ownerController.dispose();
    phoneController.dispose();
    stateController.dispose();
    cityController.dispose();
    suburbController.dispose();
    cpController.dispose();
    addressController.dispose();
    numberController.dispose();
    return super.close();
  }
}

class BusinessState {
  final ActionType actionType;
  final User? viewer;
  final User? owner;
  final Business? business;
  final ImageProvider profilePhoto;
  final File? photoFile;
  final String? message;
  final bool error;
  final bool complete;

  BusinessState({
    this.actionType = ActionType.select,
    this.viewer = null,
    this.owner = null,
    this.business = null,
    this.profilePhoto = const NetworkImage(image_business_default),
    this.photoFile = null,
    this.message = null,
    this.error = false,
    this.complete = false,
  });
}
