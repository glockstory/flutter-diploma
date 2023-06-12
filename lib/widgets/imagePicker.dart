import 'package:flutter/material.dart';
import 'package:flutter_final/models/imageUrl.dart';
import 'package:flutter_final/pages/addActivity.dart';
import 'package:flutter_final/pages/editActivity.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class ImagePickerWidget extends StatefulWidget {
  String? selectedImage;
  ImagePickerWidget({this.selectedImage});
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  List<String> _imageUrls = [
    'https://www.sclera.be/resources/pictos/drieband%20t.png',
    'https://www.sclera.be/resources/pictos/bloemschikken%20t.png',
    'https://www.sclera.be/resources/pictos/kunst%20t.png',
    'https://www.sclera.be/resources/pictos/ballenbad%20spelen%20t.png',
    'https://www.sclera.be/resources/pictos/ballenbad%20ballen%20gooien%20t.png',
    'https://www.sclera.be/resources/pictos/barbeque%20t.png'
  ];

  @override
  void initState() {
    super.initState();
    print('url: ${widget.selectedImage}');
    if (widget.selectedImage != '') {
      setState(() {
        print('done');
        _selectedImageUrl = widget.selectedImage!;
      });
    }
  }

  @override
  void dispose() {
    //widget.selectedImage.dispose(); // don't forget to dispose
    super.dispose();
  }

  String _selectedImageUrl = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            List<String> newImageUrls = await _getImageUrls();
            setState(() {
              _imageUrls = newImageUrls;
            });
            await _showImagePickerDialog();
          },
          child: Container(
            width: double.infinity,
            height: 200,
            child: _selectedImageUrl.isEmpty
                ? Center(child: Text("Tap to pick an image"))
                : CachedNetworkImage(
                    imageUrl: _selectedImageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _showImagePickerDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pick an image"),
            content: Container(
              width: double.maxFinite,
              height: 300,
              child: GridView.builder(
                itemCount: _imageUrls.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageUrl = _imageUrls[index];
                        print(_selectedImageUrl);
                        AddActivity.imageUrl = _selectedImageUrl;
                        EditActivity.imageUrl = _selectedImageUrl;
                      });
                      Navigator.pop(context);
                    },
                    child: CachedNetworkImage(
                      imageUrl: _imageUrls[index],
                      fit: BoxFit.contain,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel")),
            ],
          );
        });
  }

  Future<List<String>> _getImageUrls() async {
    // Here you can fetch images URLs from the internet
    // and return them as a list of Strings
    return [
      'https://www.sclera.be/resources/pictos/drieband%20t.png',
      'https://www.sclera.be/resources/pictos/bloemschikken%20t.png',
      'https://www.sclera.be/resources/pictos/kunst%20t.png',
      'https://www.sclera.be/resources/pictos/ballenbad%20spelen%20t.png',
      'https://www.sclera.be/resources/pictos/ballenbad%20ballen%20gooien%20t.png',
      'https://www.sclera.be/resources/pictos/barbeque%20t.png'
    ];
  }
}
