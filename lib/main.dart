import 'package:flutter/material.dart';
import 'package:pythia/chat_bubble.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
part "main.g.dart";

@riverpod
class Messages extends _$Messages {
  @override
  List build() => [
        {'text': "Hi I am Pythia, how may I assist you today?", 'isUser': false}
      ];

  void addMessage(String txt, bool isUser) async {
    List me = [...state];
    me.add({'text': txt, 'isUser': isUser});
    print("fetching");
    String response = await sendRequestAndFetchResponse(txt);
    print("fetched");
    print(response);
    me.add({'text': response, 'isUser': false});
    state = me;
  }

  Future<String> sendRequestAndFetchResponse(String prompt) async {
    try {
      // Define the URL of the API endpoint
      String apiUrl = 'https://pythiapowerclubglobal.loophole.site/';

      // Define the request body
      Map<String, String> requestBody = {
        'prompt': prompt,
      };

      // Convert the request body to JSON format
      String requestBodyJson = jsonEncode(requestBody);

      // Set headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      // Send POST request to the API endpoint
      http.Response httpResponse = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBodyJson,
      );

      // Check if the request was successful (status code 200)
      if (httpResponse.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> responseData = jsonDecode(httpResponse.body);

        // Extract the response
        String response = responseData['response'];

        // Handle the response (e.g., display it)
        print(response);
        return response;
      } else {
        return httpResponse.body;
        // If the request was not successful, print the error message
      }
    } catch (e) {
      return e.toString();
      // Handle any exceptions
    }
  }

  // void sendMessage(String text) async {
  //   addMessage(
  //       "My apologies I forgot to deliver the information that I am still under construction, you gotta wait until I am smart enough to handle any question of yours, till then See Ya :)",
  //       false);
  // }
}

void main() {
  runApp(ProviderScope(child: ChatBot()));
}

class ChatBot extends ConsumerWidget {
  ChatBot({super.key});

  final TextEditingController _controller = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List chatMessages = ref.watch(messagesProvider);

    return MaterialApp(
      title: 'Pythia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 30,
              ),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 23,
                    backgroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCPL9yluXzefMXL1KNj8Sd-DT1BRJE_ve0r73py-_Sww&s",
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Color.fromARGB(255, 58, 196, 63),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 17,
              ),
              const Text(
                'Pythia 🍀',
                style: TextStyle(color: Colors.white, fontSize: 23),
              ),
            ],
          ),
          elevation: 10,
          shadowColor: Colors.grey,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          backgroundColor: Color.fromARGB(255, 97, 230, 212),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  controller: listScrollController,
                  itemCount: chatMessages.length,
                  itemBuilder: (context, index) {
                    print(chatMessages);
                    print("I am initial");
                    return ChatBubble(
                      text: chatMessages[index]['text'],
                      isUser: chatMessages[index]['isUser'],
                    );
                  }),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.black),
                    textInputAction: TextInputAction.go,
                    onSubmitted: (value) async {
                      ref
                          .read(messagesProvider.notifier)
                          .addMessage(_controller.text, true);

                      listScrollController.jumpTo(
                          listScrollController.position.maxScrollExtent);

                      // ref
                      //     .read(messagesProvider.notifier)
                      // .sendMessage(_controller.text);
                      _controller.clear();
                    },
                  )),
                  IconButton(
                      onPressed: () {
                        ref.read(messagesProvider.notifier).state = [];
                      },
                      tooltip: 'Delete Chat History',
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                  IconButton(
                      onPressed: () {
                        ref
                            .read(messagesProvider.notifier)
                            .addMessage(_controller.text, true);

                        // ref
                        //     .read(messagesProvider.notifier)
                        //     .sendMessage(_controller.text);
                        _controller.clear();
                      },
                      icon: const Icon(Icons.send,
                          color: Color.fromARGB(219, 34, 222, 197)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
