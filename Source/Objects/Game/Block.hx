package objects.game;

import flash.display.Sprite;
import flash.display.Bitmap;

class Block extends Sprite
{
    public var i: Int;
    public var j: Int;

    public var bmp: Bitmap;
    public var color: Int;

    public function new(i: Int, j: Int, x: Int, y: Int)
    {
        super();

        this.i = i;
        this.j = j;

        this.x = x;
        this.y = y;

        color = Std.random(3);

        bmp = new Bitmap(G.graphics.block);
        bmp.smoothing = true;
        addChild(bmp);
    }
}