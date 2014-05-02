package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import objects.game.*;

class GameState extends State
{
    public var map: Board;

    // block index under the cursor
    private var mi: Int;
    private var mj: Int;

    private var controlable: Bool;

    public var turn: Int;

    public var selected: Bool;
    public var selectX: Int;
    public var selectY: Int;


    public function new()
    {
        super();

        name = "GameState";
    }

    override private function begin()
    {
        selected = false;

        controlable = true;

        turn = 0;

        // flash.Lib.current.stage.color = G.scheme().bg;
        flash.Lib.stage.opaqueBackground = G.scheme().bg;

        map = new Board();
        addChild(map);

        addChild(new Bitmap(new BitmapData(768, Math.floor(map.y)*2, false, G.scheme().bg))).y = -Math.floor(map.y);
    }

    override public function update()
    {
        if (controlable) {
            if (IO.pressed) {

            }

            if (IO.down) {
                onDown();
            }

            if (IO.released) {
                onRelease();
            }
        } else {
            // TODO: make it possible to pop (at least visibly, put it in stack for actual pop later) squares while something is falling
            if (map.doneFalling()) {
                for (i in 0...3) {
                    for (j in 0...3) {
                        map.checkSquares(i*2, j*2, false);
                    }
                }
                controlable = true;
            }
        }

        map.update();
    }

    private function onDown()
    {
        if (IO.y > map.y) {
            mi = Math.floor(IO.x / 128);
            mj = Math.floor((IO.y - map.y) / 128);
            map.resetScale();
            map.setScale(mi, mj, 1.4);
            if (selected) map.setScale(selectX, selectY, 0.8);
        }
    }

    private function onRelease()
    {
        if (IO.y > map.y) {
            if (map.block[mi][mj].color == -1 || map.block[mi][mj].fall) return;
            map.resetScale();
            if (map.block[mi][mj].squared) {
                pop();
            } else {
                if (selected) {
                    swap();
                } else {
                    select();
                }
            }
        }
    }

    private function select()
    {
        selectX = mi;
        selectY = mj;
        map.setScale(selectX, selectY, 0.8);
        selected = true;
    }

    private function swap()
    {
        if ((mi != selectX || mj != selectY) &&
          map.block[mi][mj].color == map.block[selectX][selectY].color) {
            select();
            return;
        }

        if ((mi != selectX || mj != selectY) &&
          map.block[mi][mj].color != map.block[selectX][selectY].color) {
            map.swap(selectX, selectY, mi, mj);
            turn++;
        }

        var squared = false;
        if (map.checkSquares(mi, mj)) squared = true;
        if (map.checkSquares(selectX, selectY)) squared = true;

        // if (!squared && (mi != selectX || mj != selectY) &&
        //   map.block[mi][mj].color != map.block[selectX][selectY].color) {
        //     map.swap(selectX, selectY, mi, mj, false);
        //     turn--;
        // }

        selected = false;
    }

    private function pop()
    {
        map.pop(mi, mj);
        controlable = false;
        selected = false;
    }
}