package objects.menu;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.ColorTransform;
import flash.text.TextField;

class Button extends Sprite
{
    private var bmp: Bitmap;
    private var txt: TextField;

    private var state: String;

    public function new(x: Int, y: Int, text: String)
    {
        super();

        this.x = x;
        this.y = y;

        bmp = new Bitmap();
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
            var colorTransform = new ColorTransform();
            if (newState == 'normal') colorTransform.color = G.scheme().color[0];
            if (newState == 'hover') colorTransform.color = G.scheme().fg;
            if (newState == 'down') colorTransform.color = G.scheme().color[0];
            colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = 1;
            colorTransform.redOffset = -255 + colorTransform.redOffset;
            colorTransform.greenOffset = -255 + colorTransform.greenOffset;
            colorTransform.blueOffset = -255 + colorTransform.blueOffset;
            bmp.bitmapData.colorTransform(bmp.bitmapData.rect, colorTransform);

            state = newState;
        }
    }

    public function isDown(): Bool
    {
        return state == 'down';
    }
}