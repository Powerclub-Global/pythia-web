import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.text,
    required this.isUser,
  }) : super(key: key);
  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // asymmetric padding
      padding: EdgeInsets.fromLTRB(
        isUser ? 64.0 : 16.0,
        4,
        isUser ? 16.0 : 64.0,
        4,
      ),
      child: Align(
        // align the child within the container
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: DecoratedBox(
          // chat bubble decoration
          decoration: BoxDecoration(
            color: isUser ? null : Colors.grey[300],
            gradient: isUser
                ? LinearGradient(colors: [
                    Color.fromARGB(255, 19, 187, 173),
                    Color.fromARGB(255, 44, 209, 196)
                  ])
                : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: isUser ? Colors.white : Colors.black87),
            ),
          ),
        ),
      ),
    );
  }
}
