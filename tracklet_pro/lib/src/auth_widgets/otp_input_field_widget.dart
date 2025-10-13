import 'package:flutter/material.dart';
import 'package:tracklet_pro/src/utils/app_colors.dart';

/// OtpInputFieldWidget - Yeh ek reusable OTP input widget hai jo:
/// - 6-digit OTP input handle karta hai
/// - Auto focus transition karta hai
/// - Custom styling support karta hai
/// - Validation support karta hai
///
/// Features:
/// - 6 input fields
/// - Auto focus
/// - Custom styling
/// - Validation
class OtpInputFieldWidget extends StatefulWidget {
  final void Function(String)? onCompleted;
  final String? errorText;

  const OtpInputFieldWidget({
    super.key,
    this.onCompleted,
    this.errorText,
  });

  @override
  State<OtpInputFieldWidget> createState() => _OtpInputFieldWidgetState();
}

class _OtpInputFieldWidgetState extends State<OtpInputFieldWidget> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(6, (index) => TextEditingController());
    _focusNodes = List.generate(6, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Enter OTP',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.onBackground,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 50,
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                maxLength: 1,
                textDirection: TextDirection.ltr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  errorText: index == 5 ? widget.errorText : null,
                  errorStyle: TextStyle(
                    color: AppColors.error,
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: AppColors.lightBlueBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? AppColors.error
                          : AppColors.lightBlue,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? AppColors.error
                          : AppColors.lightBlue,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: widget.errorText != null
                          ? AppColors.error
                          : AppColors.darkBlue,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.error,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    if (index < 5) {
                      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                    } else {
                      // Last field - check if all fields are filled
                      final otp = _getOtp();
                      if (otp.length == 6) {
                        widget.onCompleted?.call(otp);
                      }
                    }
                  } else {
                    if (index > 0) {
                      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                    }
                  }
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  /// OTP get karne ke liye private method
  String _getOtp() {
    return _controllers.map((controller) => controller.text).join();
  }
}