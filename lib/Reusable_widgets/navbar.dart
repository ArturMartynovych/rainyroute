import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rainyroute/Utils/constants.dart';

import '../Screens/signin_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final user = FirebaseAuth.instance.currentUser;
  String imageUrl = '';

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('${user?.displayName} profile.jpg');

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        imageUrl = value;
      });
      if (user?.photoURL != null) {
        user!.updatePhotoURL(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      final name = user?.displayName;
      final email = user?.email;
      final photoUrl = user?.photoURL;

      return Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: name != null
                  ? Text(
                      name,
                      style: const TextStyle(color: Colors.black54),
                    )
                  : const Text('Name is loading..'),
              accountEmail: email != null
                  ? Text(
                      email,
                      style: const TextStyle(color: Colors.black54),
                    )
                  : const Text('Email is loading..'),
              currentAccountPicture: CircleAvatar(
                child: GestureDetector(
                  onTap: pickUploadImage,
                  child: ClipOval(
                    child: photoUrl == null && imageUrl == ''
                        ? Image.network(
                            'https://api-private.atlassian.com/users/71d3229d8e428d7c0d9ba95804f45317/avatar',
                            fit: BoxFit.cover,
                            width: 90,
                            height: 90,
                          )
                        : (imageUrl != ''
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                              )
                            : Image.network(
                                photoUrl!,
                                fit: BoxFit.cover,
                                width: 90,
                                height: 90,
                              )),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: weatherLight,
                image: const DecorationImage(
                  fit: BoxFit.cover,

                  image: AssetImage('assets/images/logo.png'),
                  // NetworkImage(
                  //     'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg'),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Ulubione trasy'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Udostępnij'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Ustawienia'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Polityka'),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              title: const Text('Wyloguj się'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () {
                FirebaseAuth.instance.signOut().then(
                  (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      );
    } else {
      return const Text("Not loaded");
    }
  }
}
