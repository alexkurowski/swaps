package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.text.TextField;
import openfl.feedback.Haptic;

import objects.game.*;

class GameState extends State
{
    public var map: Board;

    public var txtScore: Array<TextField>;

    // block index under the cursor
    private var mi: Int;
    private var mj: Int;

    private var controlable: Bool;

    public var score: Int;
    public var turn: Int;

    private var fadeSpeed: Float;

    public var selected: Bool;
    public var selectX: Int;
    public var selectY: Int;

    private var info: InfoBar;

    private var rewardTxt: TextField;
    private var rewardTimer: Int;
    private var endDelay: Int;


    public function new()
    {
        super();

        name = "GameState";
    }

    override private function begin()
    {
        removeChildren(0, numChildren-1);

        selected = false;

        controlable = true;

        score = 0;
        turn = 0;

        fadeSpeed = 0.1;

        rewardTimer = 0;
        endDelay = 0;

        mi = mj = 0;

        map = new Board();
        addChild(map);

        txtScore = [];

        addChild(new Bitmap(new BitmapData(768, Math.floor(map.y)*2, false, G.scheme().bg))).y = -Math.floor(map.y);

        addChild(info = new InfoBar());

        addChild(rewardTxt = H.newTextField(0, 1180, 768, 50, G.scheme().fg, "center", "a game by mapisoft")).alpha = 0;
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
            if (IO.down) {
                onDown();
            }

            if (IO.released) {
                onRelease();
            }

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

        scoreUpdate();

        info.update(score, turn);

        if (rewardTimer > 0) {
            rewardTimer--;
            if (rewardTxt.alpha < 0.8) rewardTxt.alpha += fadeSpeed;
        } else {
            if (rewardTxt.alpha > 0) rewardTxt.alpha -= fadeSpeed;
        }
        if (endDelay > 0) endUpdate();

        if (IO.key.BACK) {
            G.game.setState('menu');
            G.game.menuState.set();
        }
    }

    private function onDown()
    {
        if (insideMap()) {
            mi = Math.floor(IO.x / 128);
            mj = Math.floor((IO.y - map.y) / 128);
            if (map.block[mi][mj].fall || map.block[mi][0].fall) return;
            map.resetScale();
            map.setScale(mi, mj, 1.4);
            if (selected) map.setScale(selectX, selectY, 0.8);
        }
    }

    private function onRelease()
    {
        if (insideMap()) {
            if (map.block[mi][mj].color == -1 || map.block[mi][mj].fall) return;
            map.resetScale();

            if (map.block[mi][mj].squared && selected)
                unselect();
            else if (map.block[mi][mj].squared)
                pop();
            else if (selected)
                swap();
            else
                select();
        } else {
            map.resetScale();
            unselect();
        }

        if (IO.x < 90 && IO.y < 80) {
            if (info.restartConfirm) begin();
            else info.restartConfirm = true;
        }

        if (IO.x > 678 && IO.y < 80) {
            G.game.setState('menu');
            G.game.menuState.set();
        }
    }

    private function insideMap(): Bool
    {
        if (IO.x > 0 && IO.x < 768 &&
            IO.y > map.y && IO.y < map.y+768) return true;
        return false;
    }

    private function scoreUpdate()
    {
        for (i in 0...txtScore.length) {
            if (txtScore[i].visible) {
                txtScore[i].alpha -= fadeSpeed*0.5;
                txtScore[i].y -= 3;
                if (txtScore[i].alpha <= 0) txtScore[i].visible = false;
            }
        }
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

    private function unselect()
    {
        selected = false;
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
        var pop = map.pop(mi, mj);
        score += pop.score;
        turn++;
        controlable = false;
        selected = false;

        showScore(pop.i, pop.j, pop.w, pop.h, pop.score);

        unlock(pop);

        G.score += pop.score;
        G.file.data.score = G.score;
        if (G.score >= G.nextScore) nextLevel();
        try {
            G.file.flush();
        } catch (e: Dynamic) {}

        if (!G.purchased && turn >= G.maxPopsNotPurchased) {
            endDelay = 400;
        }
    }

    private function showScore(i: Int, j: Int, w: Int, h: Int, score: Int)
    {
        var t = 0;
        
        for (k in 0...txtScore.length) {
            if (txtScore[k] == null) {
                t = k;
                break;
            }

            if (!txtScore[k].visible) {
                t = k;
                break;
            }
        }


        if (txtScore[t] == null) {
            addChild(txtScore[t] = H.newTextField(0, 0, 128, 82, G.scheme().fg));
        }

        txtScore[t].visible = true;
        txtScore[t].alpha = 1;

        txtScore[t].x = i*128;
        txtScore[t].width = w*128;
        txtScore[t].y = map.y + j*128 + h*64 - 32;
        txtScore[t].text = Std.string(score);
    }

    private function nextLevel()
    {
        G.level++;
        G.nextScore = G.level * 400;

        G.file.data.level++;
    }

    private function reward()
    {
        // Haptic.vibrate(1000, 1000);
        // play reward sound
    }

    private function unlock(pop: Dynamic)
    {
        if (G.file.data.unlocked[pop.score] == null) {
            rewardTimer = 260;
            rewardTxt.text = G.getName(pop.w*10 + pop.h) + ' is added to the collection!';
            // unlock yay!
            G.file.data.unlocked[pop.score] = pop.color;
            try {
                G.file.data.flush();
            } catch(e: Dynamic) {}

            G.game.infoState.reset();
        }
    }

    private function endGame()
    {
        //
    }
}