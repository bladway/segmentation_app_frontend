import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:segmentation_app_frontend/api/api.dart';

void main() {
  RestClient restClient = RestClient(Dio());
  runApp(MyApp(restClient: restClient));
}

class MyApp extends StatelessWidget {
  static const String baseUrl = "https://anteater-internal-presently.ngrok-free.app";

  const MyApp({super.key, required this.restClient});

  final RestClient restClient;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.cyan,
        textTheme: TextTheme(
          bodyLarge: const TextStyle(
            color: Colors.deepPurpleAccent,
            fontSize: 20
          ),
          bodyMedium: TextStyle(
            color: Colors.deepPurpleAccent.withOpacity(0.9),
            fontSize: 16
          ),
          bodySmall: TextStyle(
            color: Colors.deepPurpleAccent.withOpacity(0.7),
            fontSize: 12
          )
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: SegmentationAppHomePage(restClient: restClient, title: 'Segmentation App home',),
    );
  }
}

class SegmentationAppHomePage extends StatelessWidget {
  SegmentationAppHomePage({super.key, required this.restClient, required this.title});

  final RestClient restClient;

  final String title;

  late final TextEditingController textEditingController = TextEditingController();

  Future proceedToCamera(BuildContext context) async {
    final XFile? capturedImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (capturedImage == null) {
      return;
    }
    int K;
    try {
      K = int.parse(textEditingController.text);
    } catch (e) {
      return;
    }

    File ? image = File(capturedImage.path);

    List<PathDto> response = await restClient.getImages(image: image, K: K);

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SegmentationAppResultPage(
          imagePathes: response,
        ),
      ),
    );
  }

  Future proccedToGalery(BuildContext context) async {
    final XFile? capturedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (capturedImage == null) {
      return;
    }
    int K;
    try {
      K = int.parse(textEditingController.text);
    } catch (e) {
      return;
    }

    File ? image = File(capturedImage.path);

    List<PathDto> response = await restClient.getImages(image: image, K: K);

    if (!context.mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SegmentationAppResultPage(
          imagePathes: response,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Lets picture the image to process with KMeans!',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            MaterialButton(
              onPressed: () => proceedToCamera(context),
              color: Colors.amber,
              child: Text(
                "Make image from camera",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            MaterialButton(
              onPressed: () => proccedToGalery(context),
              color: Colors.white,
              child: Text(
                "Upload image from gallery",
                style: Theme.of(context).textTheme.bodyMedium
              )
            ),
            TextField(
              controller: textEditingController,
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Means count...'
              ),
            )
          ],
        ),
      ),
    );
  }
}


class SegmentationAppResultPage extends StatelessWidget {
  const SegmentationAppResultPage({super.key,
   required this.imagePathes});

  final List<PathDto> imagePathes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
            Text(
              'Image processed with OpenCVRnd KMeans',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Image.network(
              '${MyApp.baseUrl}/file/byPath?imagePath=${imagePathes[0].path}',
              fit: BoxFit.cover,
            ),
            Text(
              'Image processed with OpenCVPlusPlus KMeans',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Image.network(
              '${MyApp.baseUrl}/file/byPath?imagePath=${imagePathes[1].path}',
              fit: BoxFit.cover,
            ),
            Text(
              'Image processed with OwnRnd KMeans',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Image.network(
              '${MyApp.baseUrl}/file/byPath?imagePath=${imagePathes[2].path}',
              fit: BoxFit.cover,
            ),
            Text(
              'Image processed with OwnPlusPlus KMeans',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            Image.network(
              '${MyApp.baseUrl}/file/byPath?imagePath=${imagePathes[3].path}',
              fit: BoxFit.cover,
            ),
        ]
      ),
    );
  }
}
