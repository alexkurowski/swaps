package objects.menu;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

class Button extends Sprite
{
    private var bmp: Bitmap;
    private var txt: TextField;

    private var colorNorm: Int;
    private var colorHover: Int;

    public var state: String;

    public function new(x: Int, y: Int, text: String, color1: Int, color2: Int)
    {
        super();

        this.x = x;
        this.y = y;

        colorNorm = color1;
        colorHover = color2;

        bmp = new Bitmap();
        bmp.smoothing = true;
        addChild(bmp);

        state = '';
        update();

        txt = H.newTextField(0, 34, 512, 62, G.scheme().bg, "center", text);
        addChild(txt);
    }

    public function update()
    {
        var newState: String = 'normal';

        if (IO.x > x && IO.x < x+512 && IO.y > y && IO.y < y + 128) {
            if (IO.down) newState = 'hover';
            if (IO.released) newState = 'down';
        }

        if (state != newState) {
            bmp.bitmapData = G.graphics.button.clone();
            switch (newState) {
                case "normal": bmp.bitmapData.colorTransform(bmp.bitmapData.rect, H.recolor(colorNorm));
                case "hover":  bmp.bitmapData.colorTransform(bmp.bitmapData.rect, H.recolor(colorHover));
                case "down":   bmp.bitmapData.colorTransform(bmp.bitmapData.rect, H.recolor(colorNorm));
            }
            
            state = newState;
        }
    }

    public function isDown(): Bool
    {
        return state == 'down';
    }
}