import 'dart:typed_data';
import 'package:app/blocs/user_bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';


class UploadImagePopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Upload Image'),
      content: Text('Choose an image to upload.'),
      actions: [
        TextButton(
          onPressed: () async {
  final ImagePicker imagePicker = ImagePicker();
  try {
    final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Convert the image to Uint8List
      Uint8List imageData = await pickedFile.readAsBytes();
      
      // Dispatch UploadImageEvent to the Bloc
      BlocProvider.of<UserBloc>(context).add(UploadImageEvent(imageData));
      
      // Close the popup after the image is picked
      Navigator.of(context).pop();
    } else {
      // Show a message when no image is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected.'))
      );
    }
  } catch (e) {
    // Show an error message if something goes wrong
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}'))
    );
  }
},

          child: Text('Select from Gallery'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // ปิดป๊อปอัพ
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}