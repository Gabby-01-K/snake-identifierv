// lib/models/ml_model.dart

class MlModel {
  /// The name we show in the UI, e.g., "Snake Model v1"
  final String name;

  /// The asset path for the .tflite file
  final String modelPath;

  /// The asset path for the labels.txt file
  final String labelsPath;

  MlModel({
    required this.name,
    required this.modelPath,
    required this.labelsPath,
  });
}