import 'package:flutter/material.dart';

class SoundscapesScreen extends StatefulWidget {
  const SoundscapesScreen({super.key});

  @override
  State<SoundscapesScreen> createState() => _SoundscapesScreenState();
}

class _SoundscapesScreenState extends State<SoundscapesScreen> {
  String? _currentSound;
  bool _isPlaying = false;

  final List<_SoundItem> _sounds = [
    _SoundItem('rain', '🌧️', 'مطر', 'صوت المطر الهادئ'),
    _SoundItem('forest', '🌲', 'غابة', 'أصوات الطبيعة'),
    _SoundItem('ocean', '🌊', 'بحر', 'أمواج البحر'),
    _SoundItem('cafe', '☕', 'مقهى', 'أجواء مقهى هادئة'),
    _SoundItem('fire', '🔥', 'نار', 'طقطقة النار'),
    _SoundItem('birds', '🐦', 'طيور', 'تغريد العصافير'),
    _SoundItem('wind', '💨', 'رياح', 'هواء خفيف'),
    _SoundItem('river', '🏞️', 'نهر', 'خرير الماء'),
  ];

  void _toggleSound(_SoundItem sound) {
    if (_currentSound == sound.id && _isPlaying) {
      setState(() => _isPlaying = false);
    } else {
      setState(() {
        _currentSound = sound.id;
        _isPlaying = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎵 الأصوات المحيطة')),
      body: Column(
        children: [
          if (_isPlaying)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.green.withAlpha(15),
              child: Row(
                children: [
                  const Icon(Icons.volume_up, color: Colors.green),
                  const SizedBox(width: 8),
                  Text('قيد التشغيل: ${_sounds.firstWhere((s) => s.id == _currentSound, orElse: () => _sounds.first).name}'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.stop, color: Colors.red),
                    onPressed: () => setState(() => _isPlaying = false),
                  ),
                ],
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: _sounds.length,
              itemBuilder: (context, index) {
                final sound = _sounds[index];
                final isActive = _currentSound == sound.id && _isPlaying;
                return Card(
                  elevation: isActive ? 4 : 1,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _toggleSound(sound),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: isActive ? Border.all(color: Colors.green, width: 2) : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(sound.emoji, style: const TextStyle(fontSize: 48)),
                          const SizedBox(height: 8),
                          Text(sound.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(sound.description, style: TextStyle(fontSize: 11, color: Colors.grey), textAlign: TextAlign.center),
                          const SizedBox(height: 8),
                          Icon(
                            isActive ? Icons.pause_circle_filled : Icons.play_circle_outline,
                            color: isActive ? Colors.green : Colors.grey,
                            size: 28,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SoundItem {
  final String id;
  final String emoji;
  final String name;
  final String description;
  const _SoundItem(this.id, this.emoji, this.name, this.description);
}
