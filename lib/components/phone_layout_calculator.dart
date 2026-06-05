import 'dart:ui';
import '../models/button_info.dart';
import 'phone_constants.dart';

class PhoneLayoutCalculator {
  static List<ButtonLayout> calculateLayouts(Size size) {
    List<ButtonLayout> layouts = [];

    final double keypadTop = size.height * 0.52;
    final double keypadBottom = size.height * 0.95;
    final double keypadHeight = keypadBottom - keypadTop;
    final double marginX = size.width * 0.07;
    final double keypadWidth = size.width - marginX * 2;
    
    final double gapX = size.width * 0.035;
    final double gapY = size.height * 0.015;

    final double navHeight = keypadHeight * 0.23;
    final double numAreaHeight = keypadHeight - navHeight - gapY;
    final double numRowHeight = (numAreaHeight - gapY * 3) / 4;
    final double colWidth = (keypadWidth - gapX * 2) / 3;

    Path createPath(Rect rect, {double tl = 0, double tr = 0, double bl = 0, double br = 0}) {
      return Path()..addRRect(RRect.fromRectAndCorners(
        rect,
        topLeft: Radius.circular(tl),
        topRight: Radius.circular(tr),
        bottomLeft: Radius.circular(bl),
        bottomRight: Radius.circular(br),
      ));
    }

    final double navTop = keypadTop;
    final double pillWidth = keypadWidth * 0.28;
    final double dpadWidth = keypadWidth - pillWidth * 2 - gapX * 2;

    final Rect leftPillRect = Rect.fromLTWH(marginX, navTop, pillWidth, navHeight);
    final Rect dpadRect = Rect.fromLTWH(marginX + pillWidth + gapX, navTop, dpadWidth, navHeight);
    final Rect rightPillRect = Rect.fromLTWH(marginX + pillWidth + gapX + dpadWidth + gapX, navTop, pillWidth, navHeight);

    final double pillRadius = pillWidth * 0.4;

    layouts.add(ButtonLayout(
      definition: PhoneConstants.buttonDefinitions.firstWhere((e) => e.id == 'leftSelection'),
      hitArea: createPath(Rect.fromLTRB(leftPillRect.left, leftPillRect.top, leftPillRect.right, leftPillRect.top + leftPillRect.height / 2), tl: pillRadius, tr: pillRadius),
      centerPoint: Offset(leftPillRect.center.dx, leftPillRect.top + leftPillRect.height / 4),
    ));
    layouts.add(ButtonLayout(
      definition: PhoneConstants.buttonDefinitions.firstWhere((e) => e.id == 'call'),
      hitArea: createPath(Rect.fromLTRB(leftPillRect.left, leftPillRect.top + leftPillRect.height / 2, leftPillRect.right, leftPillRect.bottom), bl: pillRadius, br: pillRadius),
      centerPoint: Offset(leftPillRect.center.dx, leftPillRect.bottom - leftPillRect.height / 4),
    ));

    layouts.add(ButtonLayout(
      definition: PhoneConstants.buttonDefinitions.firstWhere((e) => e.id == 'rightSelection'),
      hitArea: createPath(Rect.fromLTRB(rightPillRect.left, rightPillRect.top, rightPillRect.right, rightPillRect.top + rightPillRect.height / 2), tl: pillRadius, tr: pillRadius),
      centerPoint: Offset(rightPillRect.center.dx, rightPillRect.top + rightPillRect.height / 4),
    ));
    layouts.add(ButtonLayout(
      definition: PhoneConstants.buttonDefinitions.firstWhere((e) => e.id == 'endCall'),
      hitArea: createPath(Rect.fromLTRB(rightPillRect.left, rightPillRect.top + rightPillRect.height / 2, rightPillRect.right, rightPillRect.bottom), bl: pillRadius, br: pillRadius),
      centerPoint: Offset(rightPillRect.center.dx, rightPillRect.bottom - rightPillRect.height / 4),
    ));

    final Offset centerDpad = dpadRect.center;
    final double outerPadW = dpadRect.width;
    final double outerPadH = dpadRect.height;
    layouts.add(ButtonLayout(
      definition: PhoneConstants.buttonDefinitions.firstWhere((e) => e.id == 'scrollUp'),
      hitArea: createPath(Rect.fromLTRB(centerDpad.dx - outerPadW / 2, centerDpad.dy - outerPadH / 2, centerDpad.dx + outerPadW / 2, centerDpad.dy - outerPadH * 0.2)),
      centerPoint: Offset(centerDpad.dx, centerDpad.dy - outerPadH * 0.35),
    ));
    layouts.add(ButtonLayout(
      definition: PhoneConstants.buttonDefinitions.firstWhere((e) => e.id == 'scrollDown'),
      hitArea: createPath(Rect.fromLTRB(centerDpad.dx - outerPadW / 2, centerDpad.dy + outerPadH * 0.2, centerDpad.dx + outerPadW / 2, centerDpad.dy + outerPadH / 2)),
      centerPoint: Offset(centerDpad.dx, centerDpad.dy + outerPadH * 0.35),
    ));
    layouts.add(ButtonLayout(
      definition: PhoneConstants.buttonDefinitions.firstWhere((e) => e.id == 'scrollLeft'),
      hitArea: createPath(Rect.fromLTRB(centerDpad.dx - outerPadW / 2, centerDpad.dy - outerPadH * 0.2, centerDpad.dx - outerPadW * 0.2, centerDpad.dy + outerPadH * 0.2)),
      centerPoint: Offset(centerDpad.dx - outerPadW * 0.35, centerDpad.dy),
    ));
    layouts.add(ButtonLayout(
      definition: PhoneConstants.buttonDefinitions.firstWhere((e) => e.id == 'scrollRight'),
      hitArea: createPath(Rect.fromLTRB(centerDpad.dx + outerPadW * 0.2, centerDpad.dy - outerPadH * 0.2, centerDpad.dx + outerPadW / 2, centerDpad.dy + outerPadH * 0.2)),
      centerPoint: Offset(centerDpad.dx + outerPadW * 0.35, centerDpad.dy),
    ));
    layouts.add(ButtonLayout(
      definition: PhoneConstants.buttonDefinitions.firstWhere((e) => e.id == 'scrollCenter'),
      hitArea: createPath(Rect.fromLTRB(centerDpad.dx - outerPadW * 0.25, centerDpad.dy - outerPadH * 0.25, centerDpad.dx + outerPadW * 0.25, centerDpad.dy + outerPadH * 0.25), tl: 4, tr: 4, bl: 4, br: 4),
      centerPoint: centerDpad,
    ));

    final double numpadTop = navTop + navHeight + gapY;
    final double numRadius = size.width * 0.035;

    for (int row = 0; row < 4; row++) {
      for (int col = 0; col < 3; col++) {
        String id = '';
        if (row == 0) id = 'num${col + 1}';
        else if (row == 1) id = 'num${col + 4}';
        else if (row == 2) id = 'num${col + 7}';
        else {
          if (col == 0) id = 'star';
          else if (col == 1) id = 'num0';
          else id = 'hash';
        }

        final double left = marginX + col * colWidth + (col > 0 ? gapX * col : 0);
        final double top = numpadTop + row * numRowHeight + (row > 0 ? gapY * row : 0);
        final double right = left + colWidth;
        final double bottom = top + numRowHeight;

        final Rect btnRect = Rect.fromLTRB(left, top, right, bottom);
        final Path path = createPath(btnRect, tl: numRadius, tr: numRadius, bl: numRadius, br: numRadius);
        
        final def = PhoneConstants.buttonDefinitions.firstWhere((element) => element.id == id);
        layouts.add(ButtonLayout(definition: def, hitArea: path, centerPoint: btnRect.center));
      }
    }

    return layouts;
  }
}
