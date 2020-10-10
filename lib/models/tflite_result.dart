class TFLiteResult {
  int index;
  String label;
  double confidence;

  TFLiteResult(this.index, this.label, this.confidence);

  TFLiteResult.fromModel(dynamic model) {
    confidence = model["confidence"];
    index = model["index"];
    label = model["label"];
  }
}
