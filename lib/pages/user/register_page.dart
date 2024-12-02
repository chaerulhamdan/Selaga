import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:selaga_ver1/pages/components/auth_field.dart';
import 'package:selaga_ver1/repositories/api_repository.dart';
import 'package:selaga_ver1/repositories/models/register_user_model.dart';
import 'package:selaga_ver1/repositories/providers.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var _isSending = false;

  void _signUpUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      var data = await ApiRepository().userRegister(RegisterUserModel(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
          status: 'reguler'));

      if (data.result != null && data.error == null) {
        if (!mounted) {
          return;
        }
        context.read<Token>().getToken(data.result!);
        context.goNamed('user_home');
      } else if (data.error == null) {
        setState(() {
          _isSending = false;
        });
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No Internet'),
            duration: Duration(milliseconds: 1200),
          ),
        );
      } else {
        setState(() {
          _isSending = false;
        });
        if (!mounted) {
          return;
        }
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('${data.error}'),
        //     duration: const Duration(milliseconds: 1200),
        //   ),
        // );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email atau Nomor HP sudah digunakan'),
            duration: Duration(milliseconds: 1200),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(
                  color: Color.fromRGBO(76, 76, 220, 1),
                  Icons.app_registration_rounded,
                  size: 100,
                ),
                const SizedBox(height: 25),
                Text(
                  'Jadilah Bagian dari Komunitas Kami ',
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Buat akun sekarang dan nikmati manfaatnya!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 35),
                AuthField(
                  controller: _nameController,
                  hintText: 'Nama Lengkap',
                ),
                const SizedBox(height: 10),
                AuthField(
                  controller: _emailController,
                  hintText: 'Email',
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: 'Nomor Handphone',
                        hintStyle: TextStyle(color: Colors.grey[500])),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Mohon isi kolom Nomor Handphone";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                AuthField(
                  controller: _passwordController,
                  hintText: 'Kata Sandi',
                  isObscureText: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextFormField(
                    controller: _confirmController,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: 'Konfirmasi kata sandi',
                        hintStyle: TextStyle(color: Colors.grey[500])),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Mohon isi kolom Konfirmasi kata sandi";
                      } else if (value != _passwordController.text) {
                        return "Kata sandi tidak sesuai";
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: _isSending ? null : _signUpUser,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(76, 76, 220, 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: _isSending
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
