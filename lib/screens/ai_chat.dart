import 'package:flutter/material.dart';
import 'package:kids_ev_controller/models/ai_chat_model.dart';
import 'package:kids_ev_controller/providers/ai_chat_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_ev_controller/widgets/chat_item.dart';
import 'package:kids_ev_controller/widgets/text_and_voice_field.dart';

class AIChatScreen extends ConsumerWidget {
  const AIChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiChatState = ref.watch(aiChatProvider);

    return Stack(children: [
      Positioned.fill(
        child: Container(
          // color: Color.fromRGBO(103, 155, 117, 1.0),
          color: Color.fromRGBO(255, 255, 255, 1.0),
        ),
      ),
      Column(
        children: [
          Expanded(
            child: aiChatState.when(
              data: (state) {
                final messages = state.messageList;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) => ChatItem(
                      text: messages[index].content,
                      role: messages[index].role),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
          const Image(
            image: AssetImage('assets/denmarukun3.jpg'),
            width: 100,
            height: 100,
            fit: BoxFit.contain,
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: TextAndVoiceField(),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    ]);
  }
}
//                   if (userMessage.isNotEmpty) {
//                     await ref.read(aiChatProvider.notifier).fetchChatCompletion(
//                         [...aiChatState.value!, Message(content: userMessage)]);
//                     _controller.clear(); // 入力フィールドをクリア
//                   }
//                 },
//               ),
//             ],
//           )
