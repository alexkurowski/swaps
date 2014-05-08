package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.text.TextField;

import objects.game.*;

class TutorialState extends State
{
	private var map: Board;

	private var text: TextField;
	private var currentText: String;

	private var fadeSpeed: Float;

	private var moveSpeed: Float;
	private var acceleration: Float;

	private var mi: Int;
	private var mj: Int;
	private var selected: Bool;
	private var selectX: Int;
	private var selectY: Int;

	private var currentState: Int;
	private var fall: Bool;

	private var addText: TextField;
	private var lastTimer: Int;

	public function new()
	{
		super();

		name = "TutorialState";
	}

	override public function begin()
	{
		addChild(map = new Board());
		map.x = 128;
		map.y = 340;

		map.setColor(0, 0, 2); map.setColor(1, 0, 1); map.setColor(2, 0, 1); map.setColor(3, 0, 2);  map.setColor(4, 0, 0); map.setColor(5, 0, 1);
		map.setColor(0, 1, 2); map.setColor(1, 1, 0); map.setColor(2, 1, 0); map.setColor(3, 1, 2);  map.setColor(4, 1, 0); map.setColor(5, 1, 2);
		map.setColor(0, 2, 2); map.setColor(1, 2, 1); map.setColor(2, 2, 0); map.setColor(3, 2, 1);  map.setColor(4, 2, 2); map.setColor(5, 2, 1);
		map.setColor(0, 3, 0); map.setColor(1, 3, 2); map.setColor(2, 3, 1); map.setColor(3, 3, 2);  map.setColor(4, 3, 0); map.setColor(5, 3, 2);
		map.setColor(0, 4, 1); map.setColor(1, 4, 2); map.setColor(2, 4, 0); map.setColor(3, 4, 1);  map.setColor(4, 4, 0); map.setColor(5, 4, 0);
		map.setColor(0, 5, 0); map.setColor(1, 5, 1); map.setColor(2, 5, 2); map.setColor(3, 5, 0);  map.setColor(4, 5, 1); map.setColor(5, 5, 2);

		for (i in 0...6) {
			map.block[4][i].visible = false;
			map.block[5][i].visible = false;
			map.block[i][4].visible = false;
			map.block[i][5].visible = false;
		}

		addChild(new Bitmap(new BitmapData(768, Math.floor(map.y)*2, false, G.scheme().bg))).y = -Math.floor(map.y);

		currentText = "swap colors\nto form a square";
		text = H.newTextField(0, 970, 768, 64, G.scheme().fg, "center", currentText);
		addChild(text).alpha = 0;

		fadeSpeed = 0.05;

		currentState = 0;
		fall = false;

		moveSpeed = 1.5;
		acceleration = 0.1;

		addChild(addText = H.newTextField(0, -1580, 768, 50, G.scheme().fg, "center", G.names[0] + " was added to the collection\n\n" + G.names[1] + " was added to the collection")).alpha = 0;
		lastTimer = 280;
	}

	override public function update()
	{
		if (text.text == currentText) {
			if (text.alpha < 0.8) text.alpha += fadeSpeed;
		} else {
			if (text.alpha > 0) text.alpha -= fadeSpeed*2;
			else text.text = currentText;
		}

		if (currentState == 2) {
			y += moveSpeed;
			moveSpeed += acceleration;
			if (y > 1500) {
				currentState = 3;
				G.file.data.unlocked[4] = 0;
				G.file.data.unlocked[6] = 1;
				G.file.data.firstStart = false;
				try {
	                G.file.flush();
	            } catch(e: Dynamic) {}
	            G.game.infoState.reset();
			}
			return;
		}

		if (currentState == 3) {
			y = 1500;
			if (lastTimer > 0) {
				lastTimer--;
				if (addText.alpha < 0.8) addText.alpha += fadeSpeed;
			} else {
				if (addText.alpha > 0) addText.alpha -= fadeSpeed;
				else {
					visible = false;
					G.game.setState("menu");
				}
			}
			return;
		}

		if (!fall) {
			if (IO.down) {
				onDown();
			}

			if (IO.released) {
				onRelease();
			}
		} else {
			if (map.doneFalling()) {
                if (currentState == 0) {
	                currentState = 1;
	                fall = false;
	                currentText = "you can grow squares\ninto bigger rectangles";
	                for (i in 0...3)
                    	for (j in 0...3)
                        	map.checkSquares(i*2, j*2, false);
	            } else
	            if (currentState == 1) {
	            	currentState = 2;
	                currentText = "";
	                fall = false;
	            }
			}
		}

		map.update();
	}

	private function onDown()
	{
		if (insideMap()) {
			mi = Math.floor((IO.x - 128) / 128);
            mj = Math.floor((IO.y - 340) / 128);
            map.resetScale();
            map.setScale(mi, mj, 1.4);
			if (selected) map.setScale(selectX, selectY, 0.8);
		}
	}

	private function onRelease()
	{
		if (insideMap()) {
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
        }

        var squared = false;
        if (map.checkSquares(mi, mj)) squared = true;
        if (map.checkSquares(selectX, selectY)) squared = true;

        if (!squared && (mi != selectX || mj != selectY) &&
          map.block[mi][mj].color != map.block[selectX][selectY].color) {
            map.swap(selectX, selectY, mi, mj, false);
        } else {
        	if (currentState == 0) currentText = "now pop it";
        }

        selected = false;
	}

	private function pop()
	{
		if (currentState == 0) {
			map.pop(mi, mj);
			fall = true;
		} else if (currentState == 1 && (map.block[3][2].squared || map.block[2][3].squared)) {
			map.pop(mi, mj);
			fall = true;
		}

		if (currentState == 0) {
			map.setColor(1, 0, 0); map.setColor(2, 0, 0);
			map.setColor(1, 1, 1); map.setColor(2, 1, 1);
		} else
		if (currentState == 1) {
			// for (i in 0...4) {
			// 	for (j in 0...3) {
			// 		if (map.block[i][j].y < 0) map.setColor(i, j, -1);
			// 	}
			// }
		}
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

	private function formSquare()
	{
		// if (currentState == 0) {
		// 	block[1][1].squared = true; block[1][1].setColorFrame(block[1][1].color, 0);
		// 	block[2][1].squared = true; block[2][1].setColorFrame(block[2][1].color, 2);
		// 	block[1][2].squared = true; block[1][2].setColorFrame(block[1][2].color, 6);
		// 	block[2][2].squared = true; block[2][2].setColorFrame(block[2][2].color, 8);
		// 	block[1][1].bmp.scaleX = block[1][1].bmp.scaleY = 0;
		// 	block[2][1].bmp.scaleX = block[2][1].bmp.scaleY = 0;
		// 	block[1][2].bmp.scaleX = block[1][2].bmp.scaleY = 0;
		// 	block[2][2].bmp.scaleX = block[2][2].bmp.scaleY = 0;
		// 	map.addChild(block[1][1]);
		// 	block[1][1].setFace(1, 1);
		// }
	}

	private function valid(): Bool
	{
		if (currentState == 0) {
			if (selectX == 0 && selectY == 3 && mi == 1 && mj == 2) return true;
			if (selectX == 1 && selectY == 2 && mi == 0 && mj == 3) return true;
		}
		return false;
	}

	private function insideMap(): Bool
	{
		if (IO.x > 128 && IO.x < 640 && IO.y > 340 && IO.y < 852) return true;
		return false;
	}

	private function resetScale()
	{
		// for (i in 0...4)
		// 	for (j in 0...4)
		// 		block[i][j].targetScale = 1;
	}
}