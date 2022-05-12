import 'package:flutter/material.dart';

import 'package:default_themes/core/themes/colors.dart';
import 'package:default_themes/core/themes/build_context_theme.extension.dart';

class DropdownButtonField<T> extends StatefulWidget {
  final T? value;
  final ValueChanged<T?>? onChanged;
  final List<DropdownMenuItem<T>> Function(T? selectedItem) itemsBuilder;
  final FocusNode? focusNode;
  final InputDecoration? decoration;
  final DropdownButtonBuilder? selectedItemBuilder;
  final Widget? icon;

  const DropdownButtonField({
    Key? key,
    required this.value,
    required this.onChanged,
    required this.itemsBuilder,
    this.focusNode,
    this.decoration,
    this.selectedItemBuilder,
    this.icon,
  }) : super(key: key);

  @override
  _DropdownButtonFieldState<T> createState() => _DropdownButtonFieldState<T>();
}

class _DropdownButtonFieldState<T> extends State<DropdownButtonField<T>> {
  bool get enabled => widget.onChanged != null;
  bool _focused = false;
  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_focusNode ??= FocusNode());

  void _handleFocusHighlightChanged(bool focused) {
    if (focused != _focused) setState(() => _focused = focused);
  }

  bool _hovering = false;

  void _handleHoverChanged(bool hovering) {
    if (hovering != _hovering) setState(() => _hovering = hovering);
  }

  InputDecoration get effectiveDecoration {
    return (widget.decoration ?? const InputDecoration())
        .applyDefaults(context.theme.inputDecorationTheme)
        .copyWith(
      enabled: enabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.itemsBuilder(widget.value);
    final dropdownColor = context.theme.brightness == Brightness.dark ? CustomColors.blackColor : CustomColors.silverColor;

    return FocusableActionDetector(
      enabled: enabled,
      focusNode: _effectiveFocusNode,
      onShowFocusHighlight: _handleFocusHighlightChanged,
      onShowHoverHighlight: _handleHoverChanged,
      mouseCursor: SystemMouseCursors.click,
      child: Builder(builder: (context) {
        return InputDecorator(
          isFocused: _focused,
          isHovering: _hovering,
          isEmpty: widget.value == null,
          decoration: effectiveDecoration,
          child: DropdownButton<T>(
            onTap: _requestFocus,
            selectedItemBuilder: widget.selectedItemBuilder,
            isDense: true,
            isExpanded: true,
            onChanged: _onSelect,
            underline: const SizedBox(),
            value: widget.value,
            items: items,
            dropdownColor: dropdownColor,
            icon: widget.icon,
          ),
        );
      }),
    );
  }

  void _requestFocus() {
    if (_effectiveFocusNode.canRequestFocus) {
      FocusScope.of(context).requestFocus(_effectiveFocusNode);
    }
  }

  void _onSelect(T? value) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }
}

class DropdownButtonFormField<T> extends FormField<T> {
  DropdownButtonFormField({
    Key? key,
    T? initialValue,
    required List<DropdownMenuItem<T>> Function(T? selectedItem) itemsBuilder,
    FocusNode? focusNode,
    InputDecoration? decoration,
    FormFieldSetter<T>? onSaved,
    FormFieldValidator<T>? validator,
    AutovalidateMode? autovalidateMode,
    DropdownButtonBuilder? selectedItemBuilder,
    Widget? icon,
    bool enabled = true,
  }) : super(
    key: key,
    initialValue: initialValue,
    validator: validator,
    onSaved: onSaved,
    autovalidateMode: autovalidateMode,
    enabled: enabled,
    builder: (state) {
      final effectiveDecoration = (decoration ?? const InputDecoration())
          .applyDefaults(Theme.of(state.context).inputDecorationTheme);

      return DropdownButtonField(
        value: state.value,
        onChanged: enabled ? state.didChange : null,
        itemsBuilder: itemsBuilder,
        focusNode: focusNode,
        decoration: effectiveDecoration.copyWith(errorText: state.errorText),
        selectedItemBuilder: selectedItemBuilder,
        icon: icon,
      );
    },
  );
}

class SelectableMenuItem extends StatelessWidget {
  final String label;
  final bool isSelected;

  SelectableMenuItem({
    Key? key,
    required this.label,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label),
        ),
        const VerticalDivider(),
        Opacity(
          opacity: isSelected ? 1 : 0,
          child: Icon(Icons.check, color: context.theme.colorScheme.primary),
        ),
      ],
    );
  }
}