package objects.game;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.text.TextField;
import flash.text.TextFormat;

import openfl.feedback.Haptic;

class InfoBar extends Sprite
{
    private var score: TextField;
    private var popBar: Bitmap;
    private var popBarEnd: Array<Bitmap>;

    private var scores: Int;
    private var pops: Int;

    private var pauseBar: Array<Bitmap>;

    public function new()
    {
        super();

        pops = 20;

        var textFormat = new TextFormat(G.font.fontName, 72, G.scheme().fg, true);
        textFormat.align = flash.text.TextFormatAlign.CENTER;

        score = new TextField();
        score.y = 128;
        score.width = 768;
        score.selectable = false;
        score.defaultTextFormat = textFormat;
        score.text = "0";
        addChild(score);

        pauseBar = [new Bitmap(new BitmapData(11, 42, false, G.scheme().fg)), new Bitmap(new BitmapData(11, 42, false, G.scheme().fg))];
        pauseBar[0].x = 674;
        pauseBar[1].x = 706;
        pauseBar[0].y = 28;
        pauseBar[1].y = 28;
        pauseBar[0].alpha = 0.8;
        pauseBar[1].alpha = 0.8;
        addChild(pauseBar[0]);
        addChild(pauseBar[1]);

    }

    public function update(score: Int, turns: Int)
    {
        if (this.score.text != Std.string(G.nextScore - G.score)) this.score.text = Std.string(G.nextScore - G.score);
        
        if (IO.pressed) {
            if (IO.x > 660 && IO.y < 70) Haptic.vibrate(30);
        }
    }
}
