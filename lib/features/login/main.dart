import 'package:flutter/material.dart';
import 'package:mobile_dikasa/components/text_field/main.dart';
import 'package:mobile_dikasa/core/constants/colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const String _heroAssetPath = 'assets/images/login_hero.png';
  static const String _logoAssetPath = 'assets/images/dikasa_logo.png';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login berhasil divalidasi.'),
        duration: Duration(milliseconds: 1400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool isDesktop = constraints.maxWidth >= 1100;

          if (isDesktop) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Expanded(
                  child: _LoginHeroPanel(assetPath: _heroAssetPath),
                ),
                Expanded(
                  child: Container(
                    color: AppColors.cFFFFFF,
                    child: SafeArea(
                      child: _CenterScrollable(
                        child: _LoginFormSection(
                          formKey: _formKey,
                          logoAssetPath: _logoAssetPath,
                          usernameController: _usernameController,
                          passwordController: _passwordController,
                          obscurePassword: _obscurePassword,
                          onTogglePassword: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          onLoginPressed: _onLoginPressed,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: const AspectRatio(
                          aspectRatio: 670 / 800,
                          child: _LoginHeroPanel(assetPath: _heroAssetPath),
                        ),
                      ),
                      const SizedBox(height: 22),
                      _LoginFormSection(
                        formKey: _formKey,
                        logoAssetPath: _logoAssetPath,
                        usernameController: _usernameController,
                        passwordController: _passwordController,
                        obscurePassword: _obscurePassword,
                        onTogglePassword: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        onLoginPressed: _onLoginPressed,
                        compact: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CenterScrollable extends StatelessWidget {
  const _CenterScrollable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoginHeroPanel extends StatelessWidget {
  const _LoginHeroPanel({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}

class _LoginFormSection extends StatelessWidget {
  const _LoginFormSection({
    required this.formKey,
    required this.logoAssetPath,
    required this.usernameController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onLoginPressed,
    this.compact = false,
  });

  final GlobalKey<FormState> formKey;
  final String logoAssetPath;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onLoginPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double logoWidth = compact ? 290 : 349;
    final double titleFontSize = compact ? 17 : 18;
    final double titleSpacing = compact ? 50 : 56;
    final double formGap = compact ? 22 : 36;
    final double buttonTopSpacing = compact ? 36 : 64;
    final double actionTopSpacing = compact ? 16 : 20;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 487),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Image.asset(
                logoAssetPath,
                width: logoWidth,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: titleSpacing),
            Text(
              'Masuk ke Dashboard',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.c737373,
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 44),
            AppTextField(
              controller: usernameController,
              hintText: 'Username atau Nomor Hp',
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              backgroundColor: AppColors.cEEEEEE,
              borderColor: AppColors.cEEEEEE,
              focusedBorderColor: AppColors.c097BC2,
              textStyle: TextStyle(
                color: AppColors.c0F0F0F,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              hintStyle: TextStyle(
                color: AppColors.c707070.withAlpha(128),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              borderRadius: 10,
              prefixIcon: Icon(
                Icons.person_outline_rounded,
                size: 22,
                color: AppColors.cA4A4A4,
              ),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Username / nomor HP wajib diisi';
                }
                return null;
              },
            ),
            SizedBox(height: formGap),
            AppTextField(
              controller: passwordController,
              hintText: 'Password',
              textInputAction: TextInputAction.done,
              obscureText: obscurePassword,
              backgroundColor: AppColors.cEEEEEE,
              borderColor: AppColors.cEEEEEE,
              focusedBorderColor: AppColors.c097BC2,
              textStyle: TextStyle(
                color: AppColors.c0F0F0F,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              hintStyle: TextStyle(
                color: AppColors.c707070.withAlpha(128),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              borderRadius: 10,
              prefixIcon: Icon(
                Icons.lock_outline,
                size: 22,
                color: AppColors.cA4A4A4,
              ),
              suffixIcon: IconButton(
                onPressed: onTogglePassword,
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: AppColors.cA4A4A4,
                ),
              ),
              onFieldSubmitted: (_) => onLoginPressed(),
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password wajib diisi';
                }
                return null;
              },
            ),
            SizedBox(height: buttonTopSpacing),
            SizedBox(
              height: 53,
              child: ElevatedButton(
                onPressed: onLoginPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cFF8227,
                  foregroundColor: AppColors.cFFFFFF,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Text('Masuk'),
              ),
            ),
            SizedBox(height: actionTopSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.c097BC2,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Daftar Akun Baru'),
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.c097BC2,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Lupa Password'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
