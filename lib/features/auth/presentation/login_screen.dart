import 'package:flutter/material.dart';
import 'package:restaurant_customer_app/design_system/widgets/ds_button.dart';
import 'package:restaurant_customer_app/design_system/widgets/ds_input.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoggedIn;
  final VoidCallback? onRegister;

  const LoginScreen({
    super.key,
    this.onLoggedIn,
    this.onRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _showPassword = false;
  bool _loading = false;
  String _error = '';

  bool _isAr(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ar';

  Future<void> _login() async {
    setState(() => _error = '');

    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    final emailEmpty = email.isEmpty;
    final passEmpty = pass.isEmpty;

    if (emailEmpty || passEmpty) {
      setState(() {
        _error = _isAr(context)
            ? 'الرجاء إدخال البريد الإلكتروني وكلمة المرور'
            : 'Please enter email and password';
      });
      return;
    }

    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() => _loading = false);

    if (!mounted) return;

    if (widget.onLoggedIn != null) {
      widget.onLoggedIn!.call();
    } else {
      // ✅ في حال ما تم تمرير onLoggedIn من برّة، نروح على الشيل مباشرة
      Navigator.of(context).pushReplacementNamed('/shell');
    }
  }

  void _googleLogin() {
    // ✅ حالياً بس رسالة، بدون أي تنقّل عشان ما يرجع الخطأ
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAr(context)
              ? 'تسجيل الدخول بـ Google غير مفعّل حالياً'
              : 'Google sign-in is not implemented yet',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ar = _isAr(context);

    final emailEmpty = _emailCtrl.text.trim().isEmpty;
    final passEmpty = _passCtrl.text.isEmpty;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      '🍽️',
                      style: TextStyle(fontSize: 56, height: 1),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      ar ? 'تسجيل الدخول' : 'Login',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: cs.onSurface,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ar ? 'مرحباً بعودتك!' : 'Welcome back!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 28),
                    DsInput(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      hintText: ar ? 'البريد الإلكتروني' : 'Email',
                      leftIcon: const Icon(Icons.mail_outline_rounded),
                      error: (_error.isNotEmpty && emailEmpty) ? _error : null,
                      onChanged: (_) {
                        if (_error.isNotEmpty) {
                          setState(() => _error = '');
                        }
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 14),
                    DsInput(
                      controller: _passCtrl,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: ar ? 'كلمة المرور' : 'Password',
                      leftIcon: const Icon(Icons.lock_outline_rounded),
                      obscureText: !_showPassword,
                      rightIcon: InkWell(
                        onTap: () => setState(
                          () => _showPassword = !_showPassword,
                        ),
                        child: Icon(
                          _showPassword
                              ? Icons.visibility_off_rounded
                              : Icons.visibility_rounded,
                        ),
                      ),
                      error: (_error.isNotEmpty && passEmpty) ? _error : null,
                      onChanged: (_) {
                        if (_error.isNotEmpty) {
                          setState(() => _error = '');
                        }
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment:
                          ar ? Alignment.centerLeft : Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          ar ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                          style: TextStyle(
                            color: cs.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    if (_error.isNotEmpty &&
                        !emailEmpty &&
                        !passEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: cs.error.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: cs.error.withOpacity(0.35),
                          ),
                        ),
                        child: Text(
                          _error,
                          style: TextStyle(
                            color: cs.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 14),
                    DsButton.primary(
                      size: DsButtonSize.lg,
                      expand: true,
                      onPressed: _loading ? null : _login,
                      loading: _loading,
                      child: Text(ar ? 'تسجيل الدخول' : 'Login'),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: cs.outlineVariant,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            ar ? 'أو' : 'OR',
                            style: TextStyle(
                              color: cs.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: cs.outlineVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    DsButton.secondary(
                      size: DsButtonSize.lg,
                      expand: true,
                      onPressed: _loading ? null : _googleLogin,
                      icon: const _GoogleIcon(size: 18),
                      child: Text(
                        ar
                            ? 'المتابعة مع Google'
                            : 'Continue with Google',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      ar ? 'ليس لديك حساب؟ ' : "Don't have an account? ",
                      style: TextStyle(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: widget.onRegister,
                      child: Text(
                        ar ? 'إنشاء حساب جديد' : 'Create Account',
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  final double size;

  const _GoogleIcon({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          'G',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: const Color(0xFF4285F4),
          ),
        ),
      ),
    );
  }
}
