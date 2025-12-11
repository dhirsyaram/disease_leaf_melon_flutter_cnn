class PredictionResult {
  final String className;
  final double confidence;
  final Map<String, double> allProbabilities;
  final Map<String, dynamic> features; // bentuk, tekstur, warna

  PredictionResult({
    required this.className,
    required this.confidence,
    required this.allProbabilities,
    required this.features,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    final prediction = json['prediction'] ?? 'Unknown';
    final probs = Map<String, double>.from(
      (json['probabilities'] ?? {}).map(
        (k, v) => MapEntry(k, (v as num).toDouble()),
      ),
    );

    final confidence = probs[prediction]?.toDouble() ?? 0.0;

    return PredictionResult(
      className: prediction,
      confidence: confidence,
      allProbabilities: probs,
      features: json['features'] ?? {},
    );
  }
}
