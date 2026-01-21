import 'package:flutter/material.dart';

class AROverlay {
  final String id;
  final String type; // 'dry_area', 'disease', 'prune_point'
  final Offset position;
  final String message;
  final Color color;

  AROverlay({
    required this.id,
    required this.type,
    required this.position,
    required this.message,
    required this.color,
  });
}

class ARPlantCareService {
  static List<AROverlay> analyzeForAR(Size imageSize) {
    // Simulate AR analysis
    return [
      AROverlay(
        id: 'dry1',
        type: 'dry_area',
        position: Offset(imageSize.width * 0.3, imageSize.height * 0.4),
        message: 'Dry soil detected',
        color: Colors.orange,
      ),
      AROverlay(
        id: 'prune1',
        type: 'prune_point',
        position: Offset(imageSize.width * 0.7, imageSize.height * 0.2),
        message: 'Prune here for better growth',
        color: Colors.green,
      ),
      AROverlay(
        id: 'disease1',
        type: 'disease',
        position: Offset(imageSize.width * 0.5, imageSize.height * 0.6),
        message: 'Possible leaf spot',
        color: Colors.red,
      ),
    ];
  }
}

class ARCameraView extends StatefulWidget {
  const ARCameraView({super.key});

  @override
  State<ARCameraView> createState() => _ARCameraViewState();
}

class _ARCameraViewState extends State<ARCameraView> {
  List<AROverlay> overlays = [];
  bool showOverlays = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AR Plant Care'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[800],
            child: const Center(
              child: Icon(
                Icons.camera_alt,
                size: 100,
                color: Colors.white54,
              ),
            ),
          ),
          
          // AR Overlays
          if (showOverlays)
            ...overlays.map((overlay) => Positioned(
              left: overlay.position.dx - 20,
              top: overlay.position.dy - 20,
              child: _buildARMarker(overlay),
            )),
          
          // Controls
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  onPressed: _toggleOverlays,
                  backgroundColor: Colors.green,
                  child: Icon(showOverlays ? Icons.visibility_off : Icons.visibility),
                ),
                FloatingActionButton(
                  onPressed: _analyzeImage,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.analytics),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildARMarker(AROverlay overlay) {
    return GestureDetector(
      onTap: () => _showOverlayDetails(overlay),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: overlay.color.withValues(alpha: 0.8),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Icon(
          _getOverlayIcon(overlay.type),
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  IconData _getOverlayIcon(String type) {
    switch (type) {
      case 'dry_area':
        return Icons.water_drop;
      case 'disease':
        return Icons.warning;
      case 'prune_point':
        return Icons.content_cut;
      default:
        return Icons.info;
    }
  }

  void _toggleOverlays() {
    setState(() {
      showOverlays = !showOverlays;
    });
  }

  void _analyzeImage() {
    final size = MediaQuery.of(context).size;
    setState(() {
      overlays = ARPlantCareService.analyzeForAR(size);
      showOverlays = true;
    });
  }

  void _showOverlayDetails(AROverlay overlay) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getOverlayTitle(overlay.type)),
        content: Text(overlay.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getOverlayTitle(String type) {
    switch (type) {
      case 'dry_area':
        return 'Watering Needed';
      case 'disease':
        return 'Health Issue';
      case 'prune_point':
        return 'Pruning Suggestion';
      default:
        return 'Plant Care';
    }
  }
}