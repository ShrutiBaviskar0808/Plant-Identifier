import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../core/effects/premium_effects_service.dart';

class Plant3DViewer extends StatefulWidget {
  final String plantName;
  final String modelPath;
  final double healthScore;
  final bool showHealthAura;

  const Plant3DViewer({
    super.key,
    required this.plantName,
    required this.modelPath,
    this.healthScore = 0.8,
    this.showHealthAura = true,
  });

  @override
  State<Plant3DViewer> createState() => _Plant3DViewerState();
}

class _Plant3DViewerState extends State<Plant3DViewer>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _breathingController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _breathingController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _breathingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.8),
            Colors.green.withValues(alpha: 0.2),
            Colors.black.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          _buildBackgroundParticles(),
          if (_isLoading) _buildLoadingView() else _buildModelView(),
          if (widget.showHealthAura && !_isLoading) _buildHealthAura(),
          _buildControlsOverlay(),
          _buildInfoPanel(),
        ],
      ),
    );
  }

  Widget _buildBackgroundParticles() {
    return Positioned.fill(
      child: Stack(
        children: List.generate(15, (index) {
          return Positioned(
            left: (index * 40.0) % 350,
            top: (index * 60.0) % 350,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.5, end: 1.5),
              duration: Duration(seconds: 3),
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 3,
                    height: 3,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green.withValues(alpha: 0.4),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RotationTransition(
            turns: _rotationController,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.green, Colors.lightGreen],
                ),
              ),
              child: Icon(
                Icons.local_florist,
                color: Colors.white,
                size: 40,
              ),
            ),
          ),
          
          SizedBox(height: 20),
          
          PremiumEffectsService.createShimmerEffect(
            child: Text(
              'Loading 3D Model...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModelView() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 1000),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ModelViewer(
          backgroundColor: Colors.transparent,
          src: widget.modelPath,
          alt: '3D model of ${widget.plantName}',
          ar: true,
          autoRotate: true,
          cameraControls: true,
          disableZoom: false,
          shadowIntensity: 0.7,
          shadowSoftness: 0.5,
          environmentImage: 'assets/environments/studio.hdr',
          exposure: 1.0,
          animationName: 'growth_animation',
          autoPlay: true,
        ),
      ),
    );
  }

  Widget _buildHealthAura() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _breathingController,
        builder: (context, child) {
          final auraSize = 1.0 + (_breathingController.value * 0.1);
          return Transform.scale(
            scale: auraSize,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _getHealthColor().withValues(alpha: 0.3),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Positioned(
      top: 15,
      right: 15,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600),
        child: Column(
          children: [
            _buildControlButton(
              icon: Icons.threesixty,
              onTap: () {
                _rotationController.reset();
                _rotationController.forward();
              },
              tooltip: 'Rotate',
            ),
            SizedBox(height: 10),
            _buildControlButton(
              icon: Icons.fullscreen,
              onTap: () => _showFullscreen(),
              tooltip: 'Fullscreen',
            ),
            SizedBox(height: 10),
            _buildControlButton(
              icon: Icons.view_in_ar,
              onTap: () => _openAR(),
              tooltip: 'AR View',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 1.05),
        duration: Duration(seconds: 2),
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: GestureDetector(
              onTap: onTap,
              child: PremiumEffectsService.createGlassCard(
                blur: 10,
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoPanel() {
    return Positioned(
      bottom: 15,
      left: 15,
      right: 15,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 800),
        child: PremiumEffectsService.createGlassCard(
          child: Container(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.plantName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '3D Interactive Model',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: _getHealthColor().withValues(alpha: 0.2),
                    border: Border.all(
                      color: _getHealthColor(),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: _getHealthColor(),
                        size: 16,
                      ),
                      SizedBox(width: 5),
                      Text(
                        '${(widget.healthScore * 100).toInt()}%',
                        style: TextStyle(
                          color: _getHealthColor(),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getHealthColor() {
    if (widget.healthScore > 0.7) return Colors.green;
    if (widget.healthScore > 0.4) return Colors.orange;
    return Colors.red;
  }

  void _showFullscreen() {
    Navigator.of(context).push(
      PremiumEffectsService.createCinematicRoute(
        page: Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Plant3DViewer(
                  plantName: widget.plantName,
                  modelPath: widget.modelPath,
                  healthScore: widget.healthScore,
                ),
                Positioned(
                  top: 20,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: PremiumEffectsService.createGlassCard(
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openAR() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('AR View - Coming Soon!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}