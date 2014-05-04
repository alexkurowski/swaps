package objects.game;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;

class Pause extends Sprite
{
    public function new()
    {
        super();

        alpha = 0;

        addChild(new Bitmap(new BitmapData(768, 340, false, G.scheme().bg)));
    }

    public function update()
    {

    }
}