import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:productos_app/services/push_notification_service.dart';
import 'package:productos_app/ui/input_decoration.dart';
import 'package:productos_app/validators/login_form_validator.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.25,
                  ),
                  CardContainer(
                    child: Column(children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Login',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ChangeNotifierProvider(
                          create: (_) => LoginFormProvider(),
                          child: const _LoginForm())
                    ]),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushReplacementNamed(context, 'register'),
                    child: const Text(
                      'Crear una cuenta nueva',
                      style: TextStyle(
                          fontSize: 16, decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LoginFormProvider provider = Provider.of<LoginFormProvider>(context);
    return Form(
        key: provider.formKey,
        child: Column(
          children: [
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                  prefixIcon: Icons.alternate_email_sharp,
                  hintText: 'jhon.doe@mail.com',
                  labelText: 'Email'),
              onChanged: (val) => provider.email = val,
              validator: (val) {
                return Validators.emailValidator(value: val ?? '')
                    ? null
                    : 'Formato de correo incorrecto';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              obscureText: true,
              onChanged: (val) => provider.password = val,
              keyboardType: TextInputType.text,
              decoration: InputDecorations.authInputDecoration(
                hintText: '********',
                labelText: 'Password',
                prefixIcon: Icons.lock,
              ),
              validator: (val) {
                return Validators.passwordValidator(password: val ?? '')
                    ? null
                    : 'Debe contener al menos 8 caracteres,1 caracter especial y 1 numero';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: MaterialButton(
                onPressed: !provider.loading
                    ? () async {
                        FocusScope.of(context).unfocus();

                        if (!provider.isValid()) return;
                        provider.seLoading = true;

                        final String? errorMessage =
                            await Provider.of<AuthService>(context,
                                    listen: false)
                                .login(provider.email, provider.password);

                        provider.seLoading = false;
                        if (errorMessage == null) {
                          await PushNotificationService
                              .storeTokenInDBAndDevice();

                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, 'home');
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              'Error: $errorMessage',
                              textAlign: TextAlign.center,
                            ),
                            action: SnackBarAction(
                                label: 'Cerrar', onPressed: () {}),
                          ));
                        }
                      }
                    : null,
                color: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                disabledColor: Colors.grey,
                elevation: 0,
                child: Text(
                  provider.loading ? 'Espere por favor' : 'Ingresar',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ));
  }
}
