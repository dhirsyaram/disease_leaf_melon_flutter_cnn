import 'dart:convert';
import 'dart:io';

import 'package:detection_disease_leaf_melon_fruits/data/prediction_result.dart';
import 'package:detection_disease_leaf_melon_fruits/widgets/image_display.dart';
import 'package:detection_disease_leaf_melon_fruits/widgets/image_picker_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class HomeContentPage extends StatefulWidget {
  const HomeContentPage({super.key});

  @override
  State<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  File? _selectedImage;
  bool _loading = false;
  final ImagePicker _picker = ImagePicker();
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _predictImage() async {
    if (_selectedImage == null) return;
    setState(() => _loading = true);

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://leaf-melon-disease-predict.up.railway.app/predict'),
      );
      request.files.add(
        await http.MultipartFile.fromPath('file', _selectedImage!.path),
      );

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        final result = PredictionResult.fromJson(json.decode(responseData));
        setState(() => _loading = false);
        context.go(
          '/result',
          extra: {'result': result, 'imageFile': _selectedImage},
        );
      } else {
        setState(() => _loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal memproses gambar')));
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error API: ${e.toString()}')));
    }
  }

  void _handleAsyncPrediction() async {
    setState(() => _loading = true);
    try {
      await _predictImage();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error Button: ${e.toString()}')));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ImageDisplay(selectedImage: _selectedImage),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _selectedImage == null
                ? Column(
                    key: const ValueKey("noImage"),
                    children: [
                      ImagePickerButton(
                        text: 'KAMERA',
                        icon: Icons.camera_alt,
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                      ImagePickerButton(
                        text: 'GALERI',
                        icon: Icons.photo,
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ],
                  )
                : Column(
                    key: const ValueKey("hasImage"),
                    children: [
                      ImagePickerButton(
                        text: _loading ? 'Mendeteksi...' : 'DETEKSI',
                        icon: Icons.search,
                        onPressed: _loading ? null : _handleAsyncPrediction,
                        btnColor: Colors.blueAccent,
                      ),
                      ImagePickerButton(
                        text: 'HAPUS GAMBAR',
                        icon: Icons.delete,
                        onPressed: _clearImage,
                        btnColor: Colors.redAccent,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
