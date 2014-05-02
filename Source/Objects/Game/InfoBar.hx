package objects.game;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.text.TextField;
import flash.text.TextFormat;

class InfoBar extends Sprite
{
    private var bmpBg: Bitmap;
    private var bmpBlock: Array<Bitmap>;

    private var score: TextField;
    private var turns: TextField;

    public function new()
    {
        super();

        y = 80;

        bmpBg = new Bitmap(new BitmapData(380, 160, false, G.scheme().fg));
        addChild(bmpBg);

        var textFormat = new TextFormat(G.font.fontName, 76, G.scheme().bg, true);
        textFormat.align = flash.text.TextFormatAlign.RIGHT;

        score = new TextField();
        score.width = 376;
        score.selectable = false;
        score.defaultTextFormat = textFormat;
        score.text = "0";
        addChild(score);

        turns = new TextField();
        turns.y = 80;
        turns.width = 376;
        turns.selectable = false;
        turns.defaultTextFormat = textFormat;
        turns.text = "0";
        addChild(turns);

        bmpBlock = [];
        var j = 0;
        for (i in 0...60) { // needed blocks / 4 + 1
            bmpBlock[i] = new Bitmap(new BitmapData(36, 36, false, G.scheme().fg));
            bmpBlock[i].x = 386 + Math.floor(i/4)*40;
            bmpBlock[i].y = j*40+2;
            j++;
            if (j > 3) j = 0;
            addChild(bmpBlock[i]);
        }
    }

    public function update(score: Int, turns: Int)
    {
        if (this.score.text != Std.string(score)) this.score.text = Std.string(score);
        if (this.turns.text != Std.string(turns)) this.turns.text = Std.string(turns);
    }
}
