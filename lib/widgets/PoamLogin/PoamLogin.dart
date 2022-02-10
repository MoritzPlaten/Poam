import 'package:flutter/material.dart';

class PoamLogin extends StatefulWidget {

  final Function(String)? onEmailChanged;
  final Function(String)? onPasswordChanged;
  final Function? onPressed;
  final String? Title;
  final String? Warn;

  const PoamLogin({Key? key, this.Title, this.onEmailChanged, this.onPasswordChanged, this.onPressed, this.Warn }) : super(key: key);

  @override
  _PoamLoginState createState() => _PoamLoginState();
}

class _PoamLoginState extends State<PoamLogin> {

  @override
  Widget build(BuildContext context) {

    return Center(
      child: Container(

        padding: const EdgeInsets.all(30),
        margin: const EdgeInsets.all(30),
        height: 400,
        child: Column(
          children: [

            ///Display the title
            Text(
              widget.Title!,
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            TextField(
              obscureText: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              onChanged: widget.onEmailChanged,
            ),

            const SizedBox(
              height: 15,
            ),

            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              onChanged: widget.onPasswordChanged,
            ),

            Text(widget.Warn!),

            const SizedBox(
              height: 15,
            ),

            ElevatedButton(
                onPressed: () => widget.onPressed,
                child: const Text("Submit"),
            )

          ],
        ),

      ),
    );
  }
}
