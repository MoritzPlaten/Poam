import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

            ///TextField
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

            ///Microphone Button
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: _listen,
                  icon: Icon(_isListening == false ? Icons.mic : Icons.mic_none_outlined, color: primaryColor,),
              )
            ),

          ],
        )
    );
  }

  void _listen() async {

    ///change listen state
    _isListening = !_isListening;
    stt.SpeechToText speech = stt.SpeechToText();

    ///is Listen
    if (_isListening == true) {
      bool available = await speech.initialize();
      ///if speech available
      if (available) {
        await speech.listen(
            onResult: (SpeechRecognitionResult recognitionResult) {
              setState(() {
                ///print Result
                widget.controller!.text = recognitionResult.recognizedWords;
              });
            }
        );
      }
      else {
        print("The user has denied the use of speech recognition.");
      }
      ///Stop listen
    } else if (_isListening == false) {
      await speech.stop();
    }
  }
}
