import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nomref_mob/pages/registration/view/view.dart';

import 'package:nomref_mob/services/common_ui/common_ui.dart';

import '../login.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController, _passwordController;
  LoginCubit _loginCubit;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loginCubit = BlocProvider.of<LoginCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      cubit: _loginCubit,
      listener: (context, state) async {
        Scaffold.of(context).removeCurrentSnackBar();
        if (state is LoginLoading)
          showSnackBar(
            context,
            'Авторизация...',
            showProgress: true,
          );
        if (state is LoginSuccess) {
          showSnackBar(
            context,
            'Авторизация прошла успешно',
          );
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pop();
        }
        if (state is LoginFailed)
          showSnackBar(
            context,
            'Ошибка авторизации',
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
                    controller: _emailController,
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
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.lock_outline),
                      labelText: 'Пароль',
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  CustomButton.withText(
                    context,
                    text: 'Подтвердить',
                    onTap: () {
                      if (_formKey.currentState.validate())
                        _loginCubit.logIn({
                          'email': _emailController.text,
                          'password': _passwordController.text,
                        });
                    },
                  ),
                  SizedBox(height: 10),
                  FlatButton(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      RegistrationPage.routeName,
                    ),
                    child: Text('Нет учётной записи'),
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
