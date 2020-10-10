import 'dart:async';
import 'package:image_classification_ml/models/tflite_result.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class TFLiteHelper {
  static Future loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
  }

  Future<List<TFLiteResult>> classifyImage(PickedFile image) async {
    List<TFLiteResult> outputs = [];
    var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );

    output.forEach((value) {
      final element = TFLiteResult.fromModel(value);
      outputs.add(element);
    });

    return outputs;
  }

  /*Future<List<TFLiteResult>> classifyVideo() async {
    List<TFLiteResult> outputs = [];
    var output = await Tflite.runModelOnFrame(bytesList: null);

    output.forEach((value) {
      final element = TFLiteResult.fromModel(value);
      outputs.add(element);
    });

    return outputs;
  }*/

  static void dispose() async {
    await Tflite.close();
  }
}
