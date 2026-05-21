import 'package:videocalling/common/utils/app_imports.dart';

class EditTextField extends StatelessWidget {
  TextEditingController editingController;
  String labelText;
  dynamic errorText;
  Function(String)? onChanged;
  TextInputType? keyboardType;
  bool? obscureText;
  Widget? suffixIcon;

  EditTextField({super.key, 
    required this.editingController,
    required this.labelText,
    required this.errorText,
    required this.onChanged,
    this.keyboardType,
    this.obscureText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText ?? false,
      obscuringCharacter: (obscureText ?? false) ? '*' : '.',
      controller: editingController,
      keyboardType: keyboardType ?? null,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: suffixIcon ?? const SizedBox(),
        labelStyle: TextStyle(
          color: AppColors.LIGHT_GREY_TEXT,
          fontFamily: AppFontStyleTextStrings.regular,
        ),
        border: const UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.LIGHT_GREY_TEXT)),
        errorText: errorText,
      ),
      style: const TextStyle(
          color: AppColors.BLACK, fontFamily: AppFontStyleTextStrings.medium),
      onChanged: onChanged,
    );
  }
}

class EditTextFormField extends StatelessWidget {
  String labelText;
  dynamic errorText;
  Function(String) onChanged;
  dynamic validator;
  TextInputType? keyboardType;
  bool? obscureText;
  Widget? suffixIcon;

  EditTextFormField({super.key, 
    required this.labelText,
    required this.errorText,
    required this.onChanged,
    required this.validator,
    this.keyboardType,
    this.obscureText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? null,
      decoration: InputDecoration(
        suffixIcon: suffixIcon ?? const SizedBox(),
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppColors.LIGHT_GREY_TEXT,
          fontFamily: AppFontStyleTextStrings.regular,
        ),
        border: const UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.LIGHT_GREY_TEXT)),
        errorText: errorText,
      ),
      style: const TextStyle(
          color: AppColors.BLACK, fontFamily: AppFontStyleTextStrings.medium),
      validator: validator,
      onChanged: onChanged,
    );
  }
}

class DEditTextFormField extends StatelessWidget {
  String labelText;
  dynamic errorText;
  Function(String) onChanged;
  dynamic validator;
  TextInputType? keyboardType;
  bool? obscureText;
  Widget? suffixIcon;

  DEditTextFormField({super.key, 
    required this.labelText,
    required this.errorText,
    required this.onChanged,
    this.validator,
    this.keyboardType,
    this.obscureText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      keyboardType: keyboardType ?? null,
      decoration: InputDecoration(
        suffixIcon: suffixIcon ?? const SizedBox(),
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppColors.LIGHT_GREY_TEXT,
          fontFamily: AppFontStyleTextStrings.regular,
        ),
        border: const UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.LIGHT_GREY_TEXT)),
        errorText: errorText,
      ),
      style: const TextStyle(
        color: AppColors.BLACK,
        fontFamily: AppFontStyleTextStrings.medium,
      ),
      validator: validator ?? null,
      onChanged: onChanged,
    );
  }
}

class DEditPasswordFormField extends StatelessWidget {
  String labelText;
  TextEditingController controller;
  dynamic errorText;
  String? obscureCharacter;
  Function(String?) onChanged;
  bool? obscureText;
  Widget? suffixIcon;

  DEditPasswordFormField({super.key, 
    required this.labelText,
    required this.errorText,
    required this.controller,
    required this.onChanged,
    this.obscureCharacter,
    this.obscureText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscuringCharacter: obscureCharacter ?? '.',
      obscureText: obscureText ?? false,
      controller: controller,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        suffixIcon: suffixIcon ?? const SizedBox(),
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppColors.LIGHT_GREY_TEXT,
          fontFamily: AppFontStyleTextStrings.regular,
        ),
        border: const UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.LIGHT_GREY_TEXT)),
        errorText: errorText,
      ),
      style: const TextStyle(
        color: AppColors.BLACK,
        fontFamily: AppFontStyleTextStrings.medium,
      ),
      onChanged: onChanged,
    );
  }
}

class CommonTextField1 extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle mainStyle;
  final TextStyle labelStyle;
  String? labelText;
  String? errorText;
  TextInputType? textInputType;
  bool? readOnly;

  CommonTextField1(
      {super.key,
      required this.controller,
      required this.labelStyle,
      required this.mainStyle,
      this.errorText,
      this.readOnly,
      this.labelText,
      this.textInputType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: TextFormField(
        keyboardType: textInputType,
        controller: controller,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: AppFontStyleTextStrings.medium,
        ),
        readOnly: readOnly ?? false,
        validator: (value) {
          if (value!.isEmpty) {
            return '$errorText';
          }
          return null;
        },
        maxLines: null,
        decoration: InputDecoration(
            labelText: "$labelText",
            labelStyle: labelStyle,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 11.0, horizontal: 15),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.color1)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: AppColors.noPrescriptionTextColor))),
      ),
    );
  }
}

class EditProfileFormField extends StatelessWidget {
  String labelText;
  dynamic errorText;
  TextEditingController? controller;

  EditProfileFormField({super.key, 
    required this.labelText,
    required this.errorText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      minLines: 1,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: AppColors.LIGHT_GREY_TEXT,
          fontFamily: AppFontStyleTextStrings.regular,
        ),
        border: const UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.LIGHT_GREY_TEXT,
          ),
        ),
        errorText: errorText,
      ),
      style: const TextStyle(
        color: AppColors.BLACK,
        fontFamily: AppFontStyleTextStrings.medium,
      ),
    );
  }
}

class EditDetailFormField extends StatelessWidget {
  String labelText;
  dynamic errorText;
  TextEditingController? controller;
  int maxLines;
  Function(String) onChanged;

  EditDetailFormField({super.key, 
    required this.labelText,
    required this.errorText,
    required this.controller,
    required this.maxLines,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      minLines: 1,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColorDark.withOpacity(0.4),
          fontFamily: AppFontStyleTextStrings.regular,
        ),
        border: const UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColorDark)),
        errorText: errorText,
      ),
      style: const TextStyle(
        fontFamily: AppFontStyleTextStrings.medium,
        fontSize: 14,
      ),
      onChanged: onChanged,
    );
  }
}

class EditDetailFormField1 extends StatelessWidget {
  String? prefixText;
  String labelText;
  dynamic errorText;
  TextEditingController? controller;
  Function(String) onChanged;
  TextInputType? keyboardType;

  EditDetailFormField1({super.key, 
    this.prefixText,
    required this.labelText,
    required this.errorText,
    required this.controller,
    this.keyboardType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType ?? TextInputType.text,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColorDark.withOpacity(0.4),
          fontFamily: AppFontStyleTextStrings.regular,
        ),
        prefixText: prefixText ?? "",
        border: const UnderlineInputBorder(),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColorDark)),
        errorText: errorText,
      ),
      style: const TextStyle(
        fontFamily: AppFontStyleTextStrings.medium,
        fontSize: 14,
      ),
      onChanged: onChanged,
    );
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}


