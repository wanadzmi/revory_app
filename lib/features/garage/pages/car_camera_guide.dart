import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:revory/features/garage/controllers/car_camera_controller.dart';

/// Camera screen with a visual frame to help position a vehicle.
class CarCameraGuide extends StatefulWidget {
  /// Creates the guided vehicle camera screen.
  const new({super.key});
  @override
  State<CarCameraGuide> createState() => _CarCameraGuideState();
}

class _CarCameraGuideState extends State<CarCameraGuide> {
  final controller = CarCameraController();
  @override
  void initState() {
    super.initState();
    controller.addListener(_refresh);
    unawaited(controller.start());
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(_refresh);
    controller.dispose();
    super.dispose();
  }

  Future<void> capture() async {
    final path = await controller.capture();
    if (path != null && mounted) Navigator.pop(context, path);
  }

  @override
  Widget build(BuildContext context) {
    final camera = controller.camera;
    final error = controller.error;
    if (error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(error)),
      );
    }
    if (camera == null || !camera.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(camera),
          SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                    const Spacer(),
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        'Position your car',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 26),
                  height: 210,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Fit the full car inside this frame',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: FloatingActionButton(
                    onPressed: capture,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.camera_alt, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
