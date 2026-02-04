import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String get plantName => widget.plant?.name ?? widget.plantApi?.name ?? '';
  String get scientificName => widget.plant?.scientificName ?? widget.plantApi?.scientificName ?? '';
  String get description => widget.plant?.description ?? widget.plantApi?.description ?? '';
  List<String> get imageUrls => widget.plant?.imageUrl != null ? [widget.plant!.imageUrl] : (widget.plantApi?.imageUrl != null ? [widget.plantApi!.imageUrl] : []);
  bool get isApiPlant => widget.plantApi != null;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: CustomScrollView(
          slivers: [
            // Custom App Bar with Image Slider
            SliverAppBar(
              expandedHeight: 350,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0,
              leading: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.black87),
                    onPressed: () {},
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildImageSlider(),
              ),
            ),
            // Content
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
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildImageSlider() {
    final images = imageUrls.isNotEmpty ? imageUrls : ['assets/images/plant_placeholder.jpg'];
    
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
              child: _buildPlantImage(images[index]),
            );
          },
        ),
        // Image indicators
        if (images.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentImageIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentImageIndex == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Name and Scientific Name
            Text(
              plantName,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              scientificName,
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            
            // Get Care Plan Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Get Care Plan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // General Information
            const Text(
              'General information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            
            _buildInfoGrid(),
            
            const SizedBox(height: 24),
            
            // Description
            if (description.isNotEmpty) ...[
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            _buildDetailedCareInfo(),
          ],
        ),
      ),
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

  Widget _buildInfoGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildInfoCard(
          icon: Icons.wb_sunny,
          title: 'Lighting',
          subtitle: 'Shade',
          color: Colors.orange,
        ),
        _buildInfoCard(
          icon: Icons.water_drop,
          title: 'Humidity',
          subtitle: 'High',
          color: Colors.blue,
        ),
        _buildInfoCard(
          icon: Icons.thermostat,
          title: 'Temperature',
          subtitle: '16°C - 25°C',
          color: Colors.red,
        ),
        _buildInfoCard(
          icon: Icons.eco,
          title: 'Hardiness zone',
          subtitle: '10 - 12',
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Add to Garden',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_florist, size: 60, color: Colors.grey),
            SizedBox(height: 8),
            Text('Image not available', style: TextStyle(color: Colors.grey)),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Care Requirements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        if (isApiPlant) ..._buildApiCareInfo() else ..._buildLegacyCareInfo(),
      ],
    );
  }

  List<Widget> _buildApiCareInfo() {
    return [
      _buildCareInfoRow(Icons.water_drop, 'Watering', widget.plantApi!.waterRequirement),
      _buildCareInfoRow(Icons.wb_sunny, 'Light', widget.plantApi!.lightRequirement),
      _buildCareInfoRow(Icons.thermostat, 'Temperature', widget.plantApi!.temperature),
      _buildCareInfoRow(Icons.grass, 'Soil', widget.plantApi!.soilType),
      _buildCareInfoRow(Icons.science, 'Fertilizer', widget.plantApi!.fertilizer),
      _buildCareInfoRow(Icons.warning, 'Toxicity', widget.plantApi!.toxicity),
      _buildCareInfoRow(Icons.straighten, 'Mature Size', widget.plantApi!.matureSize),
      _buildCareInfoRow(Icons.calendar_month, 'Growing Season', widget.plantApi!.growingSeason),
      if (widget.plantApi!.benefits.isNotEmpty)
        _buildBenefitsSection(widget.plantApi!.benefits),
    ];
  }

  List<Widget> _buildLegacyCareInfo() {
    return [
      _buildCareInfoRow(Icons.water_drop, 'Watering', '${widget.plant!.waterRequirement.frequency} - ${widget.plant!.waterRequirement.amount}'),
      _buildCareInfoRow(Icons.wb_sunny, 'Light', widget.plant!.lightRequirement),
      _buildCareInfoRow(Icons.thermostat, 'Temperature', widget.plant!.temperature),
      _buildCareInfoRow(Icons.grass, 'Soil', widget.plant!.soilType),
      _buildCareInfoRow(Icons.science, 'Fertilizer', widget.plant!.fertilizer),
      _buildCareInfoRow(Icons.warning, 'Toxicity', widget.plant!.toxicity),
      if (widget.plant!.benefits.isNotEmpty)
        _buildBenefitsSection(widget.plant!.benefits),
    ];
  }

  Widget _buildCareInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.green[700], size: 20),
          ),
          const SizedBox(width: 16),
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
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection(List<String> benefits) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.star, color: Colors.green[700], size: 20),
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
            children: benefits.map((benefit) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
              ),
              child: Text(
                benefit,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}