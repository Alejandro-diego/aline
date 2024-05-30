import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NeuButton extends StatefulWidget {
  NeuButton(
      {super.key,
      this.onTap,
      this.onLongPress,
      this.isEnable = false,
      this.eventStatus = false,
      this.onChanged,
      required this.isDimmerOn,
      required this.dimmerValue,
      required this.isButtonPressed,
      required this.title,
      required this.cupertinoIcon});

  final String title;
  final dynamic onLongPress;
  final dynamic onChanged;
  bool isEnable;
  bool eventStatus;
  final dynamic onTap;
  final IconData cupertinoIcon;
  bool isButtonPressed;
  double dimmerValue;
  bool isDimmerOn;

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  IconData volOff = const IconData(0xf785,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage);

  IconData volOn = const IconData(0xf785,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onLongPress: widget.onLongPress,
      //onTap: isEnable ? onTap : () {},
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 70.0,
          width: size.width * .80,
          decoration: BoxDecoration(
            border: Border.all(
                color: !widget.isButtonPressed
                    ? const Color.fromARGB(255, 49, 45, 45)
                    : Colors.grey.shade900),
            color: Colors.black.withOpacity(.5),
            borderRadius: BorderRadius.circular(12),
            boxShadow: !widget.isButtonPressed
                ? []
                : [
                    BoxShadow(
                      color: Colors.grey.shade800,
                      offset: const Offset(6, 6),
                      blurRadius: 15.0,
                      spreadRadius: 1.0,
                    ),
                    const BoxShadow(
                      color: Colors.black,
                      offset: Offset(-6, -6),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 6,
                left: size.width * .6,
                child: IconButton(
                  onPressed: widget.isEnable ? widget.onTap : () {},
                  icon: Icon(
                    !widget.isButtonPressed
                        ? widget.cupertinoIcon
                        : widget.cupertinoIcon,
                    size: !widget.isButtonPressed ? 35 : 40,
                    color: !widget.isButtonPressed
                        ? Colors.grey[800]
                        : const Color.fromARGB(255, 85, 255, 85),
                  ),
                ),
              ),
              Positioned(
                left: 10.0,
                top: 5,
                child: Text(
                  widget.title,
                  style: TextStyle(
                      fontSize: !widget.isButtonPressed ? 12 : 15,
                      color: widget.isEnable
                          ? (!widget.isButtonPressed
                              ? Colors.green
                              : Colors.white)
                          : Colors.black),
                ),
              ),
              Positioned(
                right: 30.0,
                bottom: 10,
                child: Icon(
                  Icons.access_time,
                  size: 17,
                  color: widget.eventStatus ? Colors.red : Colors.grey.shade900,
                ),
              ),
              Positioned(
                  left: 20.0,
                  bottom: -1,
                  child: widget.isDimmerOn
                      ? Slider(
                          activeColor: !widget.isButtonPressed
                              ? Colors.grey[800]
                              : const Color.fromARGB(221, 243, 234, 234),
                          value: widget.dimmerValue,
                          min: 0.0,
                          max: 100.0,
                          divisions: 10,
                          onChanged: widget.onChanged)
                      : const Text('')),
              Positioned(
                  right: 15.0,
                  top: 10,
                  child: widget.isDimmerOn
                      ? Text(
                          '${widget.dimmerValue.toInt()} %',
                          style: TextStyle(
                              color: widget.isButtonPressed
                                  ? Colors.white
                                  : Colors.grey[800]),
                        )
                      : const Text('')),
            ],
          ),
        ),
      ),
    );
  }
}
