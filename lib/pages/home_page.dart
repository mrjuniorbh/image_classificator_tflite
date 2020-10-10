import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:image_classification_ml/helpers/camera_helper.dart';
import 'package:image_classification_ml/helpers/tflite_helper.dart';
import 'package:image_classification_ml/models/tflite_result.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File _image;
  List<TFLiteResult> _outputs = [];

  @override
  void initState() {
    super.initState();
    TFLiteHelper.loadModel();
  }

  @override
  void dispose() {
    super.dispose();
    TFLiteHelper.dispose();
  }

  Future<void> showChoicePhotoDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Make a Choice !"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  child: Text("Gallery"),
                  onTap: () {
                    _openGallery(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(8)),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    _openCamera(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildImage() {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 92.0),
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: _image == null
              ? Text('No Image')
              : Image.file(
                  _image,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    ));
  }

  _buildResult() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
      child: Container(
        height: 100.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _buildResultList(),
      ),
    );
  }

  _buildResultList() {
    if (_outputs.isEmpty) {
      return Center(
        child: Text('No results'),
      );
    }

    return Center(
      child: ListView.builder(
        itemCount: _outputs.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Text(
                '${_outputs[index].label} ( ${(_outputs[index].confidence * 100.0).toStringAsFixed(2)} % )',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10.0,
              ),
              LinearPercentIndicator(
                backgroundColor: Colors.white,
                progressColor: _outputs[index].label == "1 Mulher"
                    ? Colors.pink[300]
                    : Colors.blue,
                lineHeight: 14.0,
                percent: _outputs[index].confidence,
              ),
            ],
          );
        },
      ),
    );
  }

  void _openGallery(BuildContext context) async {
    final image = await CameraHelper.getImage(imageSource: ImageSource.gallery);
    if (image == null) {
      return null;
    }

    final outputs = await TFLiteHelper().classifyImage(image);
    setState(() {
      _image = File(image.path);
      _outputs = outputs;
    });

    Navigator.of(context).pop();
  }

  void _openCamera(BuildContext context) async {
    final image = await CameraHelper.getImage(imageSource: ImageSource.camera);
    if (image == null) {
      return null;
    }

    final outputs = await TFLiteHelper().classifyImage(image);
    setState(() {
      _image = File(image.path);
      _outputs = outputs;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Classificator'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.photo_camera),
        onPressed: () {
          showChoicePhotoDialog(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildResult(),
          _buildImage(),
        ],
      )),
    );
  }
}
