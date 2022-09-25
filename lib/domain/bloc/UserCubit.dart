import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gest_inventory/data/repositories/AbstractStorageRepository.dart';
import 'package:gest_inventory/data/repositories/AbstractUserRepository.dart';
import 'package:gest_inventory/domain/bloc/AuthCubit.dart';
import 'package:gest_inventory/utils/enums.dart';
import 'package:gest_inventory/utils/extensions_functions.dart';
import '../../data/models/User.dart';
import '../usecases/storage/UploadUserPhotoUseCase.dart';
import '../usecases/user/AddUserUseCase.dart';
import '../usecases/user/UpdateUserUseCase.dart';
import '../../utils/arguments.dart';
import '../../utils/image_picker_utils.dart';
import '../../utils/resources.dart';
import '../../utils/strings.dart';

class UserCubit extends Cubit<UserState> {
  final AbstractUserRepository userRepository;
  final AbstractStorageRepository storageRepository;

  late AddUserUseCase _addUserUseCase;
  late UpdateUserUseCase _updateUserUseCase;
  late UploadUserPhotoUseCase _uploadUserPhotoUseCase;

  final _pickerUtils = ImagePickerUtils();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final salaryController = TextEditingController();

  UserCubit({
    required this.userRepository,
    required this.storageRepository,
  }) : super(UserState());

  void init(AuthCubit auth, Map<dynamic, dynamic> args) {
    _addUserUseCase = AddUserUseCase(userRepository: userRepository);
    _updateUserUseCase = UpdateUserUseCase(userRepository: userRepository);
    _uploadUserPhotoUseCase = UploadUserPhotoUseCase(storageRepository: storageRepository);

    ActionType action = args[action_type_args];

    if (action == ActionType.add) {
      _newState(viewerId: auth.getUserId(), email: auth.getUserEmail(), actionType: action);

      emailController.text = state.email!;
      return;
    }

    if (action == ActionType.open || action == ActionType.edit) {
      User user = args[user_args];

      emailController.text = user.email;
      _newState(viewerId: auth.getUserId(), email: user.email, user: user, actionType: action);

      _loadInfo(user);
      return;
    }
  }

  void reset() => emit(UserState());

  void setIsAdmin(bool active) => _newState(isAdmin: active);

  void setActionType(ActionType action) => _newState(actionType: action);

  void _showToast(String message, bool error) =>
      _newState(message: message, error: error);

  String? nameValidator(String? value) =>
      value!.isEmpty ? textfield_error_name : null;

  String? phoneValidator(String? value) => value!.isEmpty
      ? textfield_error_phone_empty
      : value.isPhoneValid()
          ? null
          : textfield_error_phone;

  String? salaryValidator(String? value) =>
      value!.isEmpty ? textfield_error_salary : null;

  String? emailValidator(String? value) => value!.isEmpty
      ? textfield_error_email_empty
      : value.isEmailValid()
          ? null
          : textfield_error_email;

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
        _newState(photoFile: null, profilePhoto: NetworkImage(image_business_default));
        break;
    }
  }

  Future<void> registerUser() async {
    if (state.actionType == ActionType.add) {
      String? photoURL;

      if (state.photoFile != null) {
        photoURL = await _uploadPhoto(state.viewerId!, state.photoFile!);

        if (photoURL == null) {
          _showToast(alert_error_load_image, false);
        }
      }

      _newState(
        user: User(
          id: state.viewerId!,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          photoUrl: photoURL ?? image_profile_default,
          admin: state.isAdmin,
          phoneNumber: int.parse(phoneController.text.trim()),
          salary: double.parse(salaryController.text.trim()),
        ),
      );
      if (await _addUser()) {
        _showToast(text_add_user_success, true);
      } else {
        _showToast(text_add_user_not_success, false);
      }
    } else {

      String? photoURL;

      if (state.photoFile != null) {
        photoURL = await _uploadPhoto(state.user!.id, state.photoFile!);

        if (photoURL == null) {
          _showToast(alert_error_load_image, false);
        } else {
          state.user!.photoUrl = photoURL;
        }
      }


      state.user!.name = nameController.text.trim();
      state.user!.admin = state.isAdmin;
      state.user!.phoneNumber = int.parse(phoneController.text.trim());
      state.user!.salary = double.parse(salaryController.text.trim());

      _newState(user: state.user);

      if (await _updateUser()) {
        _showToast(text_update_data, true);
      } else {
        _showToast(text_error_update_data, false);
      }
    }
  }

  Future<bool> _addUser() async {
    if (state.user != null) {
      if (await _addUserUseCase.add(state.user!)) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<bool> _updateUser() async {
    if (state.user != null) {
      if (await _updateUserUseCase.update(state.user!)) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  Future<String?> _uploadPhoto(String userId, File photo) async {
    final result = await _uploadUserPhotoUseCase.uploadPhoto(userId, photo);

    if (result == null) {
      return null;
    } else {
      return result;
    }
  }

  void _loadInfo(User user) {
    _newState(profilePhoto: NetworkImage(user.photoUrl), isAdmin: user.admin);

    nameController.text = user.name;
    phoneController.text = user.phoneNumber.toString();
    salaryController.text = user.salary.toString();
    emailController.text = user.email;
  }

  void _newState({
    ActionType? actionType,
    User? user,
    String? viewerId,
    String? email,
    ImageProvider? profilePhoto,
    File? photoFile,
    bool? isAdmin,
    String? message,
    bool? error,
  }) {
    emit(UserState(
      actionType: actionType ?? state.actionType,
      user: user ?? state.user,
      viewerId: viewerId ?? state.viewerId,
      email: email ?? state.email,
      profilePhoto: profilePhoto ?? state.profilePhoto,
      photoFile: photoFile ?? state.photoFile,
      isAdmin: isAdmin ?? state.isAdmin,
      message: message,
      error: error ?? state.error,
    ));
  }

  @override
  Future<void> close() {
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    salaryController.dispose();
    return super.close();
  }
}

class UserState {
  final ActionType actionType;
  final User? user;
  final String? viewerId;
  final String? email;
  final ImageProvider profilePhoto;
  final File? photoFile;
  final bool isAdmin;
  final String? message;
  final bool error;

  UserState({
    this.actionType = ActionType.select,
    this.user = null,
    this.viewerId = null,
    this.email = null,
    this.profilePhoto = const NetworkImage(image_profile_default),
    this.photoFile = null,
    this.isAdmin = false,
    this.message = null,
    this.error = false,
  });
}
