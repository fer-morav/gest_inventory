import '../models/Business.dart';

abstract class AbstractBusinessRepository {
  Future<Business?> getBusiness(String id);
  Future<String?> addBusiness(Business business);
  Future<bool> updateBusiness(Business business);
  Future<bool> updateBusinessMap(String id, Map<String, dynamic> map);
  Future<bool> deleteBusiness(String id);
}