import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shimmer/shimmer.dart';

class PremiumPlantCard extends StatelessWidget {
  final String plantName;
  final String scientificName;
  final String imageUrl;
  final VoidCallback? onTap;
  final bool showHealthScore;
  final double? healthScore;

  const PremiumPlantCard({
    Key? key,
    required this.plantName,
    required this.scientificName,
    required this.imageUrl,
    this.onTap,
    this.showHealthScore = false,
    this.healthScore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GlassmorphicContainer(
          width: double.infinity,
          height: 200,
          borderRadius: 20,
          blur: 20,
          alignment: Alignment.bottomCenter,
          border: 2,
          linearGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFffffff).withValues(alpha: 0.1),
              Color(0xFFffffff).withValues(alpha: 0.05),
            ],
          ),
          borderGradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFffffff).withValues(alpha: 0.5),
              Color(0xFFffffff).withValues(alpha: 0.2),
            ],
          ),
          child: Stack(
            children: [
              // Plant Image
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.local_florist, size: 50, color: Colors.grey[600]),
                    );
                  },
                ),
              ),
              
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              
              // Content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plantName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      scientificName,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    if (showHealthScore && healthScore != null) ...[
                      SizedBox(height: 8),
                      PlantHealthIndicator(score: healthScore!),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlantHealthIndicator extends StatelessWidget {
  final double score;
  final double size;

  const PlantHealthIndicator({
    Key? key,
    required this.score,
    this.size = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _getHealthColor(score);
    
    return Container(
      width: size,
      height: size / 2,
      child: Stack(
        children: [
          // Background Arc
          CustomPaint(
            size: Size(size, size / 2),
            painter: HealthArcPainter(
              progress: 1.0,
              color: Colors.white.withValues(alpha: 0.3),
              strokeWidth: 4,
            ),
          ),
          // Progress Arc
          CustomPaint(
            size: Size(size, size / 2),
            painter: HealthArcPainter(
              progress: score,
              color: color,
              strokeWidth: 4,
            ),
          ),
          // Score Text
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Text(
              '${(score * 100).round()}%',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getHealthColor(double score) {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.6) return Colors.yellow;
    if (score >= 0.4) return Colors.orange;
    return Colors.red;
  }
}

class HealthArcPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  HealthArcPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    const startAngle = 3.14159; // π (180 degrees)
    final sweepAngle = 3.14159 * progress; // π * progress

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AnimatedPlantGrid extends StatelessWidget {
  final List<Map<String, String>> plants;
  final Function(Map<String, String>) onPlantTap;
  final bool isLoading;

  const AnimatedPlantGrid({
    Key? key,
    required this.plants,
    required this.onPlantTap,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildShimmerGrid();
    }

    return AnimationLimiter(
      child: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: plants.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: PlantGridCard(
                  plant: plants[index],
                  onTap: () => onPlantTap(plants[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}

class PlantGridCard extends StatelessWidget {
  final Map<String, String> plant;
  final VoidCallback onTap;

  const PlantGridCard({
    Key? key,
    required this.plant,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              Image.network(
                plant['image'] ?? '',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(Icons.local_florist, size: 40, color: Colors.grey[600]),
                  );
                },
              ),
              
              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
              
              // Plant Info
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plant['name'] ?? 'Unknown Plant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2),
                    Text(
                      plant['scientific'] ?? '',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              // Care Difficulty Badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Easy',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CareReminderCard extends StatelessWidget {
  final String plantName;
  final String careType;
  final String description;
  final DateTime dueDate;
  final VoidCallback onComplete;
  final VoidCallback onSnooze;

  const CareReminderCard({
    Key? key,
    required this.plantName,
    required this.careType,
    required this.description,
    required this.dueDate,
    required this.onComplete,
    required this.onSnooze,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOverdue = DateTime.now().isAfter(dueDate);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 120,
        borderRadius: 16,
        blur: 15,
        alignment: Alignment.bottomCenter,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (isOverdue ? Colors.red : Colors.blue).withValues(alpha: 0.1),
            (isOverdue ? Colors.red : Colors.blue).withValues(alpha: 0.05),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            (isOverdue ? Colors.red : Colors.blue).withValues(alpha: 0.5),
            (isOverdue ? Colors.red : Colors.blue).withValues(alpha: 0.2),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              // Care Type Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (isOverdue ? Colors.red : Colors.blue).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  _getCareIcon(careType),
                  color: isOverdue ? Colors.red : Colors.blue,
                  size: 24,
                ),
              ),
              
              SizedBox(width: 16),
              
              // Care Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      plantName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      isOverdue ? 'Overdue' : _formatDueDate(dueDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: isOverdue ? Colors.red : Colors.black45,
                        fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action Buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: onComplete,
                    icon: Icon(Icons.check_circle, color: Colors.green),
                  ),
                  IconButton(
                    onPressed: onSnooze,
                    icon: Icon(Icons.snooze, color: Colors.orange),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getCareIcon(String careType) {
    switch (careType.toLowerCase()) {
      case 'watering':
        return Icons.water_drop;
      case 'fertilizing':
        return Icons.eco;
      case 'pruning':
        return Icons.content_cut;
      case 'repotting':
        return Icons.grass;
      case 'lighting':
        return Icons.wb_sunny;
      default:
        return Icons.local_florist;
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;
    
    if (difference == 0) return 'Due today';
    if (difference == 1) return 'Due tomorrow';
    if (difference > 1) return 'Due in $difference days';
    return 'Overdue';
  }
}

class PlantSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final Function()? onFilter;
  final String hintText;

  const PlantSearchBar({
    Key? key,
    required this.onSearch,
    this.onFilter,
    this.hintText = 'Search plants...',
  }) : super(key: key);

  @override
  _PlantSearchBarState createState() => _PlantSearchBarState();
}

class _PlantSearchBarState extends State<PlantSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 56,
        borderRadius: 28,
        blur: 20,
        alignment: Alignment.bottomCenter,
        border: 2,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFffffff).withValues(alpha: 0.1),
            Color(0xFFffffff).withValues(alpha: 0.05),
          ],
        ),
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFffffff).withValues(alpha: 0.5),
            Color(0xFFffffff).withValues(alpha: 0.2),
          ],
        ),
        child: TextField(
          controller: _controller,
          onChanged: widget.onSearch,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.black54),
            prefixIcon: Icon(Icons.search, color: Colors.black54),
            suffixIcon: widget.onFilter != null
                ? IconButton(
                    icon: Icon(Icons.tune, color: Colors.black54),
                    onPressed: widget.onFilter,
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}