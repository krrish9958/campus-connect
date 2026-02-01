import 'package:cloud_firestore/cloud_firestore.dart';

class AuditLogService {
  final _db = FirebaseFirestore.instance;

  static const int pageSize = 10;

  DocumentSnapshot? _lastDoc;

  Future<List<QueryDocumentSnapshot>> fetchLogs({bool loadMore = false}) async {
    Query query = _db
        .collection('audit_logs')
        .orderBy('timestamp', descending: true)
        .limit(pageSize);

    if (loadMore && _lastDoc != null) {
      query = query.startAfterDocument(_lastDoc!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      _lastDoc = snapshot.docs.last;
    }

    return snapshot.docs;
  }

  void reset() {
    _lastDoc = null;
  }
}
