import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabasetime/locator.dart';
import 'package:supabasetime/shared/components/custom_button.dart';
import 'package:supabasetime/shared/services/supabase/supabase_service.dart';

import '../../shared/resources/resource.dart';
import '../view_model/login_view_model.dart';
import '../../shared/extensions/snackbar_extension.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late LoginViewModel viewModel;
  late final TextEditingController _emailController;
  late final StreamSubscription<AuthState> _authStateSubscription;
  bool _redirecting = false;

  @override
  void initState() {
    super.initState();
    viewModel = context.read();
    _emailController = TextEditingController();

    final supabase = locator<SupabaseService>().supabaseClient;

    _authStateSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;

      final session = data.session;

      if (session != null) {
        _redirecting = true;
        viewModel.navToHome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer<LoginViewModel>(
          builder: (context, model, child) {
            return Column(
              children: [
                child!,
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          onChanged: (text) {
                            viewModel.validateEmail(text);
                          },
                          cursorColor: Colors.green,
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        if (!viewModel.enableSignIn &&
                            _emailController.text.isNotEmpty) ...[
                          const Row(
                            children: [
                              Text(
                                'Enter valid email',
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 18),
                        CustomButton(
                          onPressed: () async {
                            await viewModel.login(_emailController.text);

                            if (mounted) {
                              context.showSnackBar(
                                message: 'Check your email for login link!',
                              );
                              _emailController.clear();
                            }
                          },
                          buttonText: 'Sign In',
                          isEnabled: viewModel.enableSignIn,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          child: Column(
            children: [
              SvgPicture.asset(
                SVGResource.logo,
                alignment: Alignment.center,
              ),
              Text(
                'Your #1 Mood Tracker',
                style: TextStyle(
                  fontSize: 30,
                  foreground: Paint()
                    ..shader = ui.Gradient.linear(
                      const Offset(0, 20),
                      const Offset(150, 20),
                      <Color>[
                        Colors.red,
                        Colors.yellow,
                      ],
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }
}
