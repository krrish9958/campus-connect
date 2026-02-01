import 'package:flutter/material.dart';
import '../services/audit_log_service.dart';

class AdminAuditLogsScreen extends StatefulWidget {
  const AdminAuditLogsScreen({super.key});

  @override
  State<AdminAuditLogsScreen> createState() => _AdminAuditLogsScreenState();
}

class _AdminAuditLogsScreenState extends State<AdminAuditLogsScreen> {
  final AuditLogService _service = AuditLogService();
  final ScrollController _scrollController = ScrollController();

  final List logs = [];
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        _loadLogs(loadMore: true);
      }
    });
  }

  Future<void> _loadLogs({bool loadMore = false}) async {
    setState(() => isLoading = true);

    final newLogs = await _service.fetchLogs(loadMore: loadMore);

    setState(() {
      logs.addAll(newLogs);
      isLoading = false;
      if (newLogs.length < AuditLogService.pageSize) {
        hasMore = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Audit Logs")),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: logs.length + 1,
        itemBuilder: (context, index) {
          if (index == logs.length) {
            return isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }

          final log = logs[index].data() as Map<String, dynamic>;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: Text("${log['action']} → ${log['newRole']}"),
              subtitle: Text(
                "User: ${log['targetEmail']}\nBy: ${log['changedByEmail']}",
              ),
              trailing: Text(
                log['oldRole'],
                style: const TextStyle(fontSize: 12),
              ),
            ),
          );
        },
      ),
    );
  }
}
