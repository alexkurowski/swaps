package objects.game;

import flash.display.Sprite;
import flash.display.Bitmap;

class Square extends objects.menu.Square
{
    public var active: Bool;

    private var centerY: Float;
    private var margin: Float;
    private var lerpSpeed: Float;
    private var moveSpeed: Float;
    private var acceleration: Float;

    public function new(w: Int, h: Int, color: Int)
    {
        active = true;

        super(w, h, color);
        scaleX = scaleY = 1.1;
        x = 384 - width / 2;
        y = -100 - height;

        centerY = 1280 /2 - height / 2 + 50;
        margin = 100;

        lerpSpeed = 0.1;
        moveSpeed = 2.5;
        acceleration = 1.5;
    }

    public function update()
    {
        if (!active) return;

        if (y < centerY - margin) {
            y = H.lerp(y, centerY, lerpSpeed);
        } else
        if (y < centerY + margin) {
            y += moveSpeed;
        } else {
            moveSpeed += acceleration;
            y += moveSpeed;
        }
        if (y > 1480) active = false;
    }
}