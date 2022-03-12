import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';

class PoamTextField extends StatefulWidget {

  final String? label;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const PoamTextField({Key? key, this.label, this.keyboardType, this.maxLines, this.maxLength, this.validator, this.controller }) : super(key: key);

  @override
  _PoamTextFieldState createState() => _PoamTextFieldState();
}

class _PoamTextFieldState extends State<PoamTextField> {

  late Color primaryColor;
  bool _isListening = false;
  late stt.SpeechToText _speech;
  String s = "";

  @override
  Widget build(BuildContext context) {
    primaryColor = Theme
        .of(context)
        .primaryColor;

    return Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [

            TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              maxLines: widget.maxLines,
              maxLength: widget.maxLength,
              style: GoogleFonts.kreon(),
              validator: widget.validator,
              decoration: InputDecoration(
                labelText: widget.label,
                contentPadding: EdgeInsets.only(
                    top: 10, bottom: 10, right: 15, left: 15),
                border: InputBorder.none,
              ),
            ),

            ///TODO: Recognize voice to write text: Auf YT => https://www.youtube.com/watch?v=wDWoD1AaLu8
            ///Microphone Button
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                onPressed: /*_listen*/ () {

                },
                icon: Icon(
                  Icons.mic,
                  color: primaryColor,
                ),
              ),
            ),

          ],
        )
    );
  }

  void _listen() async {
    stt.SpeechToText speech = stt.SpeechToText();
    bool available = await speech.initialize();

    if (available) {
      speech.listen(
          onResult: (SpeechRecognitionResult recognitionResult) {
            widget.controller!.text = recognitionResult.recognizedWords;
          }
      );
    }
    else {
      print("The user has denied the use of speech recognition.");
    }
    // some time later...
    speech.stop();
  }
}