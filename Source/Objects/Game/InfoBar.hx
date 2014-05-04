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

    private var pauseBar: Array<Bitmap>;

    public function new()
    {
        super();

        lerpSpeed = 0.3;

        
        score = H.newTextField(0, 128, 768, 72, G.scheme().fg, "center", "0");
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
            score.y = 128 + 72 * (1 - score.scaleY);
        }
        // G.maxPopsNotPurchased
    }
}
