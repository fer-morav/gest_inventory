import '../models/Incoming.dart';

abstract class AbstractIncomingRepository {
  Future<Incoming?> getIncoming(String productId, String incomingId);
  Future<bool> addIncoming(String productId, Incoming incoming);
  Future<bool> deleteIncoming(String productId, String incomingId);
  Future<bool> updateIncoming(String productId, Incoming incoming);
  Future<List<Incoming>> getListIncoming(String productId, {bool descending = false});
  Future<List<Incoming>> getListIncomingToday(String productId, {bool descending = false});
  Future<List<Incoming>> getListIncomingWeek(String productId, {bool descending = false});
  Future<List<Incoming>> getListIncomingMonth(String productId, {bool descending = false});
}