package objects.menu;

import flash.display.Sprite;
import flash.display.Bitmap;

class Square extends Sprite
{
	private var bg: Array<Array<Bitmap>>;

	private var face: Bitmap;

	public var oy: Float;

	public var color: Int;

	public function new(w: Int, h: Int, color: Int)
	{
		super();

		this.color = color;

		var frame: Int;
		bg = [];
		for (i in 0...w) {
			bg[i] = [];
			for (j in 0...h) {
				if (i == 0 && j == 0) frame = 0;
                else if (i > 0 && i < w-1 && j == 0) frame = 1;
                else if (i == w-1 && j == 0) frame = 2;
                else if (i == 0 && j > 0 && j < h-1) frame = 3;
                else if (i > 0 && i < w-1 && j > 0 && j < h-1) frame = 4;
                else if (i == w-1 && j > 0 && j < h-1) frame = 5;
                else if (i == 0 && j == h-1) frame = 6;
                else if (i > 0 && i < w-1 && j == h-1) frame = 7;
                else if (i == w-1 && j == h-1) frame = 8;
                else frame = -1;

                bg[i][j] = new Bitmap(G.graphics.square[frame].clone());
                bg[i][j].x = i*128;
                bg[i][j].y = j*128;
                if (color == -1) {
                	bg[i][j].bitmapData.colorTransform(bg[i][j].bitmapData.rect, H.recolor(G.scheme().fg));
                	bg[i][j].alpha = 0.6;
                } else
                	bg[i][j].bitmapData.colorTransform(bg[i][j].bitmapData.rect, H.recolor(G.scheme().color[color]));
                addChild(bg[i][j]);
			}
		}

		addChild(face = new Bitmap(G.graphics.face[w*h]));
		face.x = (w*128) / 2 - 64;
        face.y = (h*128) / 2 - 64;
        if (color == -1) face.visible = false;
	}


}