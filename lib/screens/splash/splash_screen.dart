import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/theme/cyberpunk_theme.dart';
import '../../core/widgets/cyberpunk_widgets.dart';
import '../../services/update_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    // Wait briefly for UI to render
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final pkg = await PackageInfo.fromPlatform();
      final currentVersion = pkg.version;

      // Check for updates
      final latest = await UpdateService.fetchLatestRelease();
      if (latest != null && await UpdateService.shouldUpdate(currentVersion, latest) && latest.apkUrl != null) {
        if (mounted) {
          await _showUpdateDialog(latest.apkUrl!);
        }
        return;
      }
    } catch (_) {
      // Silently continue if update check fails
    }

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _showUpdateDialog(String apkUrl) async {
    final shouldUpdate = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: CyberColors.surface,
        shape: const BeveledRectangleBorder(
          side: BorderSide(color: CyberColors.neonCyan, width: 1.5),
        ),
        title: const Row(
          children: [
            Icon(Icons.system_update, color: CyberColors.neonCyan, size: 24),
            SizedBox(width: 8),
            Text('UPDATE AVAILABLE', style: TextStyle(color: CyberColors.neonCyan, fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          ],
        ),
        content: const Text('A new version is ready!\nDownload and install now?', style: TextStyle(color: CyberColors.textPrimary, fontFamily: 'monospace', fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('LATER', style: TextStyle(color: CyberColors.textDim, fontFamily: 'monospace', fontSize: 11)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: CyberColors.neonCyan),
            child: const Text('UPDATE', style: TextStyle(color: CyberColors.bg, fontWeight: FontWeight.bold, fontFamily: 'monospace', fontSize: 11)),
          ),
        ],
      ),
    );

    if (shouldUpdate == true) {
      await _performUpdate(apkUrl);
    }

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  Future<void> _performUpdate(String apkUrl) async {
    // Show downloading dialog
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: CyberColors.neonCyan)),
            SizedBox(width: 12),
            Text('Downloading update...', style: TextStyle(fontFamily: 'monospace', fontSize: 12)),
          ],
        ),
        backgroundColor: CyberColors.surface,
        duration: Duration(seconds: 30),
      ),
    );

    try {
      final path = await UpdateService.downloadApk(apkUrl);
      await UpdateService.installApk(path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Update failed: $e', style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
            backgroundColor: CyberColors.hotMagenta,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        painter: GridBackground(),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BracketFrame(
                color: CyberColors.neonCyan,
                padding: 20,
                child: Column(
                  children: [
                    Text('S . O . L . O', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: CyberColors.neonCyan, fontFamily: 'monospace', letterSpacing: 4)),
                    SizedBox(height: 4),
                    Text('STUDY REALM', style: TextStyle(fontSize: 12, color: CyberColors.textDim, fontFamily: 'monospace', letterSpacing: 6)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: CyberColors.neonCyan)),
              const SizedBox(height: 16),
              const Text('INITIALIZING SYSTEM...', style: TextStyle(fontSize: 10, color: CyberColors.textDim, fontFamily: 'monospace', letterSpacing: 2)),
            ],
          ),
        ),
      ),
    );
  }
}
