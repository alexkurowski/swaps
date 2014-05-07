package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

import objects.menu.*;

class InfoState extends State
{
    public var sizeList: Array<Int>;
    public var names: Array<String>;

    private var sx: Int;
    private var sy: Int;
    private var ox: Float;
    private var drag: Float;
    private var hScroll: Bool;
    private var vScroll: Bool;

    private var square: Array<Square>;
    private var label: Array<TextField>;

    public function new ()
    {
        super();

        name = "InfoState";
    }

    override public function begin()
    {
        sx = sy = 0;
        ox = 0;

        drag = 0;

        hScroll = vScroll = false;


        // [22, 32, 42, 52,
        //      33, 43, 53, 63,
        //          44, 54, 64,
        //              55, 65,
        //                  66];
        sizeList = [22, 32, 42, 33, 52, 43, 53, 44, 63, 54, 64, 55, 65, 66];

        square = [];
        var w: Int;
        var h: Int;
        for (i in 0...sizeList.length) {
            w = Math.floor(sizeList[i] / 10);
            h = sizeList[i] % 10;
            if (G.file.data.unlocked[w*h] != null)
                square[i] = new Square(w, h, G.file.data.unlocked[w*h]);
            else
                square[i] = new Square(w, h, -1);
            square[i].x = 384 - square[i].width / 2;
            square[i].y = square[i].oy = 500 + 768*i;
            addChild(square[i]);
        }

        label = [];
        for (i in 0...sizeList.length) {
            addChild(label[i] = H.newTextField( 0, Std.int(resolveY(i)), 768, 50, G.scheme().fg, "center", getName(i) ));
        }
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
                else if (Math.abs(sy - IO.y) > 20) vScroll = true;
            }
            if (hScroll) {
                if (IO.x > sx) sx = IO.x;
                x = ox - (sx - IO.x) * scaleX;
            }
            if (vScroll) {
                for (i in 0...square.length) {
                    square[i].y += IO.y - sy;
                    label[i].y = resolveY(i);
                }

                sy = IO.y;

                if (square[0].y > 500) 
                    for (i in 0...square.length) {
                        square[i].y = 500 + 768*i;
                        label[i].y = resolveY(i);
                    }
                if (square[0].y < -9730)
                    for (i in 0...square.length) {
                        square[i].y = -9730 + 768*i;
                        label[i].y = resolveY(i);
                    }
            }
        } else {
            if (Math.abs(drag) > 0.1) {
                for (i in 0...square.length) {
                    square[i].y += drag;
                    label[i].y = resolveY(i);
                }
                drag *= 0.95;

                if (square[0].y > 500)
                    for (i in 0...square.length) {
                        square[i].y = 500 + 768*i;
                        label[i].y = resolveY(i);
                    }
                if (square[0].y < -9730)
                    for (i in 0...square.length) {
                        square[i].y = -9730 + 768*i;
                        label[i].y = resolveY(i);
                    }
            }
        }

        if (IO.released) {
            if (hScroll) {
                if (sx - IO.x > 100) G.game.setState("menu");
                G.game.menuState.set();
            }
            if (vScroll) {
                drag = IO.y - sy;
            }
            if (!hScroll && !vScroll) {
                // tap
            }
            hScroll = vScroll = false;
        }
    }

    private function resolveY(i: Int): Float
    {
        return square[i].y + square[i].height - 10;
    }

    private function getName(i: Int): String
    {
        if (square[i].color != -1) return G.names[i];

        var str = "";
        for (j in 0...G.names[i].length) str += "x";
        return str;
    }

    public function reset()
    {
        var w: Int;
        var h: Int;
        for (i in 0...square.length) {
            w = Math.floor(sizeList[i] / 10);
            h = sizeList[i] % 10;
            if (G.file.data.unlocked[w*h] != null && square[i].color == -1) {
                removeChild(square[i]);
                square[i] = new Square(w, h, G.file.data.unlocked[w*h]);
                square[i].x = 384 - square[i].width / 2;
                square[i].y = square[i].oy = 500 + 768*i;
                addChild(square[i]);
                
                label[i].text = G.names[i];
                label[i].y = resolveY(i);
            } else {
                square[i].y = square[i].oy;
                label[i].y = resolveY(i);
            }
        }

        drag = 0;
    }
}