import '../models/button_info.dart';

class PhoneConstants {
  static const double logicalWidth = 400.0;
  static const double logicalHeight = 880.0;

  static const List<ButtonDefinition> buttonDefinitions = [
    ButtonDefinition(
      id: 'leftSelection',
      name: 'Left Selection Key',
      functionDescription: 'Opens the Go To menu or selects the on-screen left option.',
    ),
    ButtonDefinition(
      id: 'rightSelection',
      name: 'Right Selection Key',
      functionDescription: 'Navigates back, opens Contacts, or selects the on-screen right option.',
    ),
    ButtonDefinition(
      id: 'scrollUp',
      name: 'Scroll Up',
      functionDescription: 'Scrolls up in menus. Double click toggles flashlight.',
    ),
    ButtonDefinition(
      id: 'scrollDown',
      name: 'Scroll Down',
      functionDescription: 'Scrolls down in menus. Opens Contacts from home screen.',
    ),
    ButtonDefinition(
      id: 'scrollLeft',
      name: 'Scroll Left',
      functionDescription: 'Scrolls left. Opens create message from home.',
    ),
    ButtonDefinition(
      id: 'scrollRight',
      name: 'Scroll Right',
      functionDescription: 'Scrolls right. Opens calendar from home.',
    ),
    ButtonDefinition(
      id: 'scrollCenter',
      name: 'Center/OK Key',
      functionDescription: 'Selects the highlighted option or opens the main menu.',
    ),
    ButtonDefinition(
      id: 'call',
      name: 'Call Key',
      functionDescription: 'Makes a call, answers a call, or views call log.',
    ),
    ButtonDefinition(
      id: 'endCall',
      name: 'End/Power Key',
      functionDescription: 'Ends a call, returns to home screen, or turns phone on/off.',
    ),
    ButtonDefinition(
      id: 'num1',
      name: 'Number 1',
      functionDescription: 'Types 1, or calls voicemail on long press.',
    ),
    ButtonDefinition(
      id: 'num2',
      name: 'Number 2',
      functionDescription: 'Types 2, ABC.',
    ),
    ButtonDefinition(
      id: 'num3',
      name: 'Number 3',
      functionDescription: 'Types 3, DEF.',
    ),
    ButtonDefinition(
      id: 'num4',
      name: 'Number 4',
      functionDescription: 'Types 4, GHI.',
    ),
    ButtonDefinition(
      id: 'num5',
      name: 'Number 5',
      functionDescription: 'Types 5, JKL.',
    ),
    ButtonDefinition(
      id: 'num6',
      name: 'Number 6',
      functionDescription: 'Types 6, MNO.',
    ),
    ButtonDefinition(
      id: 'num7',
      name: 'Number 7',
      functionDescription: 'Types 7, PQRS.',
    ),
    ButtonDefinition(
      id: 'num8',
      name: 'Number 8',
      functionDescription: 'Types 8, TUV.',
    ),
    ButtonDefinition(
      id: 'num9',
      name: 'Number 9',
      functionDescription: 'Types 9, WXYZ.',
    ),
    ButtonDefinition(
      id: 'star',
      name: 'Star Key (*)',
      functionDescription: 'Types *, locks keypad.',
    ),
    ButtonDefinition(
      id: 'num0',
      name: 'Number 0',
      functionDescription: 'Types 0, adds space.',
    ),
    ButtonDefinition(
      id: 'hash',
      name: 'Hash Key (#)',
      functionDescription: 'Types #, changes text case, toggles silent mode.',
    ),
  ];
}
