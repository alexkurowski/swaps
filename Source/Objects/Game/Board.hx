package objects.game;

import flash.display.Sprite;

class Board extends Sprite
{
    public var block: Array<Array<Block>>;
    
    public function new()
    {
        super();

        y = 340;

        block = [];
        for (i in 0...6) {
            block[i] = [];
            for (j in 0...6) {
                block[i][j] = new Block(i, j, i*128, j*128);
                addChild(block[i][j]);
            }
        }
    }

    public function setColor(i: Int, j: Int, color: Int)
    {
        block[i][j].setColor(color);
    }

    public function setScale(mi: Int, mj: Int, scale: Float)
    {
        block[mi][mj].targetScale = scale;
    }

    public function resetScale()
    {
        for (i in 0...6)
            for (j in 0...6)
                block[i][j].targetScale = 1;
    }

    public function swap(sx: Int, sy: Int, ex: Int, ey: Int)
    {
        var col = block[sx][sy].color;
        setColor(sx, sy, block[ex][ey].color);
        setColor(ex, ey, col);

        block[sx][sy].bmp.scaleX = block[sx][sy].bmp.scaleY = 0;
        block[ex][ey].bmp.scaleX = block[ex][ey].bmp.scaleY = 0;

        setScale(sx, sy, 1);
        setScale(ex, ey, 1);
    }

    public function pop(i: Int, j: Int)
    {

    }

    public function update()
    {
        for (i in 0...6)
            for (j in 0...6)
                block[i][j].update();
    }
}