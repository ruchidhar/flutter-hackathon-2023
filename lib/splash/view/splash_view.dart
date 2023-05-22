import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../shared/resources/resource.dart';
import '../view_model/splash_view_model.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late SplashViewModel viewModel;
  bool _redirectCalled = false;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<SplashViewModel>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (_redirectCalled || !mounted) {
      return;
    }

    _redirectCalled = true;
    viewModel.redirectAfterAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SplashViewModel>(
        builder: (context, model, child) {
          if (model.isLoading) {
            return const SizedBox();
          }

          return Container(
            color: const Color(0xFF000000),
            child: Center(
              child: SvgPicture.asset(
                SVGResource.logo,
                alignment: Alignment.center,
              ),
            ),
          );
        },
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
