package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;
import openfl.feedback.Haptic;

import objects.game.*;

class GameState extends State
{
    public var map: Board;

    // block index under the cursor
    private var mi: Int;
    private var mj: Int;

    private var controlable: Bool;

    public var score: Int;
    public var turn: Int;

    private var pauseBtn: Bitmap;

    public var selected: Bool;
    public var selectX: Int;
    public var selectY: Int;

    private var info: InfoBar;

    private var rewardDelay: Int;


    public function new()
    {
        super();

        name = "GameState";
    }

    override private function begin()
    {
        selected = false;

        controlable = true;

        score = 0;
        turn = 0;

        rewardDelay = 0;

        // flash.Lib.current.stage.color = G.scheme().bg;
        flash.Lib.stage.opaqueBackground = G.scheme().bg;

        map = new Board();
        addChild(map);

        addChild(new Bitmap(new BitmapData(768, Math.floor(map.y)*2, false, G.scheme().bg))).y = -Math.floor(map.y);

        addChild(info = new InfoBar());
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

        info.update(score, turn);

        if (rewardDelay > 0) rewardUpdate();
        if (endDelay > 0) endUpdate();
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

    private function rewardUpdate()
    {
        rewardDelay--;
        if (rewardDelay <= 0) reward();
    }

    private function endUpdate()
    {
        endDelay--;
        if (endDelay > 0) endGame();
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
            // turn++;
        }

        var squared = false;
        if (map.checkSquares(mi, mj)) squared = true;
        if (map.checkSquares(selectX, selectY)) squared = true;

        if (!squared && (mi != selectX || mj != selectY) &&
          map.block[mi][mj].color != map.block[selectX][selectY].color) {
            map.swap(selectX, selectY, mi, mj, false);
            // turn--;
        }

        selected = false;
    }

    private function pop()
    {
        var addScore = map.pop(mi, mj);
        score += addScore;
        turn++;
        controlable = false;
        selected = false;

        G.score += addScore;
        G.file.data.score = G.score;
        if (G.score >= G.nextScore) nextLevel();
        try {
            G.file.flush();
        } catch (e: Dynamic) {}

        if (!G.purchased && turns >= G.maxPopsNotPurchased) {
            endDelay = 400;
        }
    }

    private function nextLevel()
    {
        G.level++;
        G.nextScore = G.level * 500;

        G.file.data.level++;

        rewardDelay = 400;
    }

    private function reward()
    {
        Haptic.vibrate(35);
        // play reward sound
    }

    private function endGame()
    {
        //
    }
}