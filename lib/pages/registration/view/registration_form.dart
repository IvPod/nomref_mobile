import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomref_mob/pages/home/home.dart';
import 'package:nomref_mob/pages/registration/cubit/registration_cubit.dart';
import 'package:nomref_mob/services/common_ui/common_ui.dart';

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _labelFields = <String>[
    'name',
    'email',
    'address',
    'password',
    'repeatPassword',
  ];
  final _controllers = <String, TextEditingController>{};
  final _formKey = GlobalKey<FormState>();
  RegistrationCubit _registrationCubit;

  @override
  void initState() {
    super.initState();
    _labelFields.forEach(
      (label) => _controllers[label] = TextEditingController(),
    );
    _registrationCubit = BlocProvider.of<RegistrationCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegistrationCubit, RegistrationState>(
      cubit: _registrationCubit,
      listener: (context, state) async {
        Scaffold.of(context).removeCurrentSnackBar();
        if (state is RegistrationLoading)
          showSnackBar(context, 'Регистрация...', showProgress: true);
        if (state is RegistrationSuccess) {
          showSnackBar(context, 'Регистрация прошла успешно');
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context)
              .popUntil(ModalRoute.withName(HomePage.routeName));
        }
        if (state is RegistrationFailed)
          showSnackBar(context, 'Ошибка регистрации!', isError: true);
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
                        _controllers[_labelFields[3]].text.length < 6
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
                  CustomButton.withText(
                    context,
                    text: 'Подтвердить',
                    onTap: () {
                      if (_formKey.currentState.validate())
                        _registrationCubit.signUp({
                          _labelFields[0]:
                              _controllers[_labelFields[0]].text,
                          _labelFields[1]:
                              _controllers[_labelFields[1]].text,
                          _labelFields[2]:
                              _controllers[_labelFields[2]].text,
                          _labelFields[3]:
                              _controllers[_labelFields[3]].text,
                        });
                    },
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
