import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../models/button_info.dart';

class NokiaPhonePainter extends CustomPainter {
  final List<ButtonLayout> buttonLayouts;
  final double drawingProgress;

  NokiaPhonePainter({
    required this.buttonLayouts,
    this.drawingProgress = 1.0,
  });

  void drawAnimatedPath(Canvas canvas, Path path, Paint paint, double progress) {
    if (progress >= 1.0) {
      canvas.drawPath(path, paint);
      return;
    }
    final ui.PathMetrics pathMetrics = path.computeMetrics();
    for (ui.PathMetric pathMetric in pathMetrics) {
      final double extractLength = pathMetric.length * progress;
      final Path extractedPath = pathMetric.extractPath(0.0, extractLength);
      canvas.drawPath(extractedPath, paint);
    }
  }

  Paint getBtnPaint(Rect rect, double fadeProgress) {
    return Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF404040).withAlpha((255 * fadeProgress).toInt()),
          const Color(0xFF222222).withAlpha((255 * fadeProgress).toInt()),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double lineProgress = (drawingProgress / 0.8).clamp(0.0, 1.0);
    final double fadeProgress = ((drawingProgress - 0.8) / 0.2).clamp(0.0, 1.0);

    final Paint outlinePaint = Paint()
      ..color = Colors.white.withAlpha((255 * (1.0 - fadeProgress * 0.8)).toInt())
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final double w = size.width;
    final double h = size.height;

    final Path phonePath = Path();
    final double rTop = w * 0.16;
    final double rBot = w * 0.12;
    final double botInset = w * 0.04;
    
    phonePath.moveTo(rTop, 0);
    phonePath.lineTo(w - rTop, 0);
    phonePath.quadraticBezierTo(w, 0, w, rTop);
    
    phonePath.quadraticBezierTo(w + w * 0.01, h * 0.5, w - botInset, h - rBot);
    phonePath.quadraticBezierTo(w - botInset, h, w - botInset - rBot, h);
    
    phonePath.lineTo(botInset + rBot, h);
    
    phonePath.quadraticBezierTo(botInset, h, botInset, h - rBot);
    
    phonePath.quadraticBezierTo(-w * 0.01, h * 0.5, 0, rTop);
    
    phonePath.quadraticBezierTo(0, 0, rTop, 0);

    if (lineProgress > 0) {
      drawAnimatedPath(canvas, phonePath, outlinePaint, lineProgress);
    }

    if (fadeProgress > 0) {
      final Paint bodyPaint = Paint()
        ..color = const Color(0xFF2E2E2E).withAlpha((255 * fadeProgress).toInt())
        ..style = PaintingStyle.fill;
      canvas.drawPath(phonePath, bodyPaint);

      final Paint bodyBorderPaint = Paint()
        ..color = const Color(0xFF1F1F1F).withAlpha((255 * fadeProgress).toInt())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      canvas.drawPath(phonePath, bodyBorderPaint);
    }

    final Rect earpieceRect = Rect.fromCenter(
      center: Offset(w / 2, h * 0.035),
      width: w * 0.15,
      height: h * 0.005,
    );
    final Path earpiecePath = Path()..addRRect(RRect.fromRectAndRadius(earpieceRect, const Radius.circular(2)));
    if (lineProgress > 0) drawAnimatedPath(canvas, earpiecePath, outlinePaint, lineProgress);
    if (fadeProgress > 0) {
      canvas.drawPath(earpiecePath, Paint()..color = const Color(0xFF111111).withAlpha((255 * fadeProgress).toInt()));
    }

    final double bezelTop = h * 0.07;
    final double bezelLeft = w * 0.07;
    final double bezelWidth = w - bezelLeft * 2;
    final double bezelHeight = h * 0.32;
    final Rect bezelRect = Rect.fromLTWH(bezelLeft, bezelTop, bezelWidth, bezelHeight);
    final Path bezelPath = Path()..addRRect(RRect.fromRectAndRadius(bezelRect, Radius.circular(w * 0.06)));

    if (lineProgress > 0) drawAnimatedPath(canvas, bezelPath, outlinePaint, lineProgress);
    if (fadeProgress > 0) {
      final Paint bezelPaint = Paint()..color = Colors.black.withAlpha((255 * fadeProgress).toInt());
      canvas.drawPath(bezelPath, bezelPaint);
      
      final Path glarePath = Path()
        ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(bezelLeft + 2, bezelTop + 2, bezelWidth - 4, bezelHeight * 0.4), 
          Radius.circular(w * 0.05)
        ));
      canvas.drawPath(glarePath, Paint()..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [Colors.white.withOpacity(0.08), Colors.transparent],
      ).createShader(glarePath.getBounds()));
    }

    final double displayWidth = bezelWidth * 0.86;
    final double displayHeight = bezelHeight * 0.86;
    final Rect displayRect = Rect.fromCenter(
        center: bezelRect.center, 
        width: displayWidth, 
        height: displayHeight
    );
    final Path displayPath = Path()..addRect(displayRect);

    if (lineProgress > 0) drawAnimatedPath(canvas, displayPath, outlinePaint, lineProgress);

    if (fadeProgress > 0) {
      final Paint displayPaint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0F172A), 
            Color(0xFF1E3A8A),
          ],
        ).createShader(displayRect)
        ..style = PaintingStyle.fill;
      canvas.drawPath(displayPath, displayPaint);
      
      canvas.drawRect(displayRect, Paint()..color=Colors.black54..style=PaintingStyle.stroke..strokeWidth=2.0);

      final TextPainter timePainter = TextPainter(
        text: TextSpan(
          text: '03:21',
          style: TextStyle(color: Colors.white.withAlpha((255 * fadeProgress).toInt()), fontSize: w * 0.14, fontWeight: FontWeight.w300),
        ),
        textDirection: TextDirection.ltr,
      );
      timePainter.layout();
      timePainter.paint(canvas, Offset(w / 2 - timePainter.width / 2, displayRect.top + displayHeight * 0.25));

      final TextPainter datePainter = TextPainter(
        text: TextSpan(
          text: '05.06.2026',
          style: TextStyle(color: Colors.white70.withAlpha((178 * fadeProgress).toInt()), fontSize: w * 0.04),
        ),
        textDirection: TextDirection.ltr,
      );
      datePainter.layout();
      datePainter.paint(canvas, Offset(w / 2 - datePainter.width / 2, displayRect.top + displayHeight * 0.25 + timePainter.height));

      final TextPainter unlockPainter = TextPainter(
        text: TextSpan(
          text: 'Unlock',
          style: TextStyle(color: Colors.white.withAlpha((255 * fadeProgress).toInt()), fontSize: w * 0.038, fontWeight: FontWeight.w500),
        ),
        textDirection: TextDirection.ltr,
      );
      unlockPainter.layout();
      unlockPainter.paint(canvas, Offset(displayRect.left + 5, displayRect.bottom - unlockPainter.height - 5));

      final double iconTop = displayRect.top + 6;
      final double iconLeft = displayRect.left + 6;
      final Paint iconWhite = Paint()..color = Colors.white.withAlpha((255 * fadeProgress).toInt())..style = PaintingStyle.fill;
      
      canvas.drawRect(Rect.fromLTWH(iconLeft, iconTop + 6, 2, 4), iconWhite);
      canvas.drawRect(Rect.fromLTWH(iconLeft + 4, iconTop + 3, 2, 7), iconWhite);
      canvas.drawRect(Rect.fromLTWH(iconLeft + 8, iconTop, 2, 10), iconWhite);
      
      final TextPainter profilePainter = TextPainter(
        text: TextSpan(text: '1', style: TextStyle(color: Colors.white.withAlpha((255 * fadeProgress).toInt()), fontSize: w * 0.035, fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr,
      )..layout();
      profilePainter.paint(canvas, Offset(iconLeft + 15, iconTop - 2));

      final double iconRight = displayRect.right - 6;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(iconRight - 14, iconTop + 2, 12, 6), const Radius.circular(1)), Paint()..color = Colors.white.withAlpha((255 * fadeProgress).toInt())..style = PaintingStyle.stroke..strokeWidth = 1.2);
      canvas.drawRect(Rect.fromLTWH(iconRight - 13, iconTop + 3, 8, 4), iconWhite);
      canvas.drawRect(Rect.fromLTWH(iconRight - 2, iconTop + 4, 2, 2), iconWhite);
    }

    if (fadeProgress > 0) {
      final TextPainter logoPainter = TextPainter(
        text: TextSpan(
          text: 'NOKIA',
          style: TextStyle(color: const Color(0xFF888888).withAlpha((255 * fadeProgress).toInt()), fontSize: w * 0.045, fontWeight: FontWeight.w700, letterSpacing: w * 0.015),
        ),
        textDirection: TextDirection.ltr,
      );
      logoPainter.layout();
      final double nokiaY = bezelRect.bottom + (h * 0.52 - bezelRect.bottom) / 2 - logoPainter.height / 2;
      logoPainter.paint(canvas, Offset(w / 2 - logoPainter.width / 2, nokiaY));
    }

    for (final ButtonLayout layout in buttonLayouts) {
      if (['scrollUp', 'scrollDown', 'scrollLeft', 'scrollRight'].contains(layout.definition.id)) continue;
      
      if (layout.definition.id == 'scrollCenter') {
        final up = buttonLayouts.firstWhere((e) => e.definition.id == 'scrollUp');
        final down = buttonLayouts.firstWhere((e) => e.definition.id == 'scrollDown');
        final left = buttonLayouts.firstWhere((e) => e.definition.id == 'scrollLeft');
        final right = buttonLayouts.firstWhere((e) => e.definition.id == 'scrollRight');
        
        final Rect outerDpadRect = Rect.fromLTRB(
          left.hitArea.getBounds().left,
          up.hitArea.getBounds().top,
          right.hitArea.getBounds().right,
          down.hitArea.getBounds().bottom,
        );
        
        final double dpadRadius = outerDpadRect.width * 0.25;
        final Path outerPath = Path()..addRRect(RRect.fromRectAndRadius(outerDpadRect, Radius.circular(dpadRadius)));
        
        final Rect innerDpadRect = layout.hitArea.getBounds();
        final Path innerPath = Path()..addRRect(RRect.fromRectAndRadius(innerDpadRect, Radius.circular(innerDpadRect.width * 0.2)));
        
        if (lineProgress > 0) {
          drawAnimatedPath(canvas, outerPath, outlinePaint, lineProgress);
          drawAnimatedPath(canvas, innerPath, outlinePaint, lineProgress);
        }

        if (fadeProgress > 0) {
          canvas.drawPath(outerPath.shift(const Offset(0, 2)), Paint()..color = Colors.black54..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
          canvas.drawPath(outerPath, getBtnPaint(outerDpadRect, fadeProgress));
          canvas.drawPath(outerPath, Paint()..color = const Color(0xFF111111).withAlpha((255*fadeProgress).toInt())..style = PaintingStyle.stroke..strokeWidth = 1.0);
          
          canvas.drawPath(innerPath.shift(const Offset(0, 1)), Paint()..color = Colors.black87..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1));
          canvas.drawPath(innerPath, Paint()..color = const Color(0xFF1A1A1A).withAlpha((255*fadeProgress).toInt())..style = PaintingStyle.fill); 
          canvas.drawPath(innerPath, Paint()..color = const Color(0xFF000000).withAlpha((255*fadeProgress).toInt())..style = PaintingStyle.stroke..strokeWidth = 1.0);
        }
        continue;
      }

      if (['leftSelection', 'call', 'rightSelection', 'endCall'].contains(layout.definition.id)) {
        continue;
      }

      if (lineProgress > 0) drawAnimatedPath(canvas, layout.hitArea, outlinePaint, lineProgress);

      if (fadeProgress > 0) {
        final Rect bounds = layout.hitArea.getBounds();
        canvas.drawPath(layout.hitArea.shift(const Offset(0, 2)), Paint()..color = Colors.black54..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
        canvas.drawPath(layout.hitArea, getBtnPaint(bounds, fadeProgress));
        canvas.drawPath(layout.hitArea, Paint()..color = const Color(0xFF111111).withAlpha((255*fadeProgress).toInt())..style = PaintingStyle.stroke..strokeWidth = 1.0);

        String labelNum = '';
        String labelSub = '';
        bool reverseOrder = false;

        switch (layout.definition.id) {
          case 'num1': labelNum = '1'; labelSub = 'oo'; break;
          case 'num2': labelNum = '2'; labelSub = 'abc'; break;
          case 'num3': labelNum = '3'; labelSub = 'def'; reverseOrder = true; break;
          case 'num4': labelNum = '4'; labelSub = 'ghi'; break;
          case 'num5': labelNum = '5'; labelSub = 'jkl'; break;
          case 'num6': labelNum = '6'; labelSub = 'mno'; reverseOrder = true; break;
          case 'num7': labelNum = '7'; labelSub = 'pqrs'; break;
          case 'num8': labelNum = '8'; labelSub = 'tuv'; break;
          case 'num9': labelNum = '9'; labelSub = 'wxyz'; reverseOrder = true; break;
          case 'star': labelNum = '*'; labelSub = '+'; break;
          case 'num0': labelNum = '0'; labelSub = '␣'; break;
          case 'hash': labelNum = '#'; labelSub = '⇧'; reverseOrder = true; break;
        }

        if (labelNum.isNotEmpty) {
          final TextPainter tpNum = TextPainter(
            text: TextSpan(text: labelNum, style: TextStyle(color: Colors.white.withAlpha((220 * fadeProgress).toInt()), fontSize: size.width * 0.055, fontWeight: FontWeight.w400)),
            textDirection: TextDirection.ltr,
          )..layout();
          
          final TextPainter tpSub = TextPainter(
            text: TextSpan(text: labelSub, style: TextStyle(color: Colors.white54.withAlpha((150 * fadeProgress).toInt()), fontSize: size.width * 0.028)),
            textDirection: TextDirection.ltr,
          )..layout();

          double totalWidth = tpNum.width + 4 + tpSub.width;

          if (reverseOrder) {
            tpSub.paint(canvas, Offset(layout.centerPoint.dx - totalWidth / 2, layout.centerPoint.dy - tpSub.height / 2 + 2));
            tpNum.paint(canvas, Offset(layout.centerPoint.dx - totalWidth / 2 + tpSub.width + 4, layout.centerPoint.dy - tpNum.height / 2));
          } else {
            tpNum.paint(canvas, Offset(layout.centerPoint.dx - totalWidth / 2, layout.centerPoint.dy - tpNum.height / 2));
            tpSub.paint(canvas, Offset(layout.centerPoint.dx - totalWidth / 2 + tpNum.width + 4, layout.centerPoint.dy - tpSub.height / 2 + 2));
          }
        }
      }
    }

    final ButtonLayout? leftSel = buttonLayouts.where((l) => l.definition.id == 'leftSelection').firstOrNull;
    final ButtonLayout? callBtn = buttonLayouts.where((l) => l.definition.id == 'call').firstOrNull;
    if (leftSel != null && callBtn != null) {
       final Rect leftPill = leftSel.hitArea.getBounds().expandToInclude(callBtn.hitArea.getBounds());
       final Path leftPillPath = Path()..addRRect(RRect.fromRectAndRadius(leftPill, Radius.circular(leftPill.width * 0.4)));
       
       if (lineProgress > 0) drawAnimatedPath(canvas, leftPillPath, outlinePaint, lineProgress);
       
       if (fadeProgress > 0) {
         canvas.drawPath(leftPillPath.shift(const Offset(0, 2)), Paint()..color = Colors.black54..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
         canvas.drawPath(leftPillPath, getBtnPaint(leftPill, fadeProgress));
         canvas.drawPath(leftPillPath, Paint()..color = const Color(0xFF111111).withAlpha((255*fadeProgress).toInt())..style = PaintingStyle.stroke..strokeWidth = 1.0);
         
         final double midY = leftPill.center.dy;
         canvas.drawLine(Offset(leftPill.left + 8, midY), Offset(leftPill.right - 8, midY), Paint()..color = Colors.black45..strokeWidth = 2);
         canvas.drawLine(Offset(leftPill.left + 8, midY + 1), Offset(leftPill.right - 8, midY + 1), Paint()..color = Colors.white24..strokeWidth = 1);
         
         final TextPainter minusPainter = TextPainter(text: TextSpan(text: '–', style: TextStyle(color: Colors.white.withAlpha((200 * fadeProgress).toInt()), fontSize: size.width * 0.05)), textDirection: TextDirection.ltr)..layout();
         minusPainter.paint(canvas, Offset(leftSel.centerPoint.dx - minusPainter.width/2, leftSel.centerPoint.dy - minusPainter.height/2));
         
         final TextPainter callPainter = TextPainter(text: TextSpan(text: '📞', style: TextStyle(color: Colors.white70.withAlpha((180 * fadeProgress).toInt()), fontSize: size.width * 0.045)), textDirection: TextDirection.ltr)..layout();
         callPainter.paint(canvas, Offset(callBtn.centerPoint.dx - callPainter.width/2, callBtn.centerPoint.dy - callPainter.height/2));
       }
    }

    final ButtonLayout? rightSel = buttonLayouts.where((l) => l.definition.id == 'rightSelection').firstOrNull;
    final ButtonLayout? endBtn = buttonLayouts.where((l) => l.definition.id == 'endCall').firstOrNull;
    if (rightSel != null && endBtn != null) {
       final Rect rightPill = rightSel.hitArea.getBounds().expandToInclude(endBtn.hitArea.getBounds());
       final Path rightPillPath = Path()..addRRect(RRect.fromRectAndRadius(rightPill, Radius.circular(rightPill.width * 0.4)));
       
       if (lineProgress > 0) drawAnimatedPath(canvas, rightPillPath, outlinePaint, lineProgress);

       if (fadeProgress > 0) {
         canvas.drawPath(rightPillPath.shift(const Offset(0, 2)), Paint()..color = Colors.black54..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2));
         canvas.drawPath(rightPillPath, getBtnPaint(rightPill, fadeProgress));
         canvas.drawPath(rightPillPath, Paint()..color = const Color(0xFF111111).withAlpha((255*fadeProgress).toInt())..style = PaintingStyle.stroke..strokeWidth = 1.0);
         
         final double midY = rightPill.center.dy;
         canvas.drawLine(Offset(rightPill.left + 8, midY), Offset(rightPill.right - 8, midY), Paint()..color = Colors.black45..strokeWidth = 2);
         canvas.drawLine(Offset(rightPill.left + 8, midY + 1), Offset(rightPill.right - 8, midY + 1), Paint()..color = Colors.white24..strokeWidth = 1);
         
         final TextPainter minusPainter = TextPainter(text: TextSpan(text: '–', style: TextStyle(color: Colors.white.withAlpha((200 * fadeProgress).toInt()), fontSize: size.width * 0.05)), textDirection: TextDirection.ltr)..layout();
         minusPainter.paint(canvas, Offset(rightSel.centerPoint.dx - minusPainter.width/2, rightSel.centerPoint.dy - minusPainter.height/2));
         
         final TextPainter endPainter = TextPainter(
           text: TextSpan(
             text: String.fromCharCode(Icons.phone.codePoint),
             style: TextStyle(
               color: Colors.redAccent.withAlpha((200 * fadeProgress).toInt()),
               fontSize: size.width * 0.045,
               fontFamily: Icons.phone.fontFamily,
               package: Icons.phone.fontPackage,
             ),
           ),
           textDirection: TextDirection.ltr,
         )..layout();
         endPainter.paint(canvas, Offset(endBtn.centerPoint.dx - endPainter.width / 2, endBtn.centerPoint.dy - endPainter.height / 2));
       }
    }
  }

  @override
  bool shouldRepaint(covariant NokiaPhonePainter oldDelegate) {
    return oldDelegate.drawingProgress != drawingProgress || oldDelegate.buttonLayouts != buttonLayouts;
  }
}
