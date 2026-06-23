import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/foundation.dart';

class UpdateInfo {
  final String version;
  final int buildNumber;
  final String? apkUrl;

  UpdateInfo({required this.version, required this.buildNumber, this.apkUrl});

  factory UpdateInfo.fromJson(Map<String, dynamic> json) => UpdateInfo(
    version: json['version'] ?? '0.0.0',
    buildNumber: json['buildNumber'] ?? 0,
    apkUrl: json['apkUrl'],
  );
}

class UpdateService {
  static const String _repoOwner = 'AdhamKhaled1510';
  static const String _repoName = 'Solo';
  static const String _githubApi = 'https://api.github.com';

  static Future<UpdateInfo?> fetchLatestRelease() async {
    try {
      final uri = Uri.parse('$_githubApi/repos/$_repoOwner/$_repoName/releases/latest');
      final response = await http.get(uri, headers: {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'Solo-App',
      });
      if (response.statusCode != 200) return null;
      final data = jsonDecode(response.body);
      final tag = data['tag_name'] as String? ?? '0.0.0';
      final assets = data['assets'] as List? ?? [];
      String? apkUrl;
      for (final asset in assets) {
        final name = asset['name'] as String? ?? '';
        if (name.endsWith('.apk')) {
          apkUrl = asset['browser_download_url'] as String?;
          break;
        }
      }
      return UpdateInfo(
        version: tag,
        buildNumber: DateTime.now().millisecondsSinceEpoch,
        apkUrl: apkUrl,
      );
    } catch (e) {
      debugPrint('Update check failed: $e');
      return null;
    }
  }

  static Future<bool> shouldUpdate(String currentVersion, UpdateInfo latest) async {
    if (latest.apkUrl == null) return false;
    try {
      final currentParts = _parseVersion(currentVersion);
      final latestParts = _parseVersion(latest.version);
      if (currentParts == null || latestParts == null) return false;
      if (latestParts[0] > currentParts[0]) return true;
      if (latestParts[0] == currentParts[0] && latestParts[1] > currentParts[1]) return true;
      if (latestParts[0] == currentParts[0] && latestParts[1] == currentParts[1] && latestParts[2] > currentParts[2]) return true;
      return false;
    } catch (_) {
      return false;
    }
  }

  static List<int>? _parseVersion(String v) {
    final clean = v.replaceAll(RegExp(r'[vV]'), '');
    final parts = clean.split('.').map((e) => int.tryParse(e.replaceAll(RegExp(r'\D'), '')) ?? 0).toList();
    if (parts.length < 3) return null;
    return parts;
  }

  static Future<String> downloadApk(String url, {void Function(double)? onProgress}) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/mystudy_app_update.apk');
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) throw Exception('Download failed: ${response.statusCode}');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  static Future<void> installApk(String path) async {
    final result = await OpenFilex.open(path);
    if (result.type != ResultType.done) {
      throw Exception('Install failed: ${result.message}');
    }
  }
}
