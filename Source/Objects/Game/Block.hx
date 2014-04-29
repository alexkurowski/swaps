package objects.game;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.ColorTransform;

class Block extends Sprite
{
    public var i: Int;
    public var j: Int;

    public var squared: Bool;

    private var speed: Float;
    private var lerpSpeed: Float;

    public var bmp: Bitmap;
    public var frame: Int;
    public var color: Int;
    private var colorTransform: ColorTransform;

    public var targetScale: Float;

    public function new(i: Int, j: Int, x: Int, y: Int)
    {
        super();

        this.i = i;
        this.j = j;

        this.x = x;
        this.y = y;

        speed = 10;
        lerpSpeed = 0.35;

        targetScale = 1;
        
        squared = false;

        color = Std.random(3);

        colorTransform = new ColorTransform();

        bmp = new Bitmap();
        bmp.smoothing = true;
        bmp.x = bmp.y = 64;
        bmp.scaleX = bmp.scaleY = 0;
        addChild(bmp);

        redraw();
    }

    public function setColor(newColor: Int)
    {
        color = newColor;
        redraw();
    }

    public function redraw(?frame: Int)
    {
        if (color == -1) {
            bmp.visible = false;
        }
        if (color >= 0 && !squared) {
            bmp.visible = true;
            bmp.bitmapData = G.graphics.block.clone();
            colorTransform.color = G.scheme().color[color];
            colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = 1;
            colorTransform.redOffset = -255 + colorTransform.redOffset;
            colorTransform.greenOffset = -255 + colorTransform.greenOffset;
            colorTransform.blueOffset = -255 + colorTransform.blueOffset;
            bmp.bitmapData.colorTransform(bmp.bitmapData.rect, colorTransform);
        }
        if (color >= 0 && squared) {
            bmp.visible = true;
            bmp.bitmapData = G.graphics.square[frame].clone();
            colorTransform.color = G.scheme().color[color];
            colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = 1;
            colorTransform.redOffset = -255 + colorTransform.redOffset;
            colorTransform.greenOffset = -255 + colorTransform.greenOffset;
            colorTransform.blueOffset = -255 + colorTransform.blueOffset;
            bmp.bitmapData.colorTransform(bmp.bitmapData.rect, colorTransform);
        }
    }

    public function update()
    {
        if (bmp.scaleX != targetScale) {
            bmp.scaleX = H.lerp(bmp.scaleX, targetScale, lerpSpeed);
            bmp.scaleY = H.lerp(bmp.scaleX, targetScale, lerpSpeed);
            bmp.x = 64 - bmp.width / 2;
            bmp.y = 64 - bmp.height / 2;
        }
        if (x != i*128) {
            x += speed * H.sign(i*128 - x);
            if (Math.abs(x - i*128) < speed) x = i*128;
        }
        if (y != j*128) {
            y += speed * H.sign(j*128 - y);
            if (Math.abs(y - j*128) < speed) y = j*128;
        }
    }
}