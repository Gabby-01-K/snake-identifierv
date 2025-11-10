// lib/pages/classifier_page.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import '../models/ml_model.dart';
import '../services/model_manager.dart';

// Import our other files
import '../models/snake_info.dart';
import '../data/snake_database.dart';
import './details_page.dart';

class ClassifierPage extends StatefulWidget {
  const ClassifierPage({super.key});

  @override
  State<ClassifierPage> createState() => _ClassifierPageState();
}

class _ClassifierPageState extends State<ClassifierPage> {

  bool _isModelLoading = true;
  MlModel? _loadedModel;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  List<String> _labels = [];
  Interpreter? _interpreter;
  String _prediction = "";
  double _confidence = 0.0;

  // Holds all info for the predicted snake
  SnakeInfo? _snakeInfo;

  String? _error;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 'Watch' the ModelManager. If the active model changes,
    // this function will re-run.
    final modelManager = context.watch<ModelManager>();

    // Check if the model selected in the manager is
    // different from the one we have loaded.
    if (modelManager.activeModel != _loadedModel) {
      // If it's different, load the new model.
      _loadModel(modelManager.activeModel);
    }
  }

  Future<void> _loadModel(MlModel modelToLoad) async {
    // Show the loading spinner and clear any old data
    setState(() {
      _isModelLoading = true;
      _error = null;
      _prediction = "";
      _snakeInfo = null;
      _image = null;
    });

    try {
      // Close the old interpreter if it exists
      _interpreter?.close();

      // Load the new model and labels from the asset paths
      _interpreter = await Interpreter.fromAsset(modelToLoad.modelPath);
      final labelsData = await rootBundle.loadString(modelToLoad.labelsPath);
      _labels = labelsData.split('\n').where((label) => label.isNotEmpty).toList();

      // Success! Update the state.
      if (mounted) {
        setState(() {
          _loadedModel = modelToLoad; // Mark this model as loaded
          _isModelLoading = false; // Hide spinner
        });
      }
    } catch (e) {
      debugPrint("Failed to load model ${modelToLoad.name}: $e");
      if (mounted) {
        setState(() {
          _isModelLoading = false;
          _error = "Error loading model. Check assets folder.";
          _loadedModel = null;
        });
      }
    }
  }
  // -------------------------

  Future<void> _pickImage(ImageSource source) async {
    // Prevent picking an image if the model is not loaded
    if (_isModelLoading || _interpreter == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please wait, model is loading.')),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile == null) return;

      final File imageFile = File(pickedFile.path);
      setState(() {
        _image = imageFile;
        _prediction = "";
        _confidence = 0.0;
        _snakeInfo = null;
        _error = null;
      });

      _runInference(imageFile);
    } catch (e) {
      debugPrint("Failed to pick image: $e");
      setState(() {
        _error = "Failed to pick image: $e";
      });
    }
  }

  Future<void> _runInference(File imageFile) async {
    if (_interpreter == null || _labels.isEmpty) {
      debugPrint("Interpreter or labels not loaded.");
      setState(() {
        _error = "Model is not loaded.";
      });
      return;
    }

    // 1. Decode Image
    final bytes = await imageFile.readAsBytes();
    img.Image? originalImage = img.decodeImage(bytes);
    if (originalImage == null) return;

    // 2. Resize
    img.Image resizedImage = img.copyResize(originalImage, width: 224, height: 224);

    // 3. Normalize
    var input = Float32List(1 * 224 * 224 * 3);
    int pixelIndex = 0;
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        var pixel = resizedImage.getPixel(x, y);
        // Normalize to [-1, 1] ( (pixel / 127.5) - 1 )
        input[pixelIndex++] = (pixel.r / 127.5) - 1.0;
        input[pixelIndex++] = (pixel.g / 127.5) - 1.0;
        input[pixelIndex++] = (pixel.b / 127.5) - 1.0;
      }
    }
    var inputAsList = input.reshape([1, 224, 224, 3]);

    // 4. Define Output
    var output = List.filled(1 * _labels.length, 0.0).reshape([1, _labels.length]);

    // 5. Run inference
    try {
      _interpreter!.run(inputAsList, output);
    } catch (e) {
      debugPrint("Error running inference: $e");
      setState(() {
        _error = "Error running inference: $e";
      });
      return;
    }

    // 6. Process Output
    var outputList = output[0] as List<double>;
    double maxScore = 0.0;
    int maxIndex = -1;
    for (int i = 0; i < outputList.length; i++) {
      if (outputList[i] > maxScore) {
        maxScore = outputList[i];
        maxIndex = i;
      }
    }

    // 7. Update UI
    if (maxIndex != -1) {
      String predictedBreed = _labels[maxIndex].trim();
      SnakeInfo? info = snakeDatabase[predictedBreed];

      setState(() {
        _prediction = predictedBreed;
        _confidence = maxScore;

        if (info != null) {
          _snakeInfo = info;
          _error = null;
        } else {
          _snakeInfo = null;
          _error = "(No details found in app database. Please add '$_prediction' to the `snakeDatabase` map.)";
        }
      });
    } else {
      setState(() {
        _error = "Could not classify image.";
      });
    }
  }

  void _showFirstAidDialog() {
    if (_snakeInfo == null) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            _snakeInfo!.isVenomous ? "EMERGENCY FIRST AID" : "Bite First Aid",
            style: TextStyle(
              color: _snakeInfo!.isVenomous ? Theme.of(context).colorScheme.error : null,
            ),
          ),
          content: SingleChildScrollView(
            child: Text(_snakeInfo!.firstAid),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildResultWidget() {
    if (_error != null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    if (_prediction.isEmpty || _snakeInfo == null) {
      return Container(); // Empty space
    }

    bool isVenomous = _snakeInfo!.isVenomous;
    Color statusColor = isVenomous ? Theme.of(context).colorScheme.error : Colors.green.shade700;
    String statusText = isVenomous ? "VENOMOUS" : "NON-VENOMOUS";

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(snakeName: _prediction),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Chip(
                label: Text(
                  statusText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: statusColor,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              const SizedBox(height: 12),
              Text(
                _prediction.replaceAll('-', ' ').toUpperCase(),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Confidence: ${(_confidence * 100).toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _snakeInfo!.details,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.medical_services),
                label: const Text('First Aid Info'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVenomous ? statusColor.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.1),
                  foregroundColor: isVenomous ? statusColor : Colors.blue.shade700,
                  elevation: 0,
                ),
                onPressed: _showFirstAidDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: _isModelLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            // Show the name of the model we are loading!
            Text(
              _loadedModel?.name ?? "Loading Model...",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade500,
                  ),
                  child: _image == null
                      ? const Center(
                      child: Text('No image selected.', style: TextStyle(color: Colors.black45)))
                      : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_image!, fit: BoxFit.cover)),
                ),
                const SizedBox(height: 20),
                _buildResultWidget(),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => _pickImage(ImageSource.camera),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => _pickImage(ImageSource.gallery),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}