import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PoamOptions extends StatefulWidget {
  const PoamOptions({Key? key}) : super(key: key);

  @override
  State<PoamOptions> createState() => _PoamOptionsState();
}

class _PoamOptionsState extends State<PoamOptions> {

  late double padding;

  @override
  Widget build(BuildContext context) {

    ///TODO: Change Language in options

    padding = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(top: padding),
      child: ListView(
        children: [

          Center(
            child: Text(
              AppLocalizations.of(context)!.settings,
              style: GoogleFonts.novaMono(
                fontSize: 18
              ),
            ),
          )

        ],
      )
    );
  }
}

