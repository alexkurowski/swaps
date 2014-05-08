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
	private var map: Sprite;
	private var block: Array<Array<Block>>;

	private var text: TextField;
	private var currentText: String;

	private var fadeSpeed: Float;

	private var mi: Int;
	private var mj: Int;
	private var selected: Bool;
	private var selectX: Int;
	private var selectY: Int;

	private var currentSwap: Int;
	private var fall: Bool;

	public function new()
	{
		super();

		name = "TutorialState";
	}

	override public function begin()
	{
		addChild(map = new Sprite());
		map.x = 128;
		map.y = 340;

		block = [];
		for (i in 0...4) {
			block[i] = [];
			for (j in 0...4) {
				map.addChild(block[i][j] = new Block(i, j, 128*i, 128*j));
			}
		}

		block[0][0].setColor(2); block[1][0].setColor(1); block[2][0].setColor(1); block[3][0].setColor(2);
		block[0][1].setColor(2); block[1][1].setColor(0); block[2][1].setColor(0); block[3][1].setColor(2);
		block[0][2].setColor(2); block[1][2].setColor(1); block[2][2].setColor(0); block[3][2].setColor(1);
		block[0][3].setColor(0); block[1][3].setColor(2); block[2][3].setColor(1); block[3][3].setColor(2);

		currentText = "swap colors\nto form squares";
		text = H.newTextField(0, 970, 768, 64, G.scheme().fg, "center", currentText);
		addChild(text).alpha = 0;

		fadeSpeed = 0.025;

		currentSwap = 0;
		fall = false;
	}

	override public function update()
	{
		for (i in 0...4) {
			for (j in 0...4) {
				block[i][j].update();
			}
		}

		if (text.text == currentText) {
			if (text.alpha < 0.8) text.alpha += fadeSpeed;
		} else {
			if (text.alpha > 0) text.alpha -= fadeSpeed;
			else text.text = currentText;
		}

		if (IO.down) {
			onDown();
		}

		if (IO.released) {
			onRelease();
		}

		// have to switch & save G.file.data.firstStart to false on exit!
	}

	private function onDown()
	{
		resetScale();
		if (insideMap()) {
			mi = Math.floor((IO.x - 128) / 128);
            mj = Math.floor((IO.y - 340) / 128);
            if (block[mi][mj].squared) return;
            block[mi][mj].targetScale = 1.4;
			if (selected) block[selectX][selectY].targetScale = 0.8;
		} else {
			if (selected) block[selectX][selectY].targetScale = 0.8;
		}
	}

	private function onRelease()
	{
		resetScale();
		if (block[mi][mj].squared) {
			pop();
		} else {
			if (!selected) {
				selected = true;
				selectX = mi;
				selectY = mj;
			} else {
				selected = false;
				if (valid()) {
					swap();
					formSquare();
				}
			}
			if (selected) block[selectX][selectY].targetScale = 0.8;
		}
	}



	private function swap()
	{
		var swapColor = block[mi][mj].color;
		block[mi][mj].setColor(block[selectX][selectY].color);
		block[selectX][selectY].setColor(swapColor);
	}

	private function pop()
	{
		if (currentSwap == 0) {
			
		}
	}

	private function formSquare()
	{
		if (currentSwap == 0) {
			block[1][1].squared = true; block[1][1].setColorFrame(block[1][1].color, 0);
			block[2][1].squared = true; block[2][1].setColorFrame(block[2][1].color, 2);
			block[1][2].squared = true; block[1][2].setColorFrame(block[1][2].color, 6);
			block[2][2].squared = true; block[2][2].setColorFrame(block[2][2].color, 8);
			block[1][1].bmp.scaleX = block[1][1].bmp.scaleY = 0;
			block[2][1].bmp.scaleX = block[2][1].bmp.scaleY = 0;
			block[1][2].bmp.scaleX = block[1][2].bmp.scaleY = 0;
			block[2][2].bmp.scaleX = block[2][2].bmp.scaleY = 0;
			map.addChild(block[1][1]);
			block[1][1].setFace(1, 1);
		}
	}

	private function valid(): Bool
	{
		if (currentSwap == 0) {
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
		for (i in 0...4)
			for (j in 0...4)
				block[i][j].targetScale = 1;
	}
}