

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../res/app_colors.dart';
import '../../utills/custom_theme.dart';
import 'app_custom_text.dart';

class CustomTextFormField extends StatefulWidget {
  final bool isobscure;
  final bool isMobileNumber;
  final ValueChanged<String>? onChanged;
  final Function? onFieldSubmitted;
  final String? Function(String?)? validateName;
  final String hint;
  final String label;
  final int? maxLines;
  final bool isPasswordField;
  final int? maxLength;
  //final IconData icon;
  final Widget? widget;
  final Color borderColor;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Color backgroundColor;

  const CustomTextFormField(
      {super.key,
      this.maxLength,
      this.maxLines = 1,
        this.textInputType=TextInputType.text,
      //required this.icon,
       this.widget,
        this.backgroundColor=AppColors.white,
        this.borderColor=AppColors.grey,
      this.isPasswordField = false,
      required this.controller,
      this.validateName,
      this.validator,
      this.isMobileNumber = false,
      this.isobscure = false,
      this.onChanged,
      this.onFieldSubmitted,
      required this.hint,
      required this.label});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = false;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<CustomThemeState>(context).adaptiveThemeMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: widget.label,
          color: theme.isDark
              ? AppColors.darkModeBackgroundMainTextColor
              : AppColors.textColor2,
          size: 12,
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.isDark
                ? AppColors.darkModeBackgroundColor
                : AppColors.white,
            border: Border.all(
              color: widget.borderColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Row(
              children: [
                if (widget.isMobileNumber)
                  const Text(
                    '+234',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                if (widget.isMobileNumber) const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.isDark ? AppColors.white : AppColors.black,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding:  EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            if (widget.isPasswordField) {
                              _togglePasswordVisibility();
                            }
                          },
                          child: widget.widget ?? SizedBox(),
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          if (widget.isPasswordField) {
                            _togglePasswordVisibility();
                          }
                        },
                        child: Icon(
                          widget.isPasswordField
                              ? (!_obscureText
                              ? Icons.visibility_off
                              : Icons.visibility)
                              : null,
                        ),
                      ),
                      hintText: widget.hint,
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        color: theme.isDark
                            ? AppColors.darkModeBackgroundDisableColor
                            : AppColors.lightDivider,
                      ),
                      border: InputBorder.none,
                    ),
                    keyboardType: widget.textInputType,
                    validator: widget.validator,
                    maxLines: widget.maxLines,
                    maxLength: widget.maxLength,
                    obscureText: _obscureText,
                    onFieldSubmitted: (val) {
                      widget.onFieldSubmitted?.call(val);
                    },
                    onChanged: (val) {
                      if (widget.onChanged != null) {
                        widget.onChanged!(val);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTextFormPasswordField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validateName;
  final String label;
  final TextEditingController controller;

  const CustomTextFormPasswordField(
      {super.key,
      required this.controller,
      this.validateName,
      this.onChanged,
      required this.label});

  @override
  State<CustomTextFormPasswordField> createState() =>
      _CustomTextFormPasswordFieldState();
}

class _CustomTextFormPasswordFieldState
    extends State<CustomTextFormPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.label,
      ),
      keyboardType: TextInputType.text,
      validator: widget.validateName,
      onChanged: (String val) {
        //_name = val;
      },
    );
  }
}

class FormInput extends StatelessWidget {
  final bool isobscure;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final String label;
  final String hint;
  final String? value;
  final TextInputType inputType;
  final List<TextInputFormatter>? textInputFormatter;
  final int maxLines;
  final double width;
  final double height;
  final bool isEnabled;
  final bool topSpace;
  final int? maxLength;
  final Color? color;
  final Color? txColor;
  final Color? borderColor;
  final Function()? onTap;
  final Function(String)? validate;

  const FormInput({
    Key? key,
    this.onChanged,
    this.focusNode,
    required this.controller,
    this.label = '',
    this.topSpace = true,
    this.isobscure = false,
    this.hint = '',
    this.value,
    this.width = 200,
    this.color,
    this.txColor,
    this.height = 42,
    this.inputType = TextInputType.text,
    this.maxLines = 1,
    this.onTap,
    this.maxLength,
    this.isEnabled = true,
    this.validate,
    this.borderColor,
    this.textInputFormatter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.text = value != '' && value != null ? value! : controller.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        !topSpace
            ? const SizedBox.shrink()
            : Text(
                label,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),
              ),
        !topSpace ? const SizedBox.shrink() : const SizedBox(height: 8),
        Material(
          color: color ?? Colors.black12,
          elevation: 0,
          type: MaterialType.card,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Align(
            alignment: Alignment.topLeft,
            child: TextField(
                obscureText: isobscure,
                controller: controller,
                keyboardType: inputType,
                maxLines: maxLines,
                enabled: isEnabled,
                focusNode: focusNode,
                inputFormatters: textInputFormatter,
                style: TextStyle(color: txColor ?? Colors.black87),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.fromLTRB(8, height >= 48 ? 8 : 2, 8, 8),
                  hintText: hint,
                  hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                      overflow: TextOverflow.visible),
                ),
                onChanged: (text) {
                  // if (validate != null) {
                  //   WidgetsBinding.instance.addPostFrameCallback((_) {
                  //     error!.value = validate!(text);
                  //     try {
                  //       TextSelection previousSelection =
                  //           controller.selection;
                  //       //controller.text = text;
                  //       controller.selection = previousSelection;
                  //       //controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
                  //     } catch (e) {
                  //       dnd(e);
                  //     }
                  //   });
                  // }
                }),
          ),
        ),
      ],
    );
  }
}

class FormSelectInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType inputType;
  final int maxLines;
  final double width;
  final double height;
  final bool isEnabled;

  const FormSelectInput(
      {Key? key,
      required this.controller,
      this.label = '',
      this.hint = '',
      this.width = 200,
      this.height = 35,
      this.inputType = TextInputType.text,
      this.maxLines = 1,
      this.isEnabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Material(
          elevation: 0,
          color: Colors.black12,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: Container(
            height: height,
            width: width,
            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 15),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: TextField(
                controller: controller,
                keyboardType: inputType,
                maxLines: maxLines,
                enabled: isEnabled,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: const Padding(
                      padding: EdgeInsets.only(top: 4.0),
                      child: Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                    hintText: hint,
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 11)),
                onChanged: (text) {}),
          ),
        ),
      ],
    );
  }
}

class SelectFormInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final double height;
  final double width;

  final TextInputType inputType;
  final int maxLines;

  const SelectFormInput(
      {Key? key,
      required this.controller,
      this.label = '',
      this.hint = '',
      this.inputType = TextInputType.text,
      this.maxLines = 1,
      this.height = 35,
      this.width = 200})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.only(left: 10, bottom: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.5),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: TextField(
          controller: controller,
          keyboardType: inputType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintStyle: const TextStyle(
              fontSize: 12,
            ),
            enabled: false,
            border: InputBorder.none,
            hintText: hint,
            contentPadding: EdgeInsets.zero,
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          onChanged: (text) {}),
    );
  }
}

class SelectBorderFormInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final double width;
  final TextInputType inputType;
  final int maxLines;

  const SelectBorderFormInput(
      {Key? key,
      required this.controller,
      this.label = '',
      this.hint = '',
      this.width = 120,
      this.inputType = TextInputType.text,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 4, left: 4),
      width: width,
      height: 42,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.3),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: TextField(
          controller: controller,
          keyboardType: inputType,
          maxLines: maxLines,
          textAlign: TextAlign.justify,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w200),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 6, top: 4),
            enabled: false,
            border: InputBorder.none,
            hintText: hint,
            suffixIcon: const Icon(
              Icons.arrow_drop_down_outlined,
              color: Colors.white,
            ),
          ),
          onChanged: (text) {}),
    );
  }
}

class SelectUnderlineFormInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final double width;
  final TextInputType inputType;
  final int maxLines;
  final Color iconColor;

  const SelectUnderlineFormInput(
      {Key? key,
      required this.controller,
      this.label = '',
      this.hint = '',
      this.width = 132,
      this.inputType = TextInputType.text,
      this.maxLines = 1,
      this.iconColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: TextField(
          controller: controller,
          keyboardType: inputType,
          maxLines: maxLines,
          textAlign: TextAlign.justify,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.w200),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 6, top: 0, bottom: 8),
            enabled: false,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100, width: 0.2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade100, width: 0.2),
            ),
            hintText: hint,
            suffixIcon: Icon(
              Icons.arrow_drop_down_outlined,
              color: iconColor,
            ),
            hintStyle: const TextStyle(
                color: Colors.grey, fontSize: 10, fontWeight: FontWeight.w200),
          ),
          onChanged: (text) {}),
    );
  }
}

class BorderFormInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final double width;
  final TextInputType inputType;
  final int maxLines;

  const BorderFormInput(
      {Key? key,
      required this.controller,
      this.label = '',
      this.hint = '',
      this.width = 120,
      this.inputType = TextInputType.text,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 42,
      padding: const EdgeInsets.only(top: 4, left: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.3),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: TextField(
          controller: controller,
          keyboardType: inputType,
          maxLines: maxLines,
          textAlign: TextAlign.justify,
          style: const TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.w200),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 6, top: 0, bottom: 16),
            enabled: false,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w200),
          ),
          onChanged: (text) {}),
    );
  }
}

class UnderlineFormInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final double width;
  final TextInputType inputType;
  final int maxLines;

  const UnderlineFormInput(
      {Key? key,
      required this.controller,
      this.label = '',
      this.hint = '',
      this.width = 0,
      this.inputType = TextInputType.text,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width == 0 ? double.infinity : width,
      child: TextField(
          controller: controller,
          keyboardType: inputType,
          maxLines: maxLines,
          textAlign: TextAlign.justify,
          style: const TextStyle(
              color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 6, top: 0, bottom: 4),
            enabled: true,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500, width: 0.8),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.green, width: 0.8),
            ),
            hintText: hint,
            labelText: hint,
            hintStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
          onChanged: (text) {}),
    );
  }
}

@immutable
class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType inputType;
  final int maxLines;
  final double width;
  final double height;
  final bool isEnabled;
  final Function(String)? validate;

  const PasswordInput({
    Key? key,
    required this.controller,
    this.label = '',
    this.hint = '',
    this.width = 200,
    this.height = 42,
    this.inputType = TextInputType.text,
    this.maxLines = 1,
    this.isEnabled = true,
    this.validate,
  }) : super(key: key);

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        child: Text(
          widget.label,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
      ),
      const SizedBox(
        height: 8,
      ),
      Material(
        elevation: 0,
        color: Colors.black12,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Container(
          height: widget.height,
          width: widget.width,
          padding: const EdgeInsets.only(right: 0, left: 0, bottom: 3),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.green, width: 0.5),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: Center(
            child: TextField(
              controller: widget.controller,
              keyboardType: widget.inputType,
              maxLines: widget.maxLines,
              enabled: widget.isEnabled,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: Colors.black,
                  size: 22,
                ),
                suffixIcon: InkWell(
                  onTap: _toggleIcon,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18.0,
                      color: Colors.black26,
                    ),
                  ),
                ),
              ),
              onChanged: (text) {
                // if (widget.validate != null) {
                //   widget.error!.value = widget.validate!(text);
                // }
              },
            ),
          ),
        ),
      ),
      // widget.error == null
      //     ? const SizedBox.shrink()
      //     : Obx(() => widget.error?.value == ''
      //     ? const SizedBox.shrink()
      //     : Text(
      //   widget.error?.value ?? '',
      //   style: const TextStyle(color: Pallet.red),
      // )),
    ]);
  }

  void _toggleIcon() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
