import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/app/app_barrel.dart';
import '/src/global/ui/ui_barrel.dart';

class FilledButton extends StatelessWidget {
  final Function? onPressed;
  final Widget? child;
  final String? text, icon;
  final Color color, borderColor;
  final bool isCircle, isWide, hasBorder;

  FilledButton({
    required this.onPressed,
    this.child,
    this.text,
    this.icon,
    this.isWide = true,
    this.isCircle = false,
    this.borderColor = AppColors.white,
    this.hasBorder = false,
    this.color = AppColors.accentColor,
    Key? key,
  }) : super(key: key);

  bool disabled = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return RawMaterialButton(
        fillColor: disabled ? AppColors.grey : color,
        elevation: 2,
        shape: isCircle
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: Ui.circularRadius(8),
                side: hasBorder
                    ? BorderSide(color: borderColor)
                    : BorderSide.none,
              ),
        onPressed: disabled
            ? null
            : () async {
                setState(() {
                  disabled = true;
                });
                await onPressed!();
                setState(() {
                  disabled = false;
                });
              },
        child: isCircle
            ? Container(
                padding: const EdgeInsets.all(16),
                child:
                    SizedBox(height: 28, width: 28, child: Image.asset(icon!)),
              )
            : Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                ),
                width: isWide ? double.maxFinite : (Get.width / 2) - 36,
                child: Center(
                  child: !disabled
                      ? child ??
                          AppText.button(
                            text!,
                            color: hasBorder
                                ? borderColor
                                : color == AppColors.white
                                    ? AppColors.primaryColor
                                    : AppColors.white,
                          )
                      : const LoadingIndicator(),
                )),
      );
    });
  }

  static social(
    VoidCallback onPressed,
    String icon,
  ) {
    return FilledButton(
      onPressed: onPressed,
      icon: icon,
      color: AppColors.white,
      isCircle: true,
    );
  }

  static half(
    VoidCallback onPressed,
    String title,
  ) {
    return FilledButton(
      onPressed: onPressed,
      text: title,
      isWide: false,
    );
  }

  static white(
    VoidCallback onPressed,
    String title,
  ) {
    return FilledButton(
      onPressed: onPressed,
      color: AppColors.white,
      text: title,
    );
  }

  static outline(VoidCallback onPressed, String title,
      {Color color = AppColors.primaryColor}) {
    return FilledButton(
      onPressed: onPressed,
      hasBorder: true,
      text: title,
      color: color,
    );
  }
}
