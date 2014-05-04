package;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.media.Sound;
import flash.text.Font;
import states.State;
import flash.net.SharedObject;

// Global variables
class G
{
    static public var purchased: Bool;

    static public var game: Main;

    static public var state: State;

    static public var score: Int;
    static public var nextScore: Int;
    static public var level: Int;

    static public var file: SharedObject;

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

    static public var currentScheme: Int;
    static public var colorScheme: Array<Dynamic>;

    static public function scheme(): Dynamic
    {
        return G.colorScheme[G.currentScheme];
    }
}