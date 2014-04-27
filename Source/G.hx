package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.media.Sound;
import flash.text.Font;
import states.State;

// Global variables
class G
{
    static public var game: Main;

    static public var state: State;

    // delta time
    static public var dt: Float;

    // contains booleans for music, sound and colorblind mode
    static public var options: Dynamic;

    // stores loaded bitmap data
    static public var graphics: Dynamic;

    // stores loaded music and sounds
    static public var sounds: Dynamic;

    // Bariol_Bold
    static public var font: Font;

    static public var purchased: Bool;
}