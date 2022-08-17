import '../models/Incoming.dart';

abstract class AbstractIncomingRepository {
  Future<Incomings?> getIncoming(String businessId, String incomingId);
  Future<bool> addIncoming(Incomings incoming);
  Future<bool> updateIncoming(Incomings incoming);
  Future<bool> deleteIncoming(Incomings incoming);
  Future<List<Incomings>> getTableIncoming(String businessId);
  Future<int> getTableIncomingLength(String businessId);
}