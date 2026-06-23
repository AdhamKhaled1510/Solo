import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/focus_session.dart';
import '../../models/tree_species.dart';
import '../../providers/app_provider.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with TickerProviderStateMixin {
  Timer? _timer;
  int _secondsLeft = 0;
  int _totalSeconds = 0;
  bool _isRunning = false;
  late AnimationController _pulseController;
  late AnimationController _treeGrowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _treeGrowAnimation;
  String _selectedTreeId = 'oak';
  String _selectedTag = '';

  final List<String> _motivationalPhrases = [
    'أنت بطل! استمر 💪',
    'كل دقيقة بتقربك للنجاح 📈',
    'التركيز سلاح الأقوياء 🎯',
    'الطريق للقمة يبدأ بخطوة 🚀',
    'أنت أقوى مما تتصور 🔥',
    'المستقبل ملك لمن يستعد اليوم ⏳',
    'درهم تركيز خير من قنطرة تشتيت 💎',
    'اصبر فالنصر مع الصبر 🌅',
  ];
  String _currentPhrase = '';

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _pulseController.repeat(reverse: true);

    _treeGrowController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _treeGrowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _treeGrowController, curve: Curves.elasticOut),
    );
    _currentPhrase = (_motivationalPhrases..shuffle()).first;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    _treeGrowController.dispose();
    super.dispose();
  }

  void _startTimer(int minutes) {
    _totalSeconds = minutes * 60;
    _secondsLeft = _totalSeconds;
    _currentPhrase = (_motivationalPhrases..shuffle()).first;
    setState(() => _isRunning = true);
    context.read<AppProvider>().startFocusing();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
          if (_secondsLeft == 10) _currentPhrase = '⚠️ 10 ثواني متبقية! ركز!';
        } else {
          _onTimerComplete();
        }
      });
    });
  }

  void _onTimerComplete() {
    _timer?.cancel();
    _isRunning = false;
    _treeGrowController.forward();
    final app = context.read<AppProvider>();
    final tree = TreeSpecies.getById(_selectedTreeId);
    app.completeFocusSession(_totalSeconds ~/ 60, treeId: _selectedTreeId, tag: _selectedTag);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('🎉 أحسنت!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('لقد أكملت جلسة التركيز', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Text(tree.emoji, style: TextStyle(fontSize: 80)),
            const SizedBox(height: 8),
            Text(tree.name, style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('+ ${_totalSeconds ~/ 60} 🪙', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.amber)),
            Text('+ ${(_totalSeconds ~/ 60) * 2} XP', style: TextStyle(color: Colors.blue)),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('رائع!'),
          ),
        ],
      ),
    );
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resumeTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _onTimerComplete();
        }
      });
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _secondsLeft = 0;
    });
    context.read<AppProvider>().stopFocusing();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('💔 الشجرة ماتت'),
        content: const Text('لا تقلق، جرب مرة أخرى!'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('حسنًا')),
        ],
      ),
    );
  }

  String get _timeDisplay {
    final min = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final sec = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  double get _progress => _totalSeconds > 0 ? _secondsLeft / _totalSeconds : 1.0;

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final ownedTrees = app.ownedTrees;
    final selectedTree = TreeSpecies.getById(_selectedTreeId);

    return Scaffold(
      appBar: AppBar(title: const Text('مؤقت التركيز')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_totalSeconds == 0) ...[
                Text(selectedTree.emoji, style: TextStyle(fontSize: 100)),
                const SizedBox(height: 24),
                Text('اختر وقت التركيز', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [15, 25, 30, 45, 60, 90].map((min) => ChoiceChip(
                    label: Text('$min دقيقة'),
                    selected: app.focusDuration == min,
                    onSelected: (_) => app.setFocusDuration(min),
                  )).toList(),
                ),
                const SizedBox(height: 16),
                Text('اختر نوع الشجرة', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('${ownedTrees.length} نوع متاح', style: TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ownedTrees.map((t) => GestureDetector(
                    onTap: () => setState(() => _selectedTreeId = t.id),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedTreeId == t.id ? Colors.green : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _selectedTreeId == t.id ? Colors.green.withAlpha(15) : null,
                      ),
                      child: Column(
                        children: [
                          Text(t.emoji, style: const TextStyle(fontSize: 28)),
                          Text(t.rarity.emoji, style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 16),
                Text(selectedTree.name, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 8),
                Text('اختر النشاط', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: FocusSession.availableTags.map((tag) => ChoiceChip(
                    label: Text('${tag.emoji} ${tag.name}', style: const TextStyle(fontSize: 12)),
                    selected: _selectedTag == tag.id,
                    onSelected: (_) => setState(() => _selectedTag = tag.id),
                    visualDensity: VisualDensity.compact,
                  )).toList(),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => _startTimer(app.focusDuration),
                  icon: const Icon(Icons.play_arrow),
                  label: Text('ابدأ التركيز لمدة ${app.focusDuration} دقيقة'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                ),
              ] else ...[
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _isRunning ? _pulseAnimation.value : 1.0,
                    child: child,
                  ),
                  child: Text(selectedTree.emoji, style: TextStyle(fontSize: _isRunning ? 80 : 60)),
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _treeGrowAnimation,
                  builder: (context, child) {
                    if (_treeGrowController.isCompleted) {
                      return Text(selectedTree.emoji, style: const TextStyle(fontSize: 100));
                    }
                    return Opacity(
                      opacity: _treeGrowController.isAnimating ? 1.0 : 0.0,
                      child: Text(selectedTree.emoji, style: TextStyle(fontSize: 60 + (_treeGrowAnimation.value * 40))),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Text(_timeDisplay, style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: _secondsLeft < 60 ? Colors.red : null,
                )),
                const SizedBox(height: 8),
                SizedBox(
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: 1.0 - _progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey.withAlpha(50),
                      valueColor: AlwaysStoppedAnimation(
                        _secondsLeft < 60 ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text('🔵 وقت التركيز',
                  style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 12),
                if (_currentPhrase.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withAlpha(15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _currentPhrase,
                      style: TextStyle(fontSize: 13, color: Colors.blue.shade700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isRunning)
                      OutlinedButton.icon(
                        onPressed: _pauseTimer,
                        icon: const Icon(Icons.pause),
                        label: const Text('إيقاف مؤقت'),
                      )
                    else
                      FilledButton.icon(
                        onPressed: _resumeTimer,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('استمرار'),
                      ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: _cancelTimer,
                      icon: const Icon(Icons.close, color: Colors.red),
                      label: const Text('إلغاء', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
