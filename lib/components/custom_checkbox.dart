import 'package:default_themes/core/themes/colors.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatefulWidget {
  static const double width = 18.0;

  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final MaterialStateProperty<Color?>? fillColor;
  final Color? checkColor;
  final bool tristate;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final Color? focusColor;
  final Color? hoverColor;
  final MaterialStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final FocusNode? focusNode;
  final bool autofocus;
  final OutlinedBorder? shape;
  final BorderSide? side;

  const CustomCheckbox({
    Key? key,
    required this.value,
    this.tristate = false,
    required this.onChanged,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.shape,
    this.side,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> with TickerProviderStateMixin, ToggleableStateMixin {
  final _CheckboxPainter _painter = _CheckboxPainter();
  bool? _previousValue;

  @override
  void initState() {
    super.initState();
    _previousValue = widget.value;
  }

  @override
  void didUpdateWidget(CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = oldWidget.value;
      animateToValue();
    }
  }

  @override
  void dispose() {
    _painter.dispose();
    super.dispose();
  }

  @override
  ValueChanged<bool?>? get onChanged => widget.onChanged;

  @override
  bool get tristate => widget.tristate;

  @override
  bool? get value => widget.value;

  MaterialStateProperty<Color?> get _widgetFillColor {
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return null;
      }
      if (states.contains(MaterialState.selected)) {
        return widget.activeColor;
      }
      return null;
    });
  }

  MaterialStateProperty<Color> get _defaultFillColor {
    final ThemeData themeData = Theme.of(context);
    return MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return themeData.disabledColor;
      }
      if (states.contains(MaterialState.selected)) {
        return themeData.toggleableActiveColor;
      }
      return themeData.unselectedWidgetColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    final ThemeData themeData = Theme.of(context);
    final MaterialTapTargetSize effectiveMaterialTapTargetSize = widget.materialTapTargetSize ??
        themeData.checkboxTheme.materialTapTargetSize ??
        themeData.materialTapTargetSize;
    final VisualDensity effectiveVisualDensity =
        widget.visualDensity ?? themeData.checkboxTheme.visualDensity ?? themeData.visualDensity;
    Size size;
    switch (effectiveMaterialTapTargetSize) {
      case MaterialTapTargetSize.padded:
        size = const Size(kMinInteractiveDimension, kMinInteractiveDimension);
        break;
      case MaterialTapTargetSize.shrinkWrap:
        size = const Size(kMinInteractiveDimension - 8.0, kMinInteractiveDimension - 8.0);
        break;
    }
    size += effectiveVisualDensity.baseSizeAdjustment;

    final MaterialStateProperty<MouseCursor> effectiveMouseCursor =
    MaterialStateProperty.resolveWith<MouseCursor>((Set<MaterialState> states) {
      return MaterialStateProperty.resolveAs<MouseCursor?>(widget.mouseCursor, states) ??
          themeData.checkboxTheme.mouseCursor?.resolve(states) ??
          MaterialStateMouseCursor.clickable.resolve(states);
    });

    final Set<MaterialState> activeStates = states..add(MaterialState.selected);
    final Set<MaterialState> inactiveStates = states..remove(MaterialState.selected);
    final Color effectiveActiveColor = widget.fillColor?.resolve(activeStates) ??
        _widgetFillColor.resolve(activeStates) ??
        themeData.checkboxTheme.fillColor?.resolve(activeStates) ??
        _defaultFillColor.resolve(activeStates);
    final Color effectiveInactiveColor = widget.fillColor?.resolve(inactiveStates) ??
        _widgetFillColor.resolve(inactiveStates) ??
        themeData.checkboxTheme.fillColor?.resolve(inactiveStates) ??
        _defaultFillColor.resolve(inactiveStates);

    final Set<MaterialState> focusedStates = states..add(MaterialState.focused);
    final Color effectiveFocusOverlayColor = widget.overlayColor?.resolve(focusedStates) ??
        widget.focusColor ??
        themeData.checkboxTheme.overlayColor?.resolve(focusedStates) ??
        themeData.focusColor;

    final Set<MaterialState> hoveredStates = states..add(MaterialState.hovered);
    final Color effectiveHoverOverlayColor = widget.overlayColor?.resolve(hoveredStates) ??
        widget.hoverColor ??
        themeData.checkboxTheme.overlayColor?.resolve(hoveredStates) ??
        themeData.hoverColor;

    final Set<MaterialState> activePressedStates = activeStates..add(MaterialState.pressed);
    final Color effectiveActivePressedOverlayColor = widget.overlayColor?.resolve(activePressedStates) ??
        themeData.checkboxTheme.overlayColor?.resolve(activePressedStates) ??
        effectiveActiveColor.withAlpha(kRadialReactionAlpha);

    final Set<MaterialState> inactivePressedStates = inactiveStates..add(MaterialState.pressed);
    final Color effectiveInactivePressedOverlayColor = widget.overlayColor?.resolve(inactivePressedStates) ??
        themeData.checkboxTheme.overlayColor?.resolve(inactivePressedStates) ??
        effectiveActiveColor.withAlpha(kRadialReactionAlpha);

    final Color effectiveCheckColor =
        widget.checkColor ?? themeData.checkboxTheme.checkColor?.resolve(states) ?? CustomColors.silverColor;

    return Semantics(
      checked: widget.value == true,
      child: buildToggleable(
        mouseCursor: effectiveMouseCursor,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        size: size,
        painter: _painter
          ..position = position
          ..reaction = reaction
          ..reactionFocusFade = reactionFocusFade
          ..reactionHoverFade = reactionHoverFade
          ..inactiveReactionColor = effectiveInactivePressedOverlayColor
          ..reactionColor = effectiveActivePressedOverlayColor
          ..hoverColor = effectiveHoverOverlayColor
          ..focusColor = effectiveFocusOverlayColor
          ..splashRadius =
              widget.splashRadius ?? themeData.checkboxTheme.splashRadius ?? kRadialReactionRadius
          ..downPosition = downPosition
          ..isFocused = states.contains(MaterialState.focused)
          ..isHovered = states.contains(MaterialState.hovered)
          ..activeColor = effectiveActiveColor
          ..inactiveColor = effectiveInactiveColor
          ..checkColor = effectiveCheckColor
          ..value = value
          ..previousValue = _previousValue
          ..shape = widget.shape ??
              themeData.checkboxTheme.shape ??
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(1.0)),
              )
          ..side = widget.side ?? themeData.checkboxTheme.side,
      ),
    );
  }
}

const double _kEdgeSize = CustomCheckbox.width;
const double _kStrokeWidth = 2.0;

class _CheckboxPainter extends ToggleablePainter {
  Color get checkColor => _checkColor!;
  Color? _checkColor;
  set checkColor(Color value) {
    if (_checkColor == value) {
      return;
    }
    _checkColor = value;
    notifyListeners();
  }

  bool? get value => _value;
  bool? _value;
  set value(bool? value) {
    if (_value == value) {
      return;
    }
    _value = value;
    notifyListeners();
  }

  bool? get previousValue => _previousValue;
  bool? _previousValue;
  set previousValue(bool? value) {
    if (_previousValue == value) {
      return;
    }
    _previousValue = value;
    notifyListeners();
  }

  OutlinedBorder get shape => _shape!;
  OutlinedBorder? _shape;
  set shape(OutlinedBorder value) {
    if (_shape == value) {
      return;
    }
    _shape = value;
    notifyListeners();
  }

  BorderSide? get side => _side;
  BorderSide? _side;
  set side(BorderSide? value) {
    if (_side == value) {
      return;
    }
    _side = value;
    notifyListeners();
  }

  Rect _outerRectAt(Offset origin, double t) {
    final double inset = 1.0 - (t - 0.5).abs() * 2.0;
    final double size = _kEdgeSize - inset * _kStrokeWidth;
    final Rect rect = Rect.fromLTWH(origin.dx + inset, origin.dy + inset, size, size);
    return rect;
  }

  Color _colorAt(double t) {
    return t >= 0.25 ? activeColor : Color.lerp(inactiveColor, activeColor, t * 4.0)!;
  }

  Paint _createStrokePaint() {
    return Paint()
      ..color = checkColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _kStrokeWidth;
  }

  void _drawBorder(Canvas canvas, Rect outer, double t, Paint paint) {
    assert(t >= 0.0 && t <= 0.5);
    OutlinedBorder resolvedShape = shape;
    if (side == null) {
      resolvedShape = resolvedShape.copyWith(side: BorderSide(width: 2, color: paint.color));
    }
    resolvedShape.copyWith(side: side).paint(canvas, outer);
  }

  void _drawCheck(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    final Path path = Path();
    const Offset start = Offset(_kEdgeSize * 0.15, _kEdgeSize * 0.45);
    const Offset mid = Offset(_kEdgeSize * 0.4, _kEdgeSize * 0.7);
    const Offset end = Offset(_kEdgeSize * 0.85, _kEdgeSize * 0.25);
    if (t < 0.5) {
      final double strokeT = t * 2.0;
      final Offset drawMid = Offset.lerp(start, mid, strokeT)!;
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + drawMid.dx, origin.dy + drawMid.dy);
    } else {
      final double strokeT = (t - 0.5) * 2.0;
      final Offset drawEnd = Offset.lerp(mid, end, strokeT)!;
      path.moveTo(origin.dx + start.dx, origin.dy + start.dy);
      path.lineTo(origin.dx + mid.dx, origin.dy + mid.dy);
      path.lineTo(origin.dx + drawEnd.dx, origin.dy + drawEnd.dy);
    }
    canvas.drawPath(path, paint);
  }

  void _drawCross(Canvas canvas, Offset origin, double t, Paint paint) {
    assert(t >= 0.0 && t <= 1.0);
    const Offset topLeft = Offset(_kEdgeSize * 0.2, _kEdgeSize * 0.2);
    const Offset bottomRight = Offset(_kEdgeSize * 0.8, _kEdgeSize * 0.8);
    const Offset topRight = Offset(_kEdgeSize * 0.8, _kEdgeSize * 0.2);
    const Offset bottomLeft = Offset(_kEdgeSize * 0.2, _kEdgeSize * 0.8);

    _drawObliqueLine(canvas, origin, topLeft, bottomRight, t, paint);
    _drawObliqueLine(canvas, origin, topRight, bottomLeft, t, paint);
  }

  void _drawObliqueLine(
      Canvas canvas,
      Offset origin,
      Offset startPoint,
      Offset endPoint,
      double t,
      Paint paint,
      ) {
    const Offset mid = Offset(_kEdgeSize * 0.5, _kEdgeSize * 0.5);
    final Offset drawStart = Offset.lerp(startPoint, mid, 1.0 - t)!;
    final Offset drawEnd = Offset.lerp(mid, endPoint, t)!;
    canvas.drawLine(origin + drawStart, origin + drawEnd, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintRadialReaction(canvas: canvas, origin: size.center(Offset.zero));

    final Paint strokePaint = _createStrokePaint();
    final Offset origin = size / 2.0 - const Size.square(_kEdgeSize) / 2.0 as Offset;
    final AnimationStatus status = position.status;
    final double tNormalized = status == AnimationStatus.forward || status == AnimationStatus.completed
        ? position.value
        : 1.0 - position.value;

    if (previousValue == false || value == false) {
      final double t = value == false ? 1.0 - tNormalized : tNormalized;
      final Rect outer = _outerRectAt(origin, t);
      final Path emptyCheckboxPath = shape.copyWith(side: side).getOuterPath(outer);
      final Paint paint = Paint()..color = _colorAt(previousValue == null || value == null ? 0.0 : t);

      if (t <= 0.5) {
        _drawBorder(canvas, outer, t, paint);
      } else {
        canvas.drawPath(emptyCheckboxPath, paint);

        final double tShrink = (t - 0.5) * 2.0;
        if (previousValue == null || value == null)
          _drawCross(canvas, origin, tShrink, strokePaint);
        else
          _drawCheck(canvas, origin, tShrink, strokePaint);
      }
    } else {
      final double t = value == null ? 1.0 - tNormalized : tNormalized;
      final Rect outer = _outerRectAt(origin, 1.0);
      final Paint paint = Paint()..color = _colorAt(t);
      canvas.drawPath(shape.copyWith(side: side).getOuterPath(outer), paint);

      if (tNormalized <= 0.5) {
        final double tShrink = 1.0 - tNormalized * 2.0;
        if (previousValue == true)
          _drawCheck(canvas, origin, tShrink, strokePaint);
        else
          _drawCross(canvas, origin, tShrink, strokePaint);
      } else {
        final double tExpand = (tNormalized - 0.5) * 2.0;
        if (value == true)
          _drawCheck(canvas, origin, tExpand, strokePaint);
        else
          _drawCross(canvas, origin, tExpand, strokePaint);
      }
    }
  }
}