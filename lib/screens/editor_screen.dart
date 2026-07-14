import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/editor_state.dart';
import '../utils/image_utils.dart';
import '../widgets/canvas_widget.dart';
import '../widgets/shape_picker_widget.dart';
import '../widgets/slider_row_widget.dart';
import '../widgets/toggle_row_widget.dart';
import '../widgets/color_row_widget.dart';
import '../widgets/filter_presets_widget.dart';
import '../widgets/toast_widget.dart';

class EditorScreen extends StatefulWidget {
  final String? initialShape;

  const EditorScreen({super.key, this.initialShape});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  final List<ImageItem> _images = [];
  String? _activeId;
  double _zoom = 1;
  final TransformationController _transformCtrl = TransformationController();
  final GlobalKey _canvasKey = GlobalKey();

  String _exportFormat = 'png';
  double _exportQuality = 0;
  int _exportWidth = 1000;
  int _exportHeight = 1000;
  bool _lockAspect = true;
  int _rightTabIndex = 0;

  ImageItem? get _active => _images.where((i) => i.id == _activeId).firstOrNull;

  Future<void> _pickImage() async {
    final bytes = await pickImage();
    if (bytes == null) return;

    try {
      final img = await loadImageBytes(bytes);
      final item = ImageItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'Image ${_images.length + 1}',
        image: img,
        shapeId: widget.initialShape ?? 'circle',
      );
      setState(() {
        _images.add(item);
        _activeId = item.id;
        _exportWidth = img.width;
        _exportHeight = img.height;
      });
      ToastService.instance.success('Image added');
    } catch (_) {
      ToastService.instance.danger('Failed to load image');
    }
  }

  void _removeImage(String id) {
    setState(() {
      _images.removeWhere((i) => i.id == id);
      if (_activeId == id) {
        _activeId = _images.isNotEmpty ? _images.last.id : null;
      }
    });
  }

  void _updateShape(String shapeId) {
    if (_active == null) return;
    setState(() => _active!.shapeId = shapeId);
  }

  void _updateAdjust(Map<String, dynamic> patch) {
    if (_active == null) return;
    setState(() {
      if (patch.containsKey('scale')) _active!.adjust.scale = (patch['scale'] as num).toDouble();
      if (patch.containsKey('rotation')) _active!.adjust.rotation = (patch['rotation'] as num).toDouble();
      if (patch.containsKey('offsetX')) _active!.adjust.offsetX = (patch['offsetX'] as num).toDouble();
      if (patch.containsKey('offsetY')) _active!.adjust.offsetY = (patch['offsetY'] as num).toDouble();
      if (patch.containsKey('brightness')) _active!.adjust.brightness = (patch['brightness'] as num).toDouble();
      if (patch.containsKey('contrast')) _active!.adjust.contrast = (patch['contrast'] as num).toDouble();
      if (patch.containsKey('saturation')) _active!.adjust.saturation = (patch['saturation'] as num).toDouble();
      if (patch.containsKey('blur')) _active!.adjust.blur = (patch['blur'] as num).toDouble();
      if (patch.containsKey('filter')) _active!.adjust.filter = patch['filter'] as String;
    });
  }

  void _updateEffects(Map<String, dynamic> patch) {
    if (_active == null) return;
    setState(() {
      if (patch.containsKey('border')) _active!.effects.border = patch['border'] as bool;
      if (patch.containsKey('borderSize')) _active!.effects.borderSize = (patch['borderSize'] as num).toDouble();
      if (patch.containsKey('borderColor')) _active!.effects.borderColor = patch['borderColor'] as Color;
      if (patch.containsKey('shadow')) _active!.effects.shadow = patch['shadow'] as bool;
      if (patch.containsKey('shadowBlur')) _active!.effects.shadowBlur = (patch['shadowBlur'] as num).toDouble();
      if (patch.containsKey('shadowOffsetX')) _active!.effects.shadowOffsetX = (patch['shadowOffsetX'] as num).toDouble();
      if (patch.containsKey('shadowOffsetY')) _active!.effects.shadowOffsetY = (patch['shadowOffsetY'] as num).toDouble();
      if (patch.containsKey('shadowColor')) _active!.effects.shadowColor = patch['shadowColor'] as Color;
      if (patch.containsKey('glow')) _active!.effects.glow = patch['glow'] as bool;
      if (patch.containsKey('glowSize')) _active!.effects.glowSize = (patch['glowSize'] as num).toDouble();
      if (patch.containsKey('glowColor')) _active!.effects.glowColor = patch['glowColor'] as Color;
    });
  }

  void _updateBg(Map<String, dynamic> patch) {
    if (_active == null) return;
    setState(() {
      if (patch.containsKey('type')) _active!.bg.type = patch['type'] as String;
      if (patch.containsKey('color')) _active!.bg.color = patch['color'] as Color;
      if (patch.containsKey('color2')) _active!.bg.color2 = patch['color2'] as Color;
      if (patch.containsKey('angle')) _active!.bg.angle = (patch['angle'] as num).toDouble();
    });
  }

  void _resetActive() {
    if (_active == null) return;
    setState(() {
      _active!.adjust = AdjustConfig();
      _active!.effects = EffectConfig();
      _active!.bg = BgConfig();
    });
    ToastService.instance.info('Reset to defaults');
  }

  Future<void> _exportImage() async {
    if (_active == null) return;
    try {
      final bytes = await captureCanvas(_canvasKey, width: _exportWidth, height: _exportHeight);
      if (bytes == null) { ToastService.instance.danger('Export failed'); return; }

      final ext = _exportFormat == 'jpeg' ? 'jpg' : _exportFormat;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final xfile = XFile.fromData(
        bytes,
        name: '${_active!.name}-mask-$timestamp.$ext',
        mimeType: _exportFormat == 'png' ? 'image/png' : 'image/jpeg',
      );

      await Share.shareXFiles([xfile], text: 'Created with Image Shape Masking Studio');
      ToastService.instance.success('Exported successfully');
    } catch (e) {
      ToastService.instance.danger('Export failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: _buildAppBar(theme),
      body: isLandscape ? _buildLandscapeLayout(theme) : _buildPortraitLayout(theme),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      title: const Text('Shape Editor', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      actions: [
        if (_active != null)
          IconButton(
            icon: const Icon(Icons.download, color: Color(0xFFFA5D29)),
            onPressed: _exportImage,
            tooltip: 'Export',
          ),
        IconButton(
          icon: const Icon(Icons.add_photo_alternate_outlined),
          onPressed: _pickImage,
          tooltip: 'Add Image',
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(ThemeData theme) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            color: theme.brightness == Brightness.dark ? const Color(0xFF0D0D0D) : const Color(0xFFE5E5DC),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildCanvas(),
                Positioned(
                  top: 8,
                  child: _buildCanvasToolbar(),
                ),
                if (_active == null) _buildEmptyState(),
              ],
            ),
          ),
        ),
        _buildBottomControls(theme),
      ],
    );
  }

  Widget _buildLandscapeLayout(ThemeData theme) {
    return Row(
      children: [
        SizedBox(
          width: 240,
          child: _buildShapePanel(theme),
        ),
        Expanded(
          child: Container(
            color: theme.brightness == Brightness.dark ? const Color(0xFF0D0D0D) : const Color(0xFFE5E5DC),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildCanvas(),
                Positioned(
                  top: 8,
                  child: _buildCanvasToolbar(),
                ),
                if (_active == null) _buildEmptyState(),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 280,
          child: _buildRightPanel(theme),
        ),
      ],
    );
  }

  Widget _buildCanvas() {
    return RepaintBoundary(
      key: _canvasKey,
      child: InteractiveViewer(
        transformationController: _transformCtrl,
        minScale: 0.25,
        maxScale: 5.0,
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(4),
          ),
          child: MaskedImageCanvas(item: _active, zoom: _zoom),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor, width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_upload_outlined, size: 56, color: Theme.of(context).disabledColor),
            const SizedBox(height: 16),
            Text('Add an Image', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Tap to upload from your gallery', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildCanvasToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color?.withAlpha(225),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _iconBtn(Icons.zoom_out, () => setState(() => _zoom = (_zoom / 1.2).clamp(0.25, 5.0))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text('${(_zoom * 100).round()}%',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ),
          _iconBtn(Icons.zoom_in, () => setState(() => _zoom = (_zoom * 1.2).clamp(0.25, 5.0))),
          Container(width: 1, height: 20, margin: const EdgeInsets.symmetric(horizontal: 4),
              color: Theme.of(context).dividerColor),
          _iconBtn(Icons.fit_screen, () => setState(() => _zoom = 1)),
        ],
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return SizedBox(
      width: 34,
      height: 34,
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onTap,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildBottomControls(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_images.isNotEmpty)
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ..._images.map((img) => _buildImageThumb(img)),
                if (_images.length < 5)
                  _buildAddThumb(),
              ],
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            border: Border(top: BorderSide(color: theme.dividerColor)),
          ),
          child: Row(
            children: [
              _buildTabButton('Adjust', Icons.tune, 0),
              _buildTabButton('Design', Icons.palette_outlined, 1),
              _buildTabButton('Export', Icons.file_download_outlined, 2),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: _buildPanelContent(theme),
        ),
      ],
    );
  }

  Widget _buildImageThumb(ImageItem img) {
    final isActive = img.id == _activeId;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isActive ? const Color(0xFFFA5D29) : Colors.transparent, width: 2),
              color: Theme.of(context).cardTheme.color,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => setState(() => _activeId = img.id),
                child: img.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: RawImage(image: img.image, fit: BoxFit.cover, width: 44, height: 44),
                      )
                    : const Icon(Icons.image, size: 20),
              ),
            ),
          ),
          Positioned(
            top: -4, right: -4,
            child: GestureDetector(
              onTap: () => _removeImage(img.id),
              child: Container(
                width: 16, height: 16,
                decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 10, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddThumb() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Theme.of(context).dividerColor, width: 2),
        ),
        child: const Icon(Icons.add, size: 18),
      ),
    );
  }

  Widget _buildTabButton(String label, IconData icon, int index) {
    final isActive = _rightTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _rightTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: isActive ? const Color(0xFFFA5D29) : Colors.transparent, width: 2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: isActive ? const Color(0xFFFA5D29) : null),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
                  color: isActive ? const Color(0xFFFA5D29) : null)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanelContent(ThemeData theme) {
    if (_active == null) {
      return Center(
        child: Text('Add an image to start editing', style: TextStyle(color: theme.disabledColor)),
      );
    }

    switch (_rightTabIndex) {
      case 0: return _buildAdjustPanel();
      case 1: return _buildDesignPanel();
      case 2: return _buildExportPanel();
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildAdjustPanel() {
    if (_active == null) return const SizedBox.shrink();
    final a = _active!.adjust;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 140,
            child: ShapePickerWidget(
              activeShapeId: _active!.shapeId,
              onShapeSelected: _updateShape,
            ),
          ),
          const Divider(),
          SliderRow(label: 'Scale', value: a.scale, min: 10, max: 300, unit: '%', decimals: 0, onChange: (v) => _updateAdjust({'scale': v})),
          SliderRow(label: 'Rotation', value: a.rotation, min: -180, max: 180, unit: '\u00B0', decimals: 0, onChange: (v) => _updateAdjust({'rotation': v})),
          SliderRow(label: 'Offset X', value: a.offsetX, min: -100, max: 100, unit: '%', decimals: 0, onChange: (v) => _updateAdjust({'offsetX': v})),
          SliderRow(label: 'Offset Y', value: a.offsetY, min: -100, max: 100, unit: '%', decimals: 0, onChange: (v) => _updateAdjust({'offsetY': v})),
          const Divider(),
          FilterPresetsWidget(active: a.filter, onChange: (f) => _updateAdjust({'filter': f})),
          const Divider(),
          SliderRow(label: 'Brightness', value: a.brightness, min: 0, max: 200, unit: '%', decimals: 0, onChange: (v) => _updateAdjust({'brightness': v})),
          SliderRow(label: 'Contrast', value: a.contrast, min: 0, max: 200, unit: '%', decimals: 0, onChange: (v) => _updateAdjust({'contrast': v})),
          SliderRow(label: 'Saturation', value: a.saturation, min: 0, max: 200, unit: '%', decimals: 0, onChange: (v) => _updateAdjust({'saturation': v})),
          SliderRow(label: 'Blur', value: a.blur, min: 0, max: 20, unit: 'px', step: 0.5, decimals: 1, onChange: (v) => _updateAdjust({'blur': v})),
          const Divider(),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(onPressed: _resetActive, child: const Text('Reset All')),
          ),
        ],
      ),
    );
  }

  Widget _buildDesignPanel() {
    if (_active == null) return const SizedBox.shrink();
    final bg = _active!.bg;
    final e = _active!.effects;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('BACKGROUND', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: Color(0xFF555555))),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildBgChip('Transparent', 'transparent'),
              const SizedBox(width: 8),
              _buildBgChip('Solid', 'solid'),
              const SizedBox(width: 8),
              _buildBgChip('Gradient', 'gradient'),
            ],
          ),
          if (bg.type != 'transparent') ...[
            const SizedBox(height: 8),
            ColorRow(label: 'Color', value: bg.color, onChange: (c) => _updateBg({'color': c})),
            if (bg.type == 'gradient') ...[
              ColorRow(label: 'To', value: bg.color2, onChange: (c) => _updateBg({'color2': c})),
              SliderRow(label: 'Angle', value: bg.angle, min: 0, max: 360, unit: '\u00B0', decimals: 0, onChange: (v) => _updateBg({'angle': v})),
            ],
          ],
          const Divider(),
          const Text('BORDER', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: Color(0xFF555555))),
          ToggleRow(label: 'Border', checked: e.border, onChange: (v) => _updateEffects({'border': v})),
          if (e.border) ...[
            SliderRow(label: 'Width', value: e.borderSize, min: 1, max: 30, unit: 'px', decimals: 0, onChange: (v) => _updateEffects({'borderSize': v})),
            ColorRow(label: 'Color', value: e.borderColor, onChange: (c) => _updateEffects({'borderColor': c})),
          ],
          const Divider(),
          const Text('SHADOW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: Color(0xFF555555))),
          ToggleRow(label: 'Shadow', checked: e.shadow, onChange: (v) => _updateEffects({'shadow': v})),
          if (e.shadow) ...[
            SliderRow(label: 'Blur', value: e.shadowBlur, min: 0, max: 80, unit: 'px', decimals: 0, onChange: (v) => _updateEffects({'shadowBlur': v})),
            SliderRow(label: 'Offset X', value: e.shadowOffsetX, min: -40, max: 40, unit: 'px', decimals: 0, onChange: (v) => _updateEffects({'shadowOffsetX': v})),
            SliderRow(label: 'Offset Y', value: e.shadowOffsetY, min: -40, max: 40, unit: 'px', decimals: 0, onChange: (v) => _updateEffects({'shadowOffsetY': v})),
            ColorRow(label: 'Color', value: e.shadowColor, onChange: (c) => _updateEffects({'shadowColor': c})),
          ],
          const Divider(),
          const Text('GLOW', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: Color(0xFF555555))),
          ToggleRow(label: 'Glow', checked: e.glow, onChange: (v) => _updateEffects({'glow': v})),
          if (e.glow) ...[
            SliderRow(label: 'Size', value: e.glowSize, min: 0, max: 80, unit: 'px', decimals: 0, onChange: (v) => _updateEffects({'glowSize': v})),
            ColorRow(label: 'Color', value: e.glowColor, onChange: (c) => _updateEffects({'glowColor': c})),
          ],
        ],
      ),
    );
  }

  Widget _buildBgChip(String label, String type) {
    final isActive = _active!.bg.type == type;
    return Expanded(
      child: ChoiceChip(
        label: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        selected: isActive,
        onSelected: (_) => _updateBg({'type': type}),
      ),
    );
  }

  Widget _buildRightPanel(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
          child: Row(
            children: [
              _buildPanelTab('Adjust', 0),
              const SizedBox(width: 8),
              _buildPanelTab('Design', 1),
              const SizedBox(width: 8),
              _buildPanelTab('Export', 2),
            ],
          ),
        ),
        Expanded(
          child: _buildPanelContent(theme),
        ),
      ],
    );
  }

  Widget _buildPanelTab(String label, int index) {
    final isActive = _rightTabIndex == index;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
          color: isActive ? Colors.white : null)),
      selected: isActive,
      onSelected: (_) => setState(() => _rightTabIndex = index),
      selectedColor: const Color(0xFFFA5D29),
    );
  }

  Widget _buildShapePanel(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.upload, size: 18),
              label: const Text('Upload Image'),
            ),
          ),
          const SizedBox(height: 16),
          const Text('SHAPES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.08)),
          const SizedBox(height: 8),
          Expanded(
            child: ShapePickerWidget(
              activeShapeId: _active?.shapeId ?? 'circle',
              onShapeSelected: _updateShape,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportPanel() {
    if (_active == null) return const SizedBox.shrink();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('FORMAT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: Color(0xFF555555))),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: ['png', 'webp', 'jpeg', 'svg'].map((f) {
              final isActive = _exportFormat == f;
              return ChoiceChip(
                label: Text(f.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                selected: isActive,
                onSelected: (_) => setState(() => _exportFormat = f),
              );
            }).toList(),
          ),
          const Divider(),
          const Text('SIZE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: Color(0xFF555555))),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Width', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: _exportWidth.toString()),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null && n >= 50) {
                      setState(() {
                        _exportWidth = n;
                        if (_lockAspect && _active?.image != null) {
                          _exportHeight = (_exportWidth * _active!.image!.height / _active!.image!.width).round();
                        }
                      });
                    }
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.close, size: 14),
              ),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Height', isDense: true, contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: _exportHeight.toString()),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null && n >= 50) setState(() => _exportHeight = n);
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(value: _lockAspect, onChanged: (v) => setState(() => _lockAspect = v ?? false)),
              const Text('Lock aspect ratio', style: TextStyle(fontSize: 12)),
            ],
          ),
          const Divider(),
          SliderRow(label: 'Quality', value: _exportQuality, min: 0, max: 100, unit: '%', decimals: 0,
              onChange: (v) => setState(() => _exportQuality = v)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _exportImage,
              icon: const Icon(Icons.download, size: 18),
              label: Text('Export (${_exportWidth}x$_exportHeight)'),
            ),
          ),
        ],
      ),
    );
  }
}
