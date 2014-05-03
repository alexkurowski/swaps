package objects.game;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;

import flash.text.TextField;
import flash.text.TextFormat;

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

        scores = 500;
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

        // popBar = new Bitmap(new BitmapData(256, 6, false, G.scheme().fg));
        // popBar.x = 768 / 2 - popBar.width / 2;
        // popBar.y = 200;
        // addChild(popBar);

        // popBarEnd = [new Bitmap(G.graphics.infoRound), new Bitmap(G.graphics.infoRound)];
        // var colTrans = new flash.geom.ColorTransform();
        // colTrans.color = G.scheme().fg;
        // popBarEnd[0].bitmapData.colorTransform(popBarEnd[0].bitmapData.rect, colTrans);
        // popBarEnd[1].bitmapData.colorTransform(popBarEnd[1].bitmapData.rect, colTrans);
        // popBarEnd[0].x = popBar.x - 3;
        // popBarEnd[1].x = popBar.x + popBar.width - 3;
        // popBarEnd[0].y = popBar.y;
        // popBarEnd[1].y = popBar.y;
        // popBarEnd[0].smoothing = true;
        // popBarEnd[1].smoothing = true;


        // addChild(popBarEnd[0]);
        // addChild(popBarEnd[1]);

        pauseBar = [new Bitmap(new BitmapData(11, 42, false, G.scheme().fg)), new Bitmap(new BitmapData(11, 42, false, G.scheme().fg))];
        pauseBar[0].x = 768 - 54 - 8 - 24 - 8;
        pauseBar[1].x = 768 - 54 - 8;
        pauseBar[0].y = 28;
        pauseBar[1].y = 28;
        pauseBar[0].alpha = 0.8;
        pauseBar[1].alpha = 0.8;
        addChild(pauseBar[0]);
        addChild(pauseBar[1]);

    }

    public function update(score: Int, turns: Int)
    {
        if (this.score.text != Std.string(scores - score)) this.score.text = Std.string(scores - score);
        // if (popBar.scaleX != 1 - turns / pops) {
        //     popBar.scaleX = 1 - turns / pops;
        //     popBar.x = 768 / 2 - popBar.width / 2;
        //     popBarEnd[0].x = popBar.x - 3;
        //     popBarEnd[1].x = popBar.x + popBar.width - 3;
        // }
    }
}
