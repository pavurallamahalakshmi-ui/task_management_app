import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class DraftService {
  static const String draftBoxName = 'task_draft';
  late Box<String> _draftBox;

  Future<void> init() async {
    _draftBox = await Hive.openBox<String>(draftBoxName);
  }

  Future<void> saveDraft(Map<String, dynamic> draftData) async {
    final draftString = _serializeDraft(draftData);
    await _draftBox.put('current_draft', draftString);
  }

  Map<String, dynamic>? getDraft() {
    final draftString = _draftBox.get('current_draft');
    if (draftString == null) return null;
    return _deserializeDraft(draftString);
  }

  Future<void> clearDraft() async {
    await _draftBox.delete('current_draft');
  }

  String _serializeDraft(Map<String, dynamic> data) {
    // JSON is robust for arbitrary user input (including delimiters).
    return jsonEncode(data);
  }

  Map<String, dynamic> _deserializeDraft(String data) {
    // Prefer JSON format; gracefully fall back to legacy delimiter format
    // to avoid breaking existing stored drafts.
    try {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      if (decoded is Map) {
        return decoded.map(
          (key, value) => MapEntry(key.toString(), value),
        );
      }
    } catch (_) {
      // Ignore and try legacy format.
    }

    final result = <String, dynamic>{};
    final parts = data.split('||');
    for (final part in parts) {
      if (!part.contains('::')) continue;

      final separatorIndex = part.indexOf('::');
      final key = part.substring(0, separatorIndex);
      final value = part.substring(separatorIndex + 2);
      result[key] = value == 'null' ? null : value;
    }
    return result;
  }
}
