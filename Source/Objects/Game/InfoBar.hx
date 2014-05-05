package objects.game;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.text.TextField;

class InfoBar extends Sprite
{
    private var lerpSpeed: Float;

    private var score: TextField;
    private var popBar: Bitmap;
    private var popBarEnd: Array<Bitmap>;

    private var scores: Int;

    private var retryBtn: Bitmap;
    private var menuBtn: Bitmap;

    public function new()
    {
        super();

        lerpSpeed = 0.3;

        
        score = H.newTextField(0, 136, 768, 86, G.scheme().fg, "center", "0");
        score.scaleX = score.scaleY = 0.001;
        score.width = 768 / score.scaleX;
        addChild(score);

        addChild(retryBtn = new Bitmap(G.graphics.retry));
        retryBtn.smoothing = true;
        retryBtn.bitmapData.colorTransform(retryBtn.bitmapData.rect, H.recolor(G.scheme().fg));
        addChild(menuBtn = new Bitmap(G.graphics.menu)).x = 678;
        menuBtn.smoothing = true;
        menuBtn.bitmapData.colorTransform(menuBtn.bitmapData.rect, H.recolor(G.scheme().fg));
    }

    public function update(stateScore: Int, turns: Int)
    {
        if (score.text != Std.string(stateScore)) {
            score.text = Std.string(stateScore);
            score.scaleX = score.scaleY = 0.1;
        }
        if (score.scaleX != 1 || score.scaleY != 1) {
            score.scaleX = H.lerp(score.scaleX, 1, lerpSpeed);
            score.scaleY = H.lerp(score.scaleY, 1, lerpSpeed);
            score.width = 768 / score.scaleX;
            score.y = 136 + 72 * (1 - score.scaleY);
        }

        if (IO.down && IO.x < 90 && IO.y < 80) retryBtn.alpha = 0.4;
        else retryBtn.alpha = 1;

        if (IO.down && IO.x > 678 && IO.y < 80) menuBtn.alpha = 0.4;
        else menuBtn.alpha = 1;
        // G.maxPopsNotPurchased
    }
}
