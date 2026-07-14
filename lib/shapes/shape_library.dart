import '../utils/path_builder.dart';

class ShapeDef {
  final String id;
  final String name;
  final String category;
  final bool popular;
  final String path;

  const ShapeDef({
    required this.id,
    required this.name,
    required this.category,
    this.popular = false,
    required this.path,
  });
}

const ShapeDef kCircle = ShapeDef(id: 'circle', name: 'Circle', category: 'Popular', popular: true, path: 'M50,2 A48,48 0 1,1 49.99,2 Z');
const ShapeDef kSquare = ShapeDef(id: 'square', name: 'Square', category: 'Popular', popular: true, path: 'M5,5 H95 V95 H5 Z');
const ShapeDef kRoundedSquare = ShapeDef(id: 'roundedSquare', name: 'Rounded Square', category: 'Popular', popular: true, path: 'M20,5 H80 Q95,5 95,20 V80 Q95,95 80,95 H20 Q5,95 5,80 V20 Q5,5 20,5 Z');
const ShapeDef kHeart = ShapeDef(id: 'heart', name: 'Heart', category: 'Popular', popular: true, path: heartPath);
const ShapeDef kStar = ShapeDef(id: 'star', name: 'Star', category: 'Popular', popular: true, path: 'M50,5 L61,40 L98,40 L68,63 L78,100 L50,78 L22,100 L32,63 L2,40 L39,40 Z');
const ShapeDef kHexagon = ShapeDef(id: 'hexagon', name: 'Hexagon', category: 'Popular', popular: true, path: 'M50,2 L93,25 L93,75 L50,98 L7,75 L7,25 Z');
const ShapeDef kTriangle = ShapeDef(id: 'triangle', name: 'Triangle', category: 'Popular', popular: true, path: 'M50,5 L95,85 L5,85 Z');
const ShapeDef kSquircle = ShapeDef(id: 'squircle', name: 'Squircle', category: 'Popular', popular: true, path: squirclePath);

const ShapeDef kRectangle = ShapeDef(id: 'rectangle', name: 'Rectangle', category: 'Basic', path: 'M5,20 H95 V80 H5 Z');
const ShapeDef kVerticalRect = ShapeDef(id: 'vertical-rectangle', name: 'Vertical Rect', category: 'Basic', path: 'M20,5 H80 V95 H20 Z');
const ShapeDef kEllipse = ShapeDef(id: 'ellipse', name: 'Ellipse', category: 'Basic', path: 'M50,20 A45,30 0 1,1 49.99,20 Z');
const ShapeDef kVerticalEllipse = ShapeDef(id: 'vertical-ellipse', name: 'Vertical Ellipse', category: 'Basic', path: 'M50,5 A30,45 0 1,1 49.99,5 Z');
const ShapeDef kPill = ShapeDef(id: 'pill', name: 'Pill', category: 'Basic', path: pillPath);
const ShapeDef kRoundedRect = ShapeDef(id: 'rounded-rect', name: 'Rounded Rect', category: 'Basic', path: 'M15,20 H85 Q95,20 95,30 V70 Q95,80 85,80 H15 Q5,80 5,70 V30 Q5,20 15,20 Z');

const ShapeDef kPentagon = ShapeDef(id: 'pentagon', name: 'Pentagon', category: 'Geometric', path: 'M50,2 L95,35 L80,90 L20,90 L5,35 Z');
const ShapeDef kHeptagon = ShapeDef(id: 'heptagon', name: 'Heptagon', category: 'Geometric', path: 'M50,2 L85,20 L95,55 L75,90 L25,90 L5,55 L15,20 Z');
const ShapeDef kOctagon = ShapeDef(id: 'octagon', name: 'Octagon', category: 'Geometric', path: 'M30,5 L70,5 L95,30 L95,70 L70,95 L30,95 L5,70 L5,30 Z');
const ShapeDef kNonagon = ShapeDef(id: 'nonagon', name: 'Nonagon', category: 'Geometric', path: 'M50,2 L80,20 L95,50 L85,80 L60,95 L40,95 L15,80 L5,50 L20,20 Z');
const ShapeDef kDecagon = ShapeDef(id: 'decagon', name: 'Decagon', category: 'Geometric', path: 'M50,2 L80,15 L95,40 L95,65 L80,90 L50,98 L20,90 L5,65 L5,40 L20,15 Z');
const ShapeDef kDodecagon = ShapeDef(id: 'dodecagon', name: '12-gon', category: 'Geometric', path: 'M50,2 L75,10 L93,30 L93,60 L75,80 L50,95 L25,80 L7,60 L7,30 L25,10 Z');
const ShapeDef kDiamond = ShapeDef(id: 'diamond', name: 'Diamond', category: 'Geometric', path: 'M50,5 L95,50 L50,95 L5,50 Z');
const ShapeDef kParallelogram = ShapeDef(id: 'parallelogram', name: 'Parallelogram', category: 'Geometric', path: 'M25,15 H95 L75,85 H5 Z');
const ShapeDef kTrapezoid = ShapeDef(id: 'trapezoid', name: 'Trapezoid', category: 'Geometric', path: 'M20,15 H80 L95,85 H5 Z');
const ShapeDef kKite = ShapeDef(id: 'kite', name: 'Kite', category: 'Geometric', path: 'M50,5 L90,40 L50,95 L10,40 Z');
const ShapeDef kChevron = ShapeDef(id: 'chevron', name: 'Chevron', category: 'Geometric', path: 'M10,15 L60,15 L90,50 L60,85 L10,85 L40,50 Z');
const ShapeDef kRhombus = ShapeDef(id: 'rhombus', name: 'Rhombus', category: 'Geometric', path: 'M50,10 L85,50 L50,90 L15,50 Z');

const ShapeDef kStar4 = ShapeDef(id: 'star4', name: '4-Star', category: 'Stars', path: 'M50,2 L65,35 L98,35 L72,58 L82,95 L50,70 L18,95 L28,58 L2,35 L35,35 Z');
const ShapeDef kStar5 = ShapeDef(id: 'star5', name: '5-Star', category: 'Stars', path: 'M50,2 L62,40 L98,40 L70,63 L80,98 L50,76 L20,98 L30,63 L2,40 L38,40 Z');
const ShapeDef kStar6 = ShapeDef(id: 'star6', name: '6-Star', category: 'Stars', path: 'M50,2 L65,20 L85,25 L72,45 L78,70 L55,65 L50,85 L45,65 L22,70 L28,45 L15,25 L35,20 Z');
const ShapeDef kStar7 = ShapeDef(id: 'star7', name: '7-Star', category: 'Stars', path: 'M50,2 L62,22 L85,20 L72,40 L88,60 L65,58 L55,78 L45,58 L22,60 L38,40 L25,20 L48,22 Z');
const ShapeDef kStar8 = ShapeDef(id: 'star8', name: '8-Star', category: 'Stars', path: 'M50,2 L60,20 L80,15 L72,35 L92,48 L72,60 L80,82 L60,70 L50,88 L40,70 L20,82 L28,60 L8,48 L28,35 L20,15 L40,20 Z');
const ShapeDef kStarburst = ShapeDef(id: 'starburst', name: 'Starburst', category: 'Stars', path: 'M50,2 L55,15 L65,10 L62,22 L75,20 L68,30 L80,32 L70,42 L82,48 L68,55 L75,68 L62,62 L65,78 L55,68 L50,80 L45,68 L35,78 L38,62 L25,68 L32,55 L18,48 L30,42 L20,32 L32,30 L25,20 L38,22 L35,10 L45,15 Z');

const ShapeDef kPlus = ShapeDef(id: 'plus', name: 'Plus', category: 'Symbols', path: plusPath);
const ShapeDef kCross = ShapeDef(id: 'cross', name: 'Cross', category: 'Symbols', path: crossPath);
const ShapeDef kArrow = ShapeDef(id: 'arrow', name: 'Arrow', category: 'Symbols', path: arrowPath);
const ShapeDef kShield = ShapeDef(id: 'shield', name: 'Shield', category: 'Symbols', path: shieldPath);
const ShapeDef kRing = ShapeDef(id: 'ring', name: 'Ring', category: 'Symbols', path: ringPath);

const ShapeDef kCloud = ShapeDef(id: 'cloud', name: 'Cloud', category: 'Organic', path: cloudPath);
const ShapeDef kDroplet = ShapeDef(id: 'droplet', name: 'Droplet', category: 'Organic', path: dropletPath);
const ShapeDef kBean = ShapeDef(id: 'bean', name: 'Bean', category: 'Organic', path: beanPath);
const ShapeDef kLeaf = ShapeDef(id: 'leaf', name: 'Leaf', category: 'Organic', path: 'M10,90 Q10,30 50,10 Q90,30 90,50 Q90,90 50,90 Q30,75 10,90 Z');
const ShapeDef kSpeech = ShapeDef(id: 'speech', name: 'Speech Bubble', category: 'Organic', path: speechPath);

List<ShapeDef> allShapes = [
  kCircle, kSquare, kRoundedSquare, kHeart, kStar, kHexagon, kTriangle, kSquircle,
  kRectangle, kVerticalRect, kEllipse, kVerticalEllipse, kPill, kRoundedRect,
  kPentagon, kHeptagon, kOctagon, kNonagon, kDecagon, kDodecagon, kDiamond, kParallelogram, kTrapezoid, kKite, kChevron, kRhombus,
  kStar4, kStar5, kStar6, kStar7, kStar8, kStarburst,
  kPlus, kCross, kArrow, kShield, kRing,
  kCloud, kDroplet, kBean, kLeaf, kSpeech,
];

List<String> shapeCategories = ['Popular', 'Basic', 'Geometric', 'Stars', 'Symbols', 'Organic'];

ShapeDef? getShapeById(String id) {
  try {
    return allShapes.firstWhere((s) => s.id == id);
  } catch (_) {
    return null;
  }
}
