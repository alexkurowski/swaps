package objects.menu;

import flash.display.Sprite;
import flash.display.Bitmap;

class ToggleButton extends Sprite
{
    private var bmp: Bitmap;

    private var fadeSpeed: Float;

    private var down: Bool;

    public var state: Bool;

    public function new(x: Int, y: Int, type: String, isOn: Bool)
    {
        super();

        this.x = x;
        this.y = y;

        bmp = new Bitmap();
        bmp.smoothing = true;
        switch (type) {
            case "music": bmp.bitmapData = G.graphics.music;
            case "vibro": bmp.bitmapData = G.graphics.vibro;
        }
        bmp.bitmapData.colorTransform(bmp.bitmapData.rect, H.recolor(G.scheme().fg));
        addChild(bmp);

        state = isOn;
        bmp.alpha = 0.4;

        fadeSpeed = 0.1;
        down = false;
    }

    public function update()
    {
        down = false;

        if (IO.x > x-32 && IO.x < x + bmp.width+32 && IO.y > y-32 && IO.y < y + bmp.height+32) {
            if (IO.released) {
                state = !state;
                down = true;
            }
        }

        if (state) {
            if (bmp.alpha < 0.8) bmp.alpha += fadeSpeed;
        } else {
            if (bmp.alpha > 0.3) bmp.alpha -= fadeSpeed;
        }
    }

    public function isDown(): Bool
    {
        return down;
    }
}