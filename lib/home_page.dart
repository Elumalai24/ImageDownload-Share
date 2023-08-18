import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? imageFile;
  Future<void> _download(String url) async {
    final response = await http.get(Uri.parse(url));

    // Get the image name
    final imageName = path.basename(url);
    // Get the document directory path
    final appDir = await pathProvider.getApplicationDocumentsDirectory();

    // This is the saved image path
    // You can use it to display the saved image later
    final localPath = path.join(appDir.path, imageName);

    // Downloading
    setState(() {
      imageFile = File(localPath);
    });
    print(imageFile);
    await imageFile?.writeAsBytes(response.bodyBytes);
  }
  void shareImage(String url) async {
    final response = await http.get(Uri.parse(url));
    final appDocDir = await getApplicationDocumentsDirectory();
    final file = File('${appDocDir.path}/image.png');
    await file.writeAsBytes(response.bodyBytes);
    Share.shareFiles([file.path], text: 'Check out this image!');
  }
  @override
  Widget build(BuildContext context) {
    String imageUrl = "https://www.kindacode.com/wp-content/uploads/2022/02/orange.jpeg";
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),
      actions: [
        IconButton(icon: Icon(Icons.share), onPressed: () {
          shareImage(imageUrl);
        },)
      ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         // crossAxisAlignment:CrossAxisAlignment.center,
          children: [
          Image.network(imageUrl),
          SizedBox(height: 20),
          ElevatedButton(onPressed: ()async{
            _download(imageUrl);
            //downloadImage(url);
          },
            child:  Text((imageFile != null) ? "Image Downloaded":"Download Image"),
          )
        ],),
      ),
    );
  }
}
