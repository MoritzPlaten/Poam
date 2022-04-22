
import 'dart:ui';

class ColorService {

  Color createColor(Color color) {

    ///Set the Color of the Second Color
    Color newColor;

    ///If red is dominant
    if (color.red > color.blue && color.red > color.green) {

      newColor = color.withBlue(200).withGreen(100);
    }
    ///If blue is dominant
    else if (color.blue > color.red && color.blue > color.green) {

      newColor = color.withGreen(200).withRed(100);
    }
    ///If green is dominant
    else if (color.green > color.red && color.green > color.blue) {

      newColor = color.withRed(200).withBlue(100);
    } else {

      newColor = color.withRed(100).withBlue(100).withGreen(100);
    }
    
    return newColor;
  }

}