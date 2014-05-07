package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

import objects.menu.*;

class InfoState extends State
{
    private var sx: Int;
    private var sy: Int;
    private var ox: Float;
    private var hScroll: Bool;
    private var vScroll: Bool;

    public function new ()
    {
        super();

        name = "InfoState";
    }

    override public function begin()
    {
        sx = sy = 0;
        ox = 0;

        hScroll = vScroll = false;
    }

    override public function update()
    {
        if (IO.pressed) {
            sx = IO.x;
            sy = IO.y;
            ox = x;
        }

        if (IO.down) {
            if (!hScroll && !vScroll) {
                if (Math.abs(sx - IO.x) > 50) hScroll = true;
                else if (Math.abs(sy - IO.y) > 50) vScroll = true;
            }
            if (hScroll) {
                if (IO.x > sx) sx = IO.x;
                x = ox - (sx - IO.x) * scaleX;
            }
        }

        if (IO.released) {
            if (hScroll) {
                if (sx - IO.x > 100) G.game.setState("menu");
                G.game.menuState.set();
            }
            if (vScroll) {
                snap();
            }
            hScroll = vScroll = false;
        }
    }

    private function snap()
    {
        // snaps scrolled blocks to nearest
    }
}