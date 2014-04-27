package objects;

import flash.display.Bitmap;
import flash.display.BitmapData;

class Background extends Bitmap
{
    public function new(color: Int)
    {
        super(new BitmapData(1536, 2560, false, color));
        x = -384;
        y = -640;
    }
}