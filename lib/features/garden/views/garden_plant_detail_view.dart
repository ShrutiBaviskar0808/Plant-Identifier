import 'package:flutter/material.dart';
import '../../../core/data/models/plant.dart';
import 'dart:io';

class GardenPlantDetailView extends StatefulWidget {
  final UserPlant userPlant;

  const GardenPlantDetailView({super.key, required this.userPlant});

  @override
  State<GardenPlantDetailView> createState() => _GardenPlantDetailViewState();
}

class _GardenPlantDetailViewState extends State<GardenPlantDetailView> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
            // Custom App Bar with Image
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
              flexibleSpace: FlexibleSpaceBar(
                background: _buildPlantImage(),
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
      ),
    );
  }

  Widget _buildPlantImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: widget.userPlant.imagePath != null
          ? widget.userPlant.imagePath!.startsWith('http')
              ? Image.network(
                  widget.userPlant.imagePath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildNetworkOrPlaceholderImage();
                  },
                )
              : Image.file(
                  File(widget.userPlant.imagePath!),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildNetworkOrPlaceholderImage();
                  },
                )
          : _buildNetworkOrPlaceholderImage(),
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plant Name and Scientific Name
            Text(
              widget.userPlant.customName ?? widget.userPlant.plant.commonName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.userPlant.plant.scientificName,
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            
            // Date Added Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF45A049)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Added: ${widget.userPlant.dateAdded.day}/${widget.userPlant.dateAdded.month}/${widget.userPlant.dateAdded.year}',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Description
            if (widget.userPlant.plant.description.isNotEmpty) ...[
              Text(
                widget.userPlant.plant.description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            _buildCareInfo(),
            
            if (widget.userPlant.notes != null && widget.userPlant.notes!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildNotesSection(),
            ],
          ],
        ),
      ),
    );
  }
  Widget _buildNetworkOrPlaceholderImage() {
    // Map plant names to correct asset paths
    String getAssetPath(String plantName) {
      final name = plantName.toLowerCase();
      if (name.contains('hibiscus')) return 'assets/images/hibiscus.jpg';
      if (name.contains('monstera')) return 'assets/images/Monstera Deliciosa.jpg';
      if (name.contains('snake')) return 'assets/images/Snake Plant.jpg';
      return 'assets/images/${widget.userPlant.plant.commonName}.jpg';
    }
    
    return Image.asset(
      getAssetPath(widget.userPlant.plant.commonName),
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to network image if asset fails
        if (widget.userPlant.plant.imageUrls.isNotEmpty) {
          return Image.network(
            widget.userPlant.plant.imageUrls.first,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: Icon(Icons.local_florist, size: 60, color: Colors.grey[600]),
              );
            },
          );
        }
        return Container(
          color: Colors.grey[300],
          child: Icon(Icons.local_florist, size: 60, color: Colors.grey[600]),
        );
      },
    );
  }

  Widget _buildCareInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Care Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        _buildCareInfoRow(Icons.water_drop, 'Watering', '${widget.userPlant.plant.careRequirements.water.frequency} - ${widget.userPlant.plant.careRequirements.water.amount}'),
        _buildCareInfoRow(Icons.wb_sunny, 'Light', '${widget.userPlant.plant.careRequirements.light.level} (${widget.userPlant.plant.careRequirements.light.hoursPerDay}h/day)'),
        _buildCareInfoRow(Icons.thermostat, 'Temperature', '${widget.userPlant.plant.careRequirements.temperature.minTemp}-${widget.userPlant.plant.careRequirements.temperature.maxTemp}°C'),
        _buildCareInfoRow(Icons.grass, 'Soil', widget.userPlant.plant.careRequirements.soilType),
        _buildCareInfoRow(Icons.eco, 'Fertilizer', widget.userPlant.plant.careRequirements.fertilizer.isNotEmpty ? widget.userPlant.plant.careRequirements.fertilizer : 'Monthly'),
      ],
    );
  }

  Widget _buildCareInfoRow(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
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

  Widget _buildNotesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.note, color: Colors.blue[700], size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'My Notes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.userPlant.notes!,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}