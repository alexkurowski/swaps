package objects.game;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.geom.ColorTransform;

class Block extends Sprite
{
    public var i: Int;
    public var j: Int;

    public var squared: Bool;

    public var fall: Bool;
    public var fallDown: Bool;
    public var preFallTimer: Int;
    private var overfall: Int;

    private var speed: Float;
    private var lerpSpeed: Float;
    private var lerpFallSpeed: Float;

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

        speed = 12;
        lerpSpeed = 0.35;
        lerpFallSpeed = 0.45;

        targetScale = 1;
        
        squared = false;
        fall = false;
        fallDown = false;

        preFallTimer = 0;
        overfall = 30;

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

    public function setColorFrame(newColor: Int, frame: Int)
    {
        color = newColor;
        redraw(frame);
    }

    public function redraw(?frame: Int)
    {
        if (color == -1) {
            bmp.visible = false;
            // squared = false;
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
            this.frame = frame;
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
        if (bmp.scaleX != targetScale || bmp.scaleY != targetScale) {
            bmp.scaleX = H.lerp(bmp.scaleX, targetScale, lerpSpeed / G.dt);
            bmp.scaleY = H.lerp(bmp.scaleY, targetScale, lerpSpeed / G.dt);
            if (squared) {
                if (frame == 1 || frame == 7) bmp.scaleX = targetScale;
                if (frame == 3 || frame == 5) bmp.scaleY = targetScale;
                if (frame == 4) bmp.scaleX = bmp.scaleY = targetScale;

                if (frame == 0 || frame == 3 || frame == 6) bmp.x = 128 - bmp.width;
                if (frame == 1 || frame == 4 || frame == 7) bmp.x = 64 - bmp.width / 2;
                if (frame == 2 || frame == 5 || frame == 8) bmp.x = 0;

                if (frame == 0 || frame == 1 || frame == 2) bmp.y = 128 - bmp.height;
                if (frame == 3 || frame == 4 || frame == 5) bmp.y = 64 - bmp.height / 2;
                if (frame == 6 || frame == 7 || frame == 8) bmp.y = 0;

                // trace('['+i+']['+j+'] frame='+frame+' scaleX='+bmp.scaleX+' scaleY='+bmp.scaleY);
            } else {
                bmp.x = 64 - bmp.width / 2;
                bmp.y = 64 - bmp.height / 2;
            }
        }
        if (x != i*128) {
            x += speed * H.sign(i*128 - x);
            if (Math.abs(x - i*128) < speed) x = i*128;
        }
        if (y < j*128 + overfall && fallDown) {
            fall = true;
            if (preFallTimer > 0) preFallTimer--;
            else y += speed * G.dt;
            if (y >= j*128 + overfall) fallDown = false;
        }
        if (y > j*128 && !fallDown) {
            y = H.lerp(y, j*128, lerpFallSpeed / G.dt);
        }
        if (y == j*128) fall = false;
    }
}