package objects.game;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.text.TextField;

class InfoBar extends Sprite
{
    private var fadeSpeed: Float;
    private var lerpSpeed: Float;

    private var score: TextField;
    private var popBar: Bitmap;
    private var popBarEnd: Array<Bitmap>;

    private var scores: Int;

    private var restartBtn: Bitmap;
    private var restartLabel: TextField;
    public var restartConfirm: Bool;
    private var menuBtn: Bitmap;

    public function new()
    {
        super();

        fadeSpeed = 0.1;
        lerpSpeed = 0.3;
        restartConfirm = false;

        
        score = H.newTextField(0, 136, 768, 86, G.scheme().fg, "center", "0");
        score.scaleX = score.scaleY = 0.001;
        score.width = 768 / score.scaleX;
        addChild(score);

        addChild(restartBtn = new Bitmap(G.graphics.retry));
        restartBtn.smoothing = true;
        restartBtn.alpha = 0.5;
        restartBtn.bitmapData.colorTransform(restartBtn.bitmapData.rect, H.recolor(G.scheme().fg));

        addChild(restartLabel = H.newTextField(95, 8, 200, 50, G.scheme().fg, "left", "restart")).alpha = 0;

        addChild(menuBtn = new Bitmap(G.graphics.menu));
        menuBtn.x = 678;
        menuBtn.smoothing = true;
        menuBtn.alpha = 0.5;
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

        if (restartConfirm) {
            if (restartLabel.alpha < 0.7) restartLabel.alpha += fadeSpeed;
        }

        if (IO.down && IO.x < 90 && IO.y < 80) restartBtn.alpha = 0.8;
        else restartBtn.alpha = 0.5;

        if (IO.down && IO.x > 678 && IO.y < 80) menuBtn.alpha = 0.8;
        else menuBtn.alpha = 0.5;
    }
}
