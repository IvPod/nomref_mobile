import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomref_mob/authentication/authentication.dart';

import '../profile.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var appBarKey = UniqueKey();
  ProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    _profileCubit =
        ProfileCubit(BlocProvider.of<AuthenticationCubit>(context));
  }

  @override
  void dispose() {
    _profileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final url =
        _profileCubit.authenticationCubit.userRepository?.user?.image;
    final imageRef = 'http://localhost:5000/uploads/$url';
    return Scaffold(
      appBar: AppBar(
        key: appBarKey,
        title: Text('Профиль'),
        actions: [
          GestureDetector(
            onTap: getImage,
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(imageRef),
                onBackgroundImageError: (exception, stackTrace) {},
              ),
            ),
          ),
        ],
      ),
      body: BlocProvider.value(
        value: _profileCubit,
        child: ProfileForm(),
      ),
    );
  }

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null &&
        File(pickedFile.path).lengthSync() < 1000000) {
      await _profileCubit.uploadAvatar(pickedFile.path);
      setState(() {
        appBarKey = UniqueKey();
        imageCache.clear();
      });
    }
  }
}
