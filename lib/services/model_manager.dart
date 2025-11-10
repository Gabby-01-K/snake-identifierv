// lib/services/model_manager.dart

import 'package:flutter/material.dart';
import '../models/ml_model.dart';

class ModelManager extends ChangeNotifier {
  // A list of all models available in the app's assets.
  // We are hard-coding them here.
  final List<MlModel> _availableModels = [
    MlModel(
      name: 'Snake Identifier v1.0',
      modelPath: 'assets/snake_model.tflite',
      labelsPath: 'assets/labels.txt',
    ),
    MlModel(
      name: 'Snake Identifier v2.0 (Demo)',
      modelPath: 'assets/snake_model_v2.tflite',
      labelsPath: 'assets/labels_v2.txt',
    ),
  ];

  // The currently selected model. We'll default to the first one.
  late MlModel _activeModel;

  ModelManager() {
    // Set the default model when the manager is created
    _activeModel = _availableModels.first;
  }

  /// A getter to get the list of all available models
  List<MlModel> get availableModels => _availableModels;

  /// A getter to find out which model is currently active
  MlModel get activeModel => _activeModel;

  /// The method to change the active model.
  void setActiveModel(MlModel newModel) {
    // Check if the model is actually different
    if (_activeModel != newModel) {
      _activeModel = newModel;

      // MOST IMPORTANT PART
      // It notifies all listening widgets that a change has occurred,
      // so they can rebuild (e.g., the ClassifierPage).
      notifyListeners();
    }
  }
}