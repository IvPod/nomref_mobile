import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomref_mob/authentication/cubit/authentication_cubit.dart';
import 'package:nomref_mob/services/common_ui/common_ui.dart';

import '../profile.dart';
import '../../../pages/home/home.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({Key key}) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _labelFields = <String>[
    'name',
    'email',
    'address',
    'password',
    'repeatPassword',
  ];
  final _controllers = <String, TextEditingController>{};
  AuthenticationCubit _authenticationCubit;
  final _formKey = GlobalKey<FormState>();
  ProfileCubit _profileCubit;

  @override
  void initState() {
    super.initState();
    _authenticationCubit =
        BlocProvider.of<AuthenticationCubit>(context);
    _labelFields.forEach((label) {
      var value = '';
      switch (label) {
        case 'name':
          value = _authenticationCubit.userRepository.user.name;
          break;
        case 'email':
          value = _authenticationCubit.userRepository.user.email;
          break;
        case 'address':
          value = _authenticationCubit
              .userRepository.user.location.formattedAddress;
          break;
      }
      _controllers[label] = TextEditingController(text: value);
    });
    _profileCubit = BlocProvider.of<ProfileCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      cubit: _profileCubit,
      listener: (context, state) {
        Scaffold.of(context).removeCurrentSnackBar();
        if (state is ProfileLoading)
          showSnackBar(
            context,
            'Обновление данных...',
            showProgress: true,
          );
        if (state is ProfileSuccess)
          showSnackBar(context, 'Данные успешно обновлены');
        if (state is ProfileDeleted)
          Navigator.of(context)
              .popUntil(ModalRoute.withName(HomePage.routeName));
        if (state is ProfileFailed)
          showSnackBar(
            context,
            'Ошибка обновления данных!',
            isError: true,
          );
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _controllers[_labelFields[0]],
                    decoration: InputDecoration(
                      icon: Icon(Icons.account_circle_outlined),
                      labelText: 'Имя',
                    ),
                    validator: (value) =>
                        _controllers[_labelFields[0]].text.isEmpty
                            ? 'Введите имя'
                            : null,
                  ),
                  TextFormField(
                    controller: _controllers[_labelFields[1]],
                    enabled: false,
                    decoration: InputDecoration(
                      icon: Icon(Icons.email_outlined),
                      labelText: 'Email',
                    ),
                    validator: (value) =>
                        !RegExp('.+@.+\..+').hasMatch(value)
                            ? 'Неправильный email'
                            : null,
                  ),
                  TextFormField(
                    controller: _controllers[_labelFields[2]],
                    decoration: InputDecoration(
                      icon: Icon(Icons.location_on_outlined),
                      labelText: 'Адрес',
                    ),
                    validator: (value) =>
                        _controllers[_labelFields[2]].text.isEmpty
                            ? 'Введите адрес'
                            : null,
                  ),
                  TextFormField(
                    controller: _controllers[_labelFields[3]],
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock_outline),
                      labelText: 'Пароль',
                    ),
                    obscureText: true,
                    validator: (value) =>
                        _controllers[_labelFields[3]].text.length >
                                    0 &&
                                _controllers[_labelFields[3]]
                                        .text
                                        .length <
                                    6
                            ? 'Длина не менее 6 символов'
                            : null,
                  ),
                  TextFormField(
                    controller: _controllers[_labelFields[4]],
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock_outline),
                      labelText: 'Повторите пароль',
                    ),
                    obscureText: true,
                    validator: (value) =>
                        _controllers[_labelFields[4]].text !=
                                _controllers[_labelFields[3]].text
                            ? 'Пароли не совпадают'
                            : null,
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 15,
                    alignment: WrapAlignment.center,
                    children: [
                      CustomButton.withText(
                        context,
                        text: 'Удалить',
                        textColor: Colors.red[500],
                        onTap: _profileCubit.deleteMyProfile,
                      ),
                      CustomButton.withText(
                        context,
                        text: 'Сохранить',
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            final data = {
                              'name':
                                  _controllers[_labelFields[0]].text,
                              'address':
                                  _controllers[_labelFields[2]].text,
                            };
                            if (_controllers[_labelFields[3]]
                                    .text
                                    .length >
                                0)
                              data['password'] =
                                  _controllers[_labelFields[3]].text;
                            _profileCubit.updateInfo(data);
                          }
                        },
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  FlatButton(
                    onPressed: () async {
                      await _authenticationCubit.loggedOut();
                      Navigator.of(context).pop();
                    },
                    child: Text('Выйти из системы'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
