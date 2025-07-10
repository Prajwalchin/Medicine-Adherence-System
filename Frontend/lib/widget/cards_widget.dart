import 'package:flutter/material.dart';

import '../reusable/constant.dart';

class CardWidget extends StatelessWidget {
  const CardWidget(
      {super.key,
      this.width,
      this.height,
      this.onTap,
      this.selected = false,
      this.padding,
      this.margin,
      this.child});
  final void Function()? onTap;
  final double? width;
  final bool selected;
  final EdgeInsets? margin;
  final double? height;
  final Widget? child;
  final EdgeInsets? padding;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin??EdgeInsets.all(1.1),
        height: height,
        width: width ,
        padding: padding ?? EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
            border: selected ? Border.all(color: Colors.black, width: 1) : null,
            borderRadius: BorderRadius.all(Radius.circular(4)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: shadowColor,
                offset: Offset(0, 1),
              ),
            ]),
        child: child,
      ),
    );
  }
}
