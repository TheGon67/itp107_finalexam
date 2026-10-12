import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PixelPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const PixelPanel({super.key, required this.child, this.padding = const EdgeInsets.all(16)});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 16),
    decoration: BoxDecoration(
      gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [AppTheme.cream, AppTheme.panelBottom]),
      border: Border.all(color: AppTheme.edge, width: 2),
      boxShadow: const [BoxShadow(color: Color(0xFF140E0A), offset: Offset(4,4))]),
    child: Stack(children: [
      Container(width: double.infinity, margin: const EdgeInsets.all(3), padding: padding,
        decoration: BoxDecoration(border: Border.all(color: const Color(0xFF70513B))), child: child),
      const Positioned(top: 0, left: 0, child: IgnorePointer(child: SizedBox(width: 5, height: 5, child: ColoredBox(color: AppTheme.forest)))),
      const Positioned(bottom: 0, right: 0, child: IgnorePointer(child: SizedBox(width: 5, height: 5, child: ColoredBox(color: AppTheme.teal)))),
    ]));
}

class PixelBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;
  const PixelBadge({super.key, required this.text, this.color = AppTheme.teal, this.icon});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(color: const Color(0xFF271A14), border: Border.all(color: color)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (icon != null) ...[Icon(icon, size: 13, color: color), const SizedBox(width: 5)],
      Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1, color: color)),
    ]));
}

class PostEmblem extends StatelessWidget {
  final String id;
  const PostEmblem({super.key, required this.id});
  @override
  Widget build(BuildContext context) {
    final color = [AppTheme.teal, AppTheme.forest, AppTheme.rose, AppTheme.gold][id.codeUnits.fold<int>(0, (sum, unit) => sum + unit) % 4];
    return Container(width: 44, height: 48, alignment: Alignment.center,
      decoration: BoxDecoration(color: const Color(0xFF2C1D16), border: Border.all(color: color, width: 2),
        boxShadow: const [BoxShadow(color: Color(0xFF160F0B), offset: Offset(2,2))]),
      child: Text(id, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, color: color)));
  }
}

class ValleyHeader extends StatelessWidget {
  final String label, subtitle;
  const ValleyHeader({super.key, required this.label, required this.subtitle});
  @override
  Widget build(BuildContext context) => PixelPanel(padding: EdgeInsets.zero,
    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Stack(children: [
        AspectRatio(aspectRatio: 3, child: Image.asset('assets/images/valley.png', fit: BoxFit.cover, filterQuality: FilterQuality.none)),
        const Positioned(left: 12, top: 12, child: PixelBadge(text: 'THE PIXEL LIBRARY', color: AppTheme.gold, icon: Icons.local_library_outlined)),
      ]),
      const SizedBox(height: 3, child: ColoredBox(color: AppTheme.teal)),
      Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.gold)),
        const SizedBox(height: 10), Text(subtitle),
        const SizedBox(height: 14),
        const Wrap(spacing: 8, runSpacing: 8, children: [
          PixelBadge(text: 'READ', icon: Icons.menu_book, color: AppTheme.forest),
          PixelBadge(text: 'SAVE', icon: Icons.star_border, color: AppTheme.gold),
          PixelBadge(text: 'MAKE NOTES', icon: Icons.edit_outlined),
        ]),
      ])),
    ]));
}
class QuestState extends StatelessWidget {
  final IconData icon;
  final String title, message;
  final Widget? action;
  const QuestState({super.key, required this.icon, required this.title, required this.message, this.action});
  @override
  Widget build(BuildContext context) => Center(child: SingleChildScrollView(
    padding: const EdgeInsets.all(24), child: PixelPanel(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 48, color: AppTheme.teal), const SizedBox(height: 16),
      Text(title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 12), Text(message, textAlign: TextAlign.center),
      if(action != null) ...[const SizedBox(height: 16), action!],
    ]))));
}
void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(text)));
}
