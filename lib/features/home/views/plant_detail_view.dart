import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;
import '../../../core/data/models/plant_catalog.dart';
import '../../../core/data/models/plant_api_model.dart';

class PlantDetailView extends StatefulWidget {
  final PlantCatalogItem? plant;
  final PlantApiModel? plantApi;

  const PlantDetailView({super.key, this.plant, this.plantApi});

  @override
  State<PlantDetailView> createState() => _PlantDetailViewState();
}

class _PlantDetailViewState extends State<PlantDetailView> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentImageIndex = 0;
  late AnimationController _animationController;
  late AnimationController _slideController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<Color?> _colorAnimation;
  bool _isImageExpanded = false;

  String get plantName => widget.plant?.name ?? widget.plantApi?.name ?? '';
  String get scientificName => widget.plant?.scientificName ?? widget.plantApi?.scientificName ?? '';
  String get description => widget.plant?.description ?? widget.plantApi?.description ?? '';
  List<String> get imageUrls => widget.plant?.imageUrl != null ? [widget.plant!.imageUrl] : (widget.plantApi?.imageUrl != null ? [widget.plantApi!.imageUrl] : []);
  bool get isApiPlant => widget.plantApi != null;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    
    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    _colorAnimation = ColorTween(
      begin: Colors.green.withValues(alpha: 0.1),
      end: Colors.green.withValues(alpha: 0.3),
    ).animate(_floatingController);
    
    _animationController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    if (mounted) {
      _floatingController.stop();
      _animationController.stop();
      _slideController.stop();
    }
    _pageController.dispose();
    _animationController.dispose();
    _slideController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _fadeAnimation.value,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  );
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: _build3DImageSlider(),
              ),
            ),
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _build3DImageSlider() {
    final images = imageUrls.isNotEmpty ? imageUrls : ['assets/images/plant_placeholder.jpg'];
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withValues(alpha: 0.1),
            Colors.blue.withValues(alpha: 0.05),
            Colors.purple.withValues(alpha: 0.1),
          ],
        ),
      ),
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Positioned(
                top: 40 + _floatingAnimation.value,
                right: 25,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _colorAnimation.value,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _floatingAnimation,
            builder: (context, child) {
              return Positioned(
                bottom: 80 - _floatingAnimation.value * 0.5,
                left: 15,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              );
            },
          ),
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: images.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 0.0;
                  if (_pageController.position.haveDimensions) {
                    value = index.toDouble() - (_pageController.page ?? 0);
                    value = (value * 0.038).clamp(-1, 1);
                  }
                  
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(value),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isImageExpanded = !_isImageExpanded;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            transform: Matrix4.identity()
                              ..scale(_isImageExpanded ? 1.05 : 1.0),
                            child: _buildPlantImage(images[index]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          if (images.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentImageIndex == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentImageIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: _currentImageIndex == index
                          ? [
                              BoxShadow(
                                color: Colors.white.withValues(alpha: 0.5),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : null,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, -3),
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  AnimatedBuilder(
                    animation: _slideAnimation,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _slideAnimation,
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.green, Colors.teal],
                          ).createShader(bounds),
                          child: Text(
                            plantName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 6),
                  
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Text(
                          scientificName,
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[600],
                            letterSpacing: 1.0,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  
                  AnimatedBuilder(
                    animation: _floatingAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _floatingAnimation.value * 0.2),
                        child: Container(
                          width: double.infinity,
                          height: 42,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.eco,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Get Care Plan',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 20),
                  
                  AnimatedBuilder(
                    animation: _slideController,
                    builder: (context, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-1, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _slideController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: const Text(
                          'General information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _buildEnhancedInfoGrid(),
                  
                  const SizedBox(height: 16),
                  
                  if (description.isNotEmpty) ...[
                    AnimatedBuilder(
                      animation: _fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeAnimation.value,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Description',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  _buildDetailedCareInfo(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlantImage(String imagePath) {
    if (isApiPlant) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorWidget();
        },
      );
    }
    
    return Builder(
      builder: (context) => FutureBuilder<bool>(
        future: _checkAssetExists(imagePath, context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.grey[300],
              child: const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            );
          }
          
          if (snapshot.hasData && snapshot.data == true) {
            return Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              cacheWidth: kIsWeb ? null : 800,
              cacheHeight: kIsWeb ? null : 600,
              errorBuilder: (context, error, stackTrace) {
                return _buildErrorWidget();
              },
            );
          }
          
          return _buildErrorWidget();
        },
      ),
    );
  }

  Widget _buildEnhancedInfoGrid() {
    final infoItems = [
      {'icon': Icons.wb_sunny, 'title': 'Lighting', 'subtitle': 'Shade', 'color': Colors.orange, 'gradient': [Colors.orange, Colors.deepOrange]},
      {'icon': Icons.water_drop, 'title': 'Humidity', 'subtitle': 'High', 'color': Colors.blue, 'gradient': [Colors.blue, Colors.lightBlue]},
      {'icon': Icons.thermostat, 'title': 'Temperature', 'subtitle': '16°C - 25°C', 'color': Colors.red, 'gradient': [Colors.red, Colors.pink]},
      {'icon': Icons.eco, 'title': 'Hardiness zone', 'subtitle': '10 - 12', 'color': Colors.green, 'gradient': [Colors.green, Colors.teal]},
    ];
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.0,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: infoItems.length,
      itemBuilder: (context, index) {
        final item = infoItems[index];
        return AnimatedBuilder(
          animation: _slideController,
          builder: (context, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(index.isEven ? -1 : 1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _slideController,
                curve: Curves.easeOutCubic,
              )),
              child: _buildEnhanced3DInfoCard(
                icon: item['icon'] as IconData,
                title: item['title'] as String,
                subtitle: item['subtitle'] as String,
                color: item['color'] as Color,
                gradient: item['gradient'] as List<Color>,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEnhanced3DInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required List<Color> gradient,
  }) {
    return AnimatedBuilder(
      animation: _floatingController,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(0.05 * math.sin(_floatingController.value * 2 * math.pi))
            ..rotateY(0.03 * math.cos(_floatingController.value * 2 * math.pi)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  color.withValues(alpha: 0.03),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.8),
                  blurRadius: 8,
                  offset: const Offset(-3, -3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_florist, size: 50, color: Colors.grey),
            SizedBox(height: 6),
            Text('Image not available', style: TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Future<bool> _checkAssetExists(String assetPath, BuildContext context) async {
    try {
      await DefaultAssetBundle.of(context).load(assetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  Widget _buildDetailedCareInfo() {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _slideController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.withValues(alpha: 0.08), Colors.teal.withValues(alpha: 0.04)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.teal],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.spa,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Care Requirements',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (isApiPlant) ..._buildEnhancedApiCareInfo() else ..._buildEnhancedLegacyCareInfo(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildEnhancedApiCareInfo() {
    final careItems = [
      {'icon': Icons.water_drop, 'label': 'Watering', 'value': widget.plantApi!.waterRequirement, 'color': Colors.blue},
      {'icon': Icons.wb_sunny, 'label': 'Light', 'value': widget.plantApi!.lightRequirement, 'color': Colors.orange},
      {'icon': Icons.thermostat, 'label': 'Temperature', 'value': widget.plantApi!.temperature, 'color': Colors.red},
      {'icon': Icons.grass, 'label': 'Soil', 'value': widget.plantApi!.soilType, 'color': Colors.brown},
    ];
    
    return [
      ...careItems.map((item) {
        return _buildEnhancedCareInfoRow(
          item['icon'] as IconData,
          item['label'] as String,
          item['value'] as String,
          item['color'] as Color,
        );
      }).toList(),
      if (widget.plantApi!.benefits.isNotEmpty)
        _buildEnhancedBenefitsSection(widget.plantApi!.benefits),
    ];
  }

  List<Widget> _buildEnhancedLegacyCareInfo() {
    final careItems = [
      {'icon': Icons.water_drop, 'label': 'Watering', 'value': '${widget.plant!.waterRequirement.frequency} - ${widget.plant!.waterRequirement.amount}', 'color': Colors.blue},
      {'icon': Icons.wb_sunny, 'label': 'Light', 'value': widget.plant!.lightRequirement, 'color': Colors.orange},
      {'icon': Icons.thermostat, 'label': 'Temperature', 'value': widget.plant!.temperature, 'color': Colors.red},
      {'icon': Icons.grass, 'label': 'Soil', 'value': widget.plant!.soilType, 'color': Colors.brown},
    ];
    
    return [
      ...careItems.map((item) {
        return _buildEnhancedCareInfoRow(
          item['icon'] as IconData,
          item['label'] as String,
          item['value'] as String,
          item['color'] as Color,
        );
      }).toList(),
      if (widget.plant!.benefits.isNotEmpty)
        _buildEnhancedBenefitsSection(widget.plant!.benefits),
    ];
  }

  Widget _buildEnhancedCareInfoRow(IconData icon, String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            color.withValues(alpha: 0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[700],
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedBenefitsSection(List<String> benefits) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withValues(alpha: 0.06),
            Colors.teal.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.teal],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              const Text(
                'Benefits',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: benefits.map((benefit) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.green.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.green.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                      size: 12,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      benefit,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}