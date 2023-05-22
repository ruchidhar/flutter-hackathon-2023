import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:supabasetime/shared/components/custom_button.dart';

import '../view_model/account_view_model.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  late AccountViewModel viewModel;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel = context.read();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await viewModel.fetchProfile();
      _nameController.text = viewModel.appModel.userProfile.username!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Details')),
      body: SafeArea(
        child: Consumer<AccountViewModel>(
          builder: (BuildContext context, model, Widget? child) {
            if (model.isLoading) {
              return child!;
            }

            final url = viewModel.appModel.userProfile.avatarUrl;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (url!.isNotEmpty) ...[
                    Image.network(
                      url,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () {
                        viewModel.uploadPhoto();
                      },
                      child: const Text('Upload Photo'),
                    ),
                  ],
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'User Name'),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      final userName = _nameController.text.trim();
                      viewModel.updateUserName(userName);
                    },
                    child: const Text('Update'),
                  ),
                  Expanded(
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              isEnabled: true,
                              onPressed: () {
                                viewModel.signOut();
                              },
                              buttonText: 'Sign Out',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
