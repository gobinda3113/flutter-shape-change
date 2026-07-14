import 'package:flutter/material.dart';
import '../shapes/shape_library.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const features = [
    _Feature(icon: Icons.category, title: '50+ Premium Shapes', desc: 'Circles, polygons, stars, organic shapes, symbols, and filter presets for endless creative possibilities.'),
    _Feature(icon: Icons.lock_outline, title: '100% Private', desc: 'Every pixel is processed on your device. No servers, no uploads, no tracking \u2014 ever.'),
    _Feature(icon: Icons.bolt, title: 'Real-time Editing', desc: 'Adjust shape, scale, rotation, position, effects \u2014 see every change instantly.'),
    _Feature(icon: Icons.layers, title: 'Multi-image Workflow', desc: 'Load up to 5 images. Each remembers its own shape, effects, and adjustments independently.'),
    _Feature(icon: Icons.auto_awesome, title: 'Effects & Backgrounds', desc: 'Borders, glows, drop shadows, gradients, solid colors, or transparent \u2014 full creative control.'),
    _Feature(icon: Icons.download, title: 'Export Anywhere', desc: 'Export PNG, WebP, JPEG individually \u2014 all from your device.'),
  ];

  static const faqs = [
    _Faq(q: 'How can I turn a picture into a circle without downloading software?', a: 'Our free tool lets you fit any photo into a circle image mask directly on your device. Upload, select the circle shape, and download your circle cropped image as a PNG. No software or signup needed.'),
    _Faq(q: 'Can I cut out a shape from an image for free?', a: 'Yes. You can cut out shape from image completely free with no watermarks, no limits, and no hidden fees. Choose from 50+ preset shapes.'),
    _Faq(q: 'What formats can I export my shape image to?', a: 'You can export as PNG (lossless with transparency), WebP (best compression), JPEG (smallest file), or SVG (vector mask).'),
    _Faq(q: 'Is my data safe when I upload images?', a: 'Your images never leave your device. All processing happens locally. No files are uploaded to any server, no copies are stored.'),
    _Faq(q: 'Can I use the exported images for commercial projects?', a: 'Yes. You own your images and can use them for any purpose \u2014 personal projects, social media, e-commerce, or commercial branding.'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final popular = allShapes.where((s) => s.popular).take(6).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80,
            floating: true,
            snap: true,
            title: const Text('Image Shape Masking', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
            centerTitle: false,
          ),
          SliverToBoxAdapter(child: _buildHero(context, theme, popular)),
          SliverToBoxAdapter(child: _buildFeatures(context, theme)),
          SliverToBoxAdapter(child: _buildShapeShowcase(context, theme)),
          SliverToBoxAdapter(child: _buildHowTo(context, theme)),
          SliverToBoxAdapter(child: _buildFAQ(context, theme)),
          SliverToBoxAdapter(child: _buildFooter(context, theme)),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context, ThemeData theme, List<ShapeDef> popular) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, size: 6, color: Color(0xFF10B981)),
                SizedBox(width: 8),
                Text('100% Client-side \u00B7 No signup needed',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text.rich(
            TextSpan(
              text: 'Crop Images Into ',
              style: theme.textTheme.headlineLarge,
              children: [
                TextSpan(
                  text: 'Any Shape',
                  style: const TextStyle(
                    color: Color(0xFFFA5D29),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Free online image shape editor. Crop photos into circles, hearts, stars, and 50+ custom shapes. 100% private, all processing on your device.',
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 17),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              FilledButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/editor'),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Open Shape Editor'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => Navigator.pushNamed(context, '/editor'),
                child: const Text('Tools'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              _statBox(context, 'Shapes', '50+'),
              const SizedBox(width: 12),
              _statBox(context, 'Formats', 'PNG \u00B7 WebP \u00B7 JPEG \u00B7 SVG'),
              const SizedBox(width: 12),
              _statBox(context, 'Images', 'Up to 5'),
            ],
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: popular.map((s) => _shapeTile(context, s, allShapes.indexOf(s))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _statBox(BuildContext context, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: Color(0xFF555555))),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _shapeTile(BuildContext context, ShapeDef shape, int index) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFFA5D29),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Icon(Icons.image, color: Colors.white.withAlpha(180)),
    );
  }

  Widget _buildFeatures(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      child: Column(
        children: [
          const Text('WHY CHOOSE THIS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.12, color: Color(0xFF555555))),
          const SizedBox(height: 12),
          Text('Designed for clarity, built for speed.', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
            ),
            itemCount: features.length,
            itemBuilder: (_, i) => _featureCard(context, features[i]),
          ),
        ],
      ),
    );
  }

  Widget _featureCard(BuildContext context, _Feature f) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: theme.dividerColor.withAlpha(80),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(f.icon, size: 18, color: const Color(0xFFFA5D29)),
          ),
          const Spacer(),
          Text(f.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(f.desc, style: const TextStyle(fontSize: 12, color: Color(0xFF555555))),
        ],
      ),
    );
  }

  Widget _buildShapeShowcase(BuildContext context, ThemeData theme) {
    final showcase = allShapes.take(12).toList();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Shapes & Cutouts',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFFA5D29),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/editor'),
                child: const Text('Explore all'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: showcase.length,
            itemBuilder: (_, i) => _showcaseItem(context, showcase[i]),
          ),
        ],
      ),
    );
  }

  Widget _showcaseItem(BuildContext context, ShapeDef shape) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.square, size: 40, color: const Color(0xFFFA5D29)),
          const SizedBox(height: 8),
          Text(shape.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildHowTo(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      child: Column(
        children: [
          const Text('HOW IT WORKS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.12, color: Color(0xFF555555))),
          const SizedBox(height: 12),
          Text('How to Crop a Picture into a Shape Free', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Turn any photo into a shaped image in three simple steps.', style: theme.textTheme.bodyLarge),
          const SizedBox(height: 24),
          _howToStep(theme, '1', 'Upload Your Photo', 'Select the picture you want to shape. Works with JPG, PNG, and WebP.'),
          const SizedBox(height: 16),
          _howToStep(theme, '2', 'Choose Your Shape', 'Pick from 50+ preset shapes: circle, heart, star, hexagon, and more.'),
          const SizedBox(height: 16),
          _howToStep(theme, '3', 'Download Your Image', 'Export as PNG with transparency, WebP, JPEG, or SVG.'),
        ],
      ),
    );
  }

  Widget _howToStep(ThemeData theme, String num, String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32, height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFFFA5D29),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(num, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 14, color: Color(0xFF555555))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 20),
      child: Column(
        children: [
          const Text('FAQ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.12, color: Color(0xFF555555))),
          const SizedBox(height: 12),
          Text('Common Questions', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 24),
          ...faqs.map((f) => _faqItem(theme, f)),
        ],
      ),
    );
  }

  Widget _faqItem(ThemeData theme, _Faq f) {
    return ExpansionTile(
      title: Text(f.q, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(f.a, style: const TextStyle(fontSize: 13, color: Color(0xFF555555))),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          Text('Image Shape Masking Studio', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          const Text('\u00A9 2026 Image Shape Masking Studio. All rights reserved.',
              style: TextStyle(fontSize: 12, color: Color(0xFF555555))),
          const SizedBox(height: 40),
          FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/editor'),
            icon: const Icon(Icons.edit, size: 18),
            label: const Text('Open Shape Editor'),
          ),
        ],
      ),
    );
  }
}

class _Feature {
  final IconData icon;
  final String title;
  final String desc;
  const _Feature({required this.icon, required this.title, required this.desc});
}

class _Faq {
  final String q;
  final String a;
  const _Faq({required this.q, required this.a});
}
