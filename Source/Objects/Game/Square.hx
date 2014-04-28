package objects.game;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.ColorTransform;

class Square extends Sprite
{
    public var active: Bool;

    private var lerpSpeed: Float;

    private var i: Int;
    private var j: Int;

    private var w: Int;
    private var h: Int;

    public var bmp: Array<Array<Bitmap>>;
    public var color: Int;

    public var targetScale: Float;

    public function new(i: Int, j: Int, w: Int, h: Int, color: Int, mi: Int, mj: Int)
    {
        super();
        x = i*128 + w*64;
        y = j*128 + h*64;

        this.i = i;
        this.j = j;

        this.w = w;
        this.h = h;

        this.color = color;

        lerpSpeed = 0.35;

        scaleX = scaleY = 1;
        // scale = 0 if mi and mj inside of this square
        targetScale = 1;

        var frame = 0;
        bmp = [];
        for (k in 0...w) {
            if (frame != 0) frame = 1;
            if (k == w-1) frame = 2;

            bmp[k] = [];
            for (l in 0...h) {
                bmp[k][l] = new Bitmap(G.graphics.square[frame].clone());
                var colorTransform = new ColorTransform();
                colorTransform.color = G.scheme().color[color];
                colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = 1;
                colorTransform.redOffset = -255 + colorTransform.redOffset;
                colorTransform.greenOffset = -255 + colorTransform.greenOffset;
                colorTransform.blueOffset = -255 + colorTransform.blueOffset;
                bmp[k][l].bitmapData.colorTransform(bmp[k][l].bitmapData.rect, colorTransform);

                bmp[k][l].x = k*128;
                bmp[k][l].y = l*128;

                bmp[k][l].smoothing = true;

                addChild(bmp[k][l]);

                if (k == 0) frame -= 3;
                else if (k == w-1) frame += 3;
            }
        }
    }
}