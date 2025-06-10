import 'package:brainrot_flutter/common/color.dart';
import 'package:flutter/material.dart';

enum MessagePopupType {
  information, // 정보용 팝업
  warning, // 경고용 팝업
  error, // 에러 알림 팝업
  question // 사용자 선택이 필요한 질문 팝업
}

enum MessageBottomButtonType {
  yes, // 확인 버튼만 있는 팝업
  yesno // 확인 + 취소 버튼 있는 팝업
}

class CommonDialog extends StatelessWidget {
  final String message;
  final MessagePopupType messagePopupType;
  final MessageBottomButtonType messageBottomButtonType;

  const CommonDialog({
    required this.message,
    required this.messagePopupType,
    this.messageBottomButtonType = MessageBottomButtonType.yes,
    super.key,
  });

  // 배경색
  Color get backgroundColor {
    switch (messagePopupType) {
      case MessagePopupType.information:
        return ColorStyles.blue;
      case MessagePopupType.warning:
        return ColorStyles.yellow;
      case MessagePopupType.error:
        return ColorStyles.red;
      case MessagePopupType.question:
        return ColorStyles.green;
    }
  }

  // 아이콘
  IconData get icon {
    switch (messagePopupType) {
      case MessagePopupType.information:
        return Icons.info_outline;
      case MessagePopupType.warning:
        return Icons.warning_amber_outlined;
      case MessagePopupType.error:
        return Icons.error_outline;
      case MessagePopupType.question:
        return Icons.help_outline;
    }
  }

  // 아이콘 색상
  Color get iconColor {
    switch (messagePopupType) {
      case MessagePopupType.information:
        return ColorStyles.blue;
      case MessagePopupType.warning:
        return ColorStyles.orange;
      case MessagePopupType.error:
        return ColorStyles.red;
      case MessagePopupType.question:
        return ColorStyles.green;
    }
  }

  Color get TextColor {
    switch (messagePopupType) {
      case MessagePopupType.information:
        return ColorStyles.darkgray;
      case MessagePopupType.warning:
        return ColorStyles.darkgray;
      case MessagePopupType.error:
        return ColorStyles.red;
      case MessagePopupType.question:
        return ColorStyles.darkgray;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: iconColor),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(6),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 150),
                child: Text(
                  message,
                  style: TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.none,
                      color: TextColor),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext context) {
    final isYesNo = messageBottomButtonType == MessageBottomButtonType.yesno;
    final isYesOnly = messageBottomButtonType == MessageBottomButtonType.yes;

    final Color confirmColor = iconColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isYesNo)
          buildActionButton(
            context: context,
            text: '취소',
            color: ColorStyles.gray,
            result: false,
          ),
        if (isYesNo || isYesOnly) const SizedBox(width: 12),
        if (isYesNo || isYesOnly)
          buildActionButton(
            context: context,
            text: '확인',
            color: confirmColor,
            result: true,
          ),
      ],
    );
  }

  Widget buildActionButton({
    required BuildContext context,
    required String text,
    required Color color,
    required bool result,
  }) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pop(result),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: ColorStyles.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text),
    );
  }
}

Future<void> openDialog(BuildContext context,
    {required String message,
    required VoidCallback onConfirmed,
    VoidCallback? onCancelled,
    MessageBottomButtonType? buttonType,
    MessagePopupType? type}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => CommonDialog(
      message: message,
      messagePopupType: type ?? MessagePopupType.information,
      messageBottomButtonType: buttonType ?? MessageBottomButtonType.yes,
    ),
  );

  if (result == true) {
    onConfirmed();
  } else {
    onCancelled?.call();
  }
}
