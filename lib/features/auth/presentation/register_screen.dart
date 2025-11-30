import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _confirmPassword = '';
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _loading = false;
  Map<String, String> _errors = {};

  bool get _isAr => Localizations.localeOf(context).languageCode == 'ar';

  bool _validate() {
    final isAr = _isAr;
    final next = <String, String>{};

    if (_fullName.trim().isEmpty) {
      next['fullName'] = isAr
          ? 'الرجاء إدخال الاسم الكامل'
          : 'Please enter your full name';
    }

    if (_email.trim().isEmpty) {
      next['email'] = isAr
          ? 'الرجاء إدخال البريد الإلكتروني'
          : 'Please enter your email';
    } else {
      final regex = RegExp(r'\S+@\S+\.\S+');
      if (!regex.hasMatch(_email.trim())) {
        next['email'] = isAr
            ? 'البريد الإلكتروني غير صحيح'
            : 'Invalid email address';
      }
    }

    if (_phone.trim().isEmpty) {
      next['phone'] = isAr
          ? 'الرجاء إدخال رقم الهاتف'
          : 'Please enter your phone number';
    }

    if (_password.isEmpty) {
      next['password'] = isAr
          ? 'الرجاء إدخال كلمة المرور'
          : 'Please enter a password';
    } else if (_password.length < 6) {
      next['password'] = isAr
          ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل'
          : 'Password must be at least 6 characters';
    }

    if (_password != _confirmPassword) {
      next['confirmPassword'] = isAr
          ? 'كلمة المرور غير متطابقة'
          : 'Passwords do not match';
    }

    setState(() {
      _errors = next;
    });

    return next.isEmpty;
  }

  Future<void> _handleRegister() async {
    if (!_validate()) return;

    setState(() {
      _loading = true;
    });

    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAr ? 'تم إنشاء الحساب (واجهة فقط)' : 'Account created (UI only demo)',
        ),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _handleGoogleRegister() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAr
              ? 'التسجيل عبر Google واجهة فقط حالياً'
              : 'Google sign up is UI-only for now',
        ),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _goToLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAr ? 'هنا تربط شاشة تسجيل الدخول' : 'Hook login screen navigation here',
        ),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isAr = _isAr;

    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      isAr ? 'إنشاء حساب جديد' : 'Create Account',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: cs.onBackground,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAr ? 'انضم إلينا اليوم' : 'Join us today',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 32),
                    Column(
                      children: [
                        _buildFullNameField(cs),
                        const SizedBox(height: 12),
                        _buildEmailField(cs),
                        const SizedBox(height: 12),
                        _buildPhoneField(cs),
                        const SizedBox(height: 12),
                        _buildPasswordField(cs),
                        const SizedBox(height: 12),
                        _buildConfirmPasswordField(cs),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton(
                            onPressed: _loading ? null : _handleRegister,
                            child: _loading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    isAr ? 'إنشاء حساب' : 'Create Account',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: cs.outlineVariant,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              isAr ? 'أو' : 'OR',
                              style: TextStyle(
                                color: cs.onSurfaceVariant,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: cs.outlineVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: OutlinedButton(
                            onPressed: _handleGoogleRegister,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: cs.outlineVariant),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: _GoogleLogo(),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isAr
                                      ? 'المتابعة مع Google'
                                      : 'Continue with Google',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Center(
                        child: Wrap(
                          children: [
                            Text(
                              isAr
                                  ? 'لديك حساب بالفعل؟ '
                                  : 'Already have an account? ',
                              style: TextStyle(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            GestureDetector(
                              onTap: _goToLogin,
                              child: Text(
                                isAr ? 'تسجيل الدخول' : 'Login',
                                style: TextStyle(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFullNameField(ColorScheme cs) {
    final isAr = _isAr;
    return TextField(
      textInputAction: TextInputAction.next,
      onChanged: (v) {
        setState(() {
          _fullName = v;
          _errors.remove('fullName');
        });
      },
      decoration: InputDecoration(
        hintText: isAr ? 'الاسم الكامل' : 'Full Name',
        prefixIcon: Icon(Icons.person_outline, color: cs.onSurfaceVariant),
        errorText: _errors['fullName'],
        filled: true,
        fillColor: cs.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildEmailField(ColorScheme cs) {
    final isAr = _isAr;
    return TextField(
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: (v) {
        setState(() {
          _email = v;
          _errors.remove('email');
        });
      },
      decoration: InputDecoration(
        hintText: isAr ? 'البريد الإلكتروني' : 'Email',
        prefixIcon: Icon(Icons.mail_outline, color: cs.onSurfaceVariant),
        errorText: _errors['email'],
        filled: true,
        fillColor: cs.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildPhoneField(ColorScheme cs) {
    final isAr = _isAr;
    return TextField(
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      onChanged: (v) {
        setState(() {
          _phone = v;
          _errors.remove('phone');
        });
      },
      decoration: InputDecoration(
        hintText: isAr ? 'رقم الهاتف' : 'Phone Number',
        prefixIcon: Icon(Icons.phone_outlined, color: cs.onSurfaceVariant),
        errorText: _errors['phone'],
        filled: true,
        fillColor: cs.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildPasswordField(ColorScheme cs) {
    final isAr = _isAr;
    return TextField(
      obscureText: !_showPassword,
      textInputAction: TextInputAction.next,
      onChanged: (v) {
        setState(() {
          _password = v;
          _errors.remove('password');
        });
      },
      decoration: InputDecoration(
        hintText: isAr ? 'كلمة المرور' : 'Password',
        prefixIcon: Icon(Icons.lock_outline, color: cs.onSurfaceVariant),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
          icon: Icon(
            _showPassword ? Icons.visibility_off : Icons.visibility,
            color: cs.onSurfaceVariant,
          ),
        ),
        errorText: _errors['password'],
        filled: true,
        fillColor: cs.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildConfirmPasswordField(ColorScheme cs) {
    final isAr = _isAr;
    return TextField(
      obscureText: !_showConfirmPassword,
      textInputAction: TextInputAction.done,
      onChanged: (v) {
        setState(() {
          _confirmPassword = v;
          _errors.remove('confirmPassword');
        });
      },
      decoration: InputDecoration(
        hintText: isAr ? 'تأكيد كلمة المرور' : 'Confirm Password',
        prefixIcon: Icon(Icons.lock_outline, color: cs.onSurfaceVariant),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _showConfirmPassword = !_showConfirmPassword;
            });
          },
          icon: Icon(
            _showConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: cs.onSurfaceVariant,
          ),
        ),
        errorText: _errors['confirmPassword'],
        filled: true,
        fillColor: cs.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.primary, width: 1.5),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}

class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GoogleLogoPainter(),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    final greenPaint = Paint()..color = const Color(0xFF34A853);
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final redPaint = Paint()..color = const Color(0xFFEA4335);

    final strokeWidth = w * 0.22;

    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      w - strokeWidth,
      h - strokeWidth,
    );

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawArc(
      rect,
      -0.2,
      1.2,
      false,
      basePaint..color = bluePaint.color,
    );

    canvas.drawArc(
      rect,
      1.0,
      1.1,
      false,
      basePaint..color = greenPaint.color,
    );

    canvas.drawArc(
      rect,
      2.1,
      0.9,
      false,
      basePaint..color = yellowPaint.color,
    );

    canvas.drawArc(
      rect,
      3.0,
      1.1,
      false,
      basePaint..color = redPaint.color,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
