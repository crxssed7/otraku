import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:otraku/common/utils/consts.dart';

class CheckBoxField extends StatefulWidget {
  const CheckBoxField({
    required this.title,
    required this.initial,
    required this.onChanged,
  });

  final String title;
  final bool initial;
  final void Function(bool) onChanged;

  @override
  CheckBoxFieldState createState() => CheckBoxFieldState();
}

class CheckBoxFieldState extends State<CheckBoxField> {
  late bool _on;

  @override
  void initState() {
    super.initState();
    _on = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Consts.tapTargetSize,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Feedback.forTap(context);
          setState(() => _on = !_on);
          widget.onChanged(_on);
        },
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: Consts.iconBig,
              height: Consts.iconBig,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _on ? Theme.of(context).colorScheme.primary : null,
                border: Border.all(
                  color: _on
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.surfaceVariant,
                  width: 2,
                ),
              ),
              child: _on
                  ? Icon(
                      Ionicons.checkmark_outline,
                      color: Theme.of(context).colorScheme.background,
                      size: Consts.iconSmall,
                    )
                  : null,
            ),
            Expanded(
              child: Text(
                widget.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckBoxTriField extends StatefulWidget {
  const CheckBoxTriField({
    required this.title,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final String title;
  final bool? value;
  final void Function(bool?) onChanged;

  @override
  CheckBoxTriFieldState createState() => CheckBoxTriFieldState();
}

class CheckBoxTriFieldState extends State<CheckBoxTriField> {
  late bool? _value = widget.value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Consts.tapTargetSize,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Feedback.forTap(context);
          setState(
            () => _value == null
                ? _value = true
                : _value!
                    ? _value = false
                    : _value = null,
          );
          widget.onChanged(_value);
        },
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: Consts.iconBig,
              height: Consts.iconBig,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _value == null
                    ? null
                    : _value == true
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                border: Border.all(
                  color: _value != null
                      ? Colors.transparent
                      : Theme.of(context).colorScheme.surfaceVariant,
                  width: 2,
                ),
              ),
              child: _value != null
                  ? Icon(
                      _value! ? Icons.add_rounded : Icons.remove_rounded,
                      color: Theme.of(context).colorScheme.background,
                      size: Consts.iconSmall,
                    )
                  : null,
            ),
            Expanded(
              child: Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
