import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../global/ui/ui_barrel.dart';
import '../../../../src_barrel.dart';

class CDropDown extends StatefulWidget {
  final List<String> options;
  final TextEditingController cont;
  final bool isBold;
  final VoidCallback onChanged;
  const CDropDown(this.options, this.cont, this.onChanged,
      {this.isBold = false, super.key});

  @override
  State<CDropDown> createState() => _CDropDownState();
}

class _CDropDownState extends State<CDropDown> {
  String curOption = "";

  @override
  void initState() {
    curOption = widget.options[0];
    widget.cont.text = curOption;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        value: curOption,
        isExpanded: false,
        elevation: 0,
        hint: widget.isBold
            ? AppText.bold(curOption, fontSize: 24)
            : AppText.thin(curOption),
        underline: SizedBox(),
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.white,
        ),
        dropdownColor: AppColors.primaryColor,
        items: widget.options
            .map((e) => DropdownMenuItem<String>(
                value: e,
                child: widget.isBold
                    ? AppText.bold(e, fontSize: 24)
                    : AppText.thin(e)))
            .toList(),
        onChanged: (value) async {
          setState(() {
            curOption = value!;
            widget.cont.text = curOption;
            widget.onChanged;
          });
        });
  }
}

class RowCell extends StatelessWidget {
  const RowCell(this.k, this.v, {super.key});
  final String k, v;

  @override
  Widget build(BuildContext context) {
    return Ui.padding(
      padding: 8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: (Get.width - 48) / 2, child: AppText.bold("$k :  ")),
          AppText.thin(v)
        ],
      ),
    );
  }
}
