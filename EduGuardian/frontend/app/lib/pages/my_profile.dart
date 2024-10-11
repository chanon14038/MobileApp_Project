import 'dart:typed_data';

import 'package:app/pages/change_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/user_bloc.dart';
import 'login_page.dart';
import 'update_profile.dart';

class UserProfilePage extends StatefulWidget {
  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  void initState() {
    super.initState();
    // Fetch user data when the page is initialized
    context.read<UserBloc>().add(FetchUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Profile',
          style: GoogleFonts.bebasNeue(
            fontSize: 27,
            color: Color.fromARGB(255, 96, 96, 96),
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            final user = state.user; // ดึงข้อมูลผู้ใช้จากสถานะที่โหลดแล้ว
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(7),
                    child: Container(
                      padding: EdgeInsets.all(50.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: user.imageData != null
                                ? MemoryImage(user
                                    .imageData!) // Display the image if available
                                : null, // No image, show icon instead
                            child: user.imageData == null
                                ? IconButton(
                                    icon: Icon(Icons.camera_alt,
                                        size: 30), // Show camera icon
                                    onPressed: () async {
                                      // Trigger the upload process when the icon is pressed
                                      final imagePicker = ImagePicker();
                                      final pickedFile =
                                          await imagePicker.pickImage(
                                              source: ImageSource.gallery);
                                      if (pickedFile != null) {
                                        try {
                                          Uint8List imageData =
                                              await pickedFile.readAsBytes();
                                          BlocProvider.of<UserBloc>(context)
                                              .add(UploadImageEvent(
                                                  imageData)); // Send image to Bloc
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Error: ${e.toString()}')),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text('No image selected.')),
                                        );
                                      }
                                    },
                                  )
                                : Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: IconButton(
                                          icon: Icon(Icons.edit,
                                              size: 20,
                                              color: Colors
                                                  .white), // Pencil icon for edit/delete
                                          onPressed: () {
                                            // Show dialog with options to either delete or change the image
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      leading:
                                                          Icon(Icons.delete),
                                                      title:
                                                          Text('Delete Image'),
                                                      onTap: () {
                                                        // Call Bloc to delete the profile image
                                                        BlocProvider.of<
                                                                    UserBloc>(
                                                                context)
                                                            .add(
                                                                DeleteProfileImageEvent());
                                                        Navigator.of(context)
                                                            .pop(); // Close the modal
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: Icon(
                                                          Icons.photo_library),
                                                      title:
                                                          Text('Change Image'),
                                                      onTap: () async {
                                                        // Trigger the image picker to upload a new image
                                                        final imagePicker =
                                                            ImagePicker();
                                                        final pickedFile =
                                                            await imagePicker
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .gallery);
                                                        if (pickedFile !=
                                                            null) {
                                                          try {
                                                            Uint8List
                                                                imageData =
                                                                await pickedFile
                                                                    .readAsBytes();
                                                            BlocProvider.of<
                                                                        UserBloc>(
                                                                    context)
                                                                .add(UploadImageEvent(
                                                                    imageData)); // Send image to Bloc
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the modal
                                                          } catch (e) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                  content: Text(
                                                                      'Error: ${e.toString()}')),
                                                            );
                                                          }
                                                        } else {
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            SnackBar(
                                                                content: Text(
                                                                    'No image selected.')),
                                                          );
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 40, 120, 63),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Advisor: ${user.advisorRoom}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Subject taught: ${user.subject}',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tel: ${user.phoneNumber}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Email: ${user.email}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Column(
                    children: [
                      // ปุ่ม Edit Profile
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.edit,
                              color: Color.fromARGB(255, 40, 120, 63)),
                          label: Text(
                            'Edit Profile',
                            style: TextStyle(
                                color: Color.fromARGB(255, 40, 120, 63)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    UpdateProfilePage(user: user),
                              ),
                            ).then((value) {
                              // รีเฟรชข้อมูลหลังจากกลับมาจากหน้า UpdateProfilePage
                              context.read<UserBloc>().add(FetchUserData());
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(249, 216, 244, 232),
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      // ปุ่ม Change Password
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.lock,
                              color: Color.fromARGB(255, 40, 120, 63)),
                          label: Text('Change Password',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 40, 120, 63))),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangePasswordPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(249, 216, 244, 232),
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      // ปุ่ม Logout
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.logout,
                              color: Color.fromARGB(255, 120, 40, 40)),
                          label: Text('Logout',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 120, 40, 40))),
                          onPressed: () {
                            _showConfirmationPopup(
                              context,
                              'Confirm Logout',
                              'Are you sure you want to log out?',
                              () {
                                // Perform logout
                                context.read<AuthBloc>().add(AuthLogoutEvent());

                                // Navigate to login page and remove all previous routes
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                  (Route<dynamic> route) => false,
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 65, vertical: 15),
                            backgroundColor:
                                const Color.fromARGB(255, 240, 158, 158),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (state is FailureState) {
            return Center(child: Text(state.error));
          }
          return Container();
        },
      ),
    );
  }

  // Function to show confirmation dialog
  void _showConfirmationPopup(BuildContext context, String title,
      String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Text(
            content,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
            TextButton(
              onPressed: onConfirm,
              child: Text(
                'Confirm',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          actionsPadding: EdgeInsets.only(right: 12, bottom: 10),
        );
      },
    );
  }
}
