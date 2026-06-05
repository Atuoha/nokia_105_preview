import 'package:flutter/material.dart';
import '../models/button_info.dart';
import '../components/phone_layout_calculator.dart';
import '../painters/nokia_phone_painter.dart';
import '../painters/connection_line_painter.dart';
import 'button_detail_view.dart';

class NokiaPhoneWidget extends StatefulWidget {
  const NokiaPhoneWidget({super.key});

  @override
  State<NokiaPhoneWidget> createState() => NokiaPhoneWidgetState();
}

class NokiaPhoneWidgetState extends State<NokiaPhoneWidget> with TickerProviderStateMixin {
  ButtonLayout? selectedButton;
  ButtonLayout? previousButton;
  late AnimationController animationController;
  late Animation<double> animation;
  late AnimationController drawingController;
  late Animation<double> drawingAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOutBack);
    
    drawingController = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    drawingAnimation = CurvedAnimation(parent: drawingController, curve: Curves.easeInOut);
    drawingController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    drawingController.dispose();
    super.dispose();
  }

  void handleOutsideTap() {
    if (selectedButton != null) {
      setState(() {
        previousButton = selectedButton;
        selectedButton = null;
      });
      animationController.reverse();
    }
  }

  void handleFresh() {
    handleOutsideTap();
    drawingController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth;
        double maxHeight = constraints.maxHeight;

        double phoneWidth = maxWidth * 0.85;
        if (phoneWidth > 450) phoneWidth = 450;

        double phoneHeight = phoneWidth * 2.2;
        
        if (phoneHeight > maxHeight * 0.95) {
          phoneHeight = maxHeight * 0.95;
          phoneWidth = phoneHeight / 2.2;
        }

        final Size phoneSize = Size(phoneWidth, phoneHeight);
        final List<ButtonLayout> layouts = PhoneLayoutCalculator.calculateLayouts(phoneSize);

        return GestureDetector(
          onTap: handleOutsideTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: maxWidth,
            height: maxHeight,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF2A2D34), Color(0xFF111214)],
                radius: 1.0,
              ),
            ),
            child: AnimatedBuilder(
              animation: Listenable.merge([animation, drawingAnimation]),
              builder: (context, child) {
                final ButtonLayout? activeLayout = selectedButton ?? previousButton;
                
                final fractionalCenter = activeLayout == null
                    ? const FractionalOffset(0.5, 0.5)
                    : FractionalOffset(
                        activeLayout.centerPoint.dx / phoneWidth,
                        activeLayout.centerPoint.dy / phoneHeight,
                      );
                
                final double scale = 1.0 + (0.35 * animation.value);
                
                final double translateX = activeLayout == null ? 0.0 : (maxWidth * 0.15) * animation.value;
                final double translateY = activeLayout == null ? 0.0 : -(maxHeight * 0.10) * animation.value;

                final double phoneTopLeftX = (maxWidth - phoneWidth) / 2;
                final double phoneTopLeftY = (maxHeight - phoneHeight) / 2;

                Offset btnScreenPos = Offset.zero;
                Offset popupPos = Offset.zero;
                
                if (activeLayout != null) {
                  btnScreenPos = Offset(
                    phoneTopLeftX + activeLayout.centerPoint.dx + translateX,
                    phoneTopLeftY + activeLayout.centerPoint.dy + translateY,
                  );
                  
                  popupPos = Offset(
                    (maxWidth * 0.05).clamp(10.0, maxWidth / 2),
                    btnScreenPos.dy + 80,
                  );
                  
                  if (popupPos.dy + 150 > maxHeight) {
                     popupPos = Offset(popupPos.dx, maxHeight - 180);
                  }
                }

                return Stack(
                  children: [
                    Positioned.fill(
                      child: Transform.translate(
                        offset: Offset(translateX, translateY),
                        child: Transform(
                          transform: Matrix4.diagonal3Values(scale, scale, 1.0),
                          alignment: fractionalCenter,
                          child: Center(
                            child: GestureDetector(
                              onTapUp: (details) {
                                bool found = false;
                                for (final layout in layouts) {
                                  if (layout.hitArea.contains(details.localPosition)) {
                                    if (selectedButton == layout) return;
                                    setState(() {
                                      previousButton = selectedButton;
                                      selectedButton = layout;
                                    });
                                    animationController.forward(from: 0.0);
                                    found = true;
                                    break;
                                  }
                                }
                                if (!found) {
                                  handleOutsideTap();
                                }
                              },
                              child: CustomPaint(
                                size: phoneSize,
                                painter: NokiaPhonePainter(
                                  buttonLayouts: layouts,
                                  drawingProgress: drawingAnimation.value,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (activeLayout != null)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: ConnectionLinePainter(
                              startPoint: btnScreenPos,
                              endPoint: Offset(popupPos.dx, popupPos.dy + 60),
                              progress: animation.value,
                            ),
                          ),
                        ),
                      ),

                    if (activeLayout != null)
                      Positioned(
                        left: popupPos.dx,
                        top: popupPos.dy,
                        child: Opacity(
                          opacity: animation.value.clamp(0.0, 1.0),
                          child: Transform.translate(
                            offset: Offset(20 * (1 - animation.value), 0),
                            child: ButtonDetailView(buttonDefinition: activeLayout.definition),
                          ),
                        ),
                      ),
                      
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: FloatingActionButton(
                        onPressed: handleFresh,
                        backgroundColor:const Color(0xff2E2E2E),
                        foregroundColor: Colors.white,
                        child: const Icon(Icons.refresh),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
