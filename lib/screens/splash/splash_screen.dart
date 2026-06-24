import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/theme/clean_theme.dart';
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
    await Future.delayed(const Duration(milliseconds: 800));
    try {
      final pkg = await PackageInfo.fromPlatform();
      final latest = await UpdateService.fetchLatestRelease();
      if (latest != null && await UpdateService.shouldUpdate(pkg.version, latest) && latest.apkUrl != null) {
        if (mounted) await _showUpdateDialog(latest.apkUrl!);
        return;
      }
    } catch (_) {}
    if (mounted) Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> _showUpdateDialog(String apkUrl) async {
    final shouldUpdate = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.system_update, color: AppColors.primary, size: 24),
            SizedBox(width: 8),
            Text('تحديث متوفر', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text('نسخة جديدة متاحة! حملها الآن؟', style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('لاحقًا', style: TextStyle(color: AppColors.textDim))),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('تحديث', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (shouldUpdate == true) {
      try {
        final path = await UpdateService.downloadApk(apkUrl);
        await UpdateService.installApk(path);
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل التحديث: $e'), backgroundColor: AppColors.error));
      }
    }
    if (mounted) Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(child: Text('S', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white))),
            ),
            const SizedBox(height: 20),
            const Text('Solo', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            const Text('ادرس • صل • انجز', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 40),
            const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}
