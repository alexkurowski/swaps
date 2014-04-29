package objects.game;

import flash.display.Sprite;

class Board extends Sprite
{
    public var block: Array<Array<Block>>;

    public var square: Array<Square>;
    
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

        removeSquares();
    }

    private function removeSquares()
    {
        var done = true;

        for (i in 0...5) {
            for (j in 0...5) {
                if (block[i][j].color == block[i+1][j].color &&
                    block[i][j].color == block[i][j+1].color &&
                    block[i][j].color == block[i+1][j+1].color) {
                    done = false;
                    setColor(i + Std.random(2), j + Std.random(2), H.randomNot(3, block[i][j].color));
                }
            }
        }

        if (!done) {
            removeSquares();
        }
    }

    public function checkSquares(mi: Int, mj: Int)
    {
        // merging ->
        //   find squares, check its border [i-1], [j-1], [i+w+1], [j+h+1]
        // new squares ->
        //   check 8 neighbour blocks of two swapped blocks (if they aren't squared yet)

        var col = block[mi][mj].color;

        // merging with existed squares
        // TODO: check every side for .squared block
        //   if found: check if it can be extended in the direction of a swapped block ([mi][mj])

        // place new square
        // TODO: make it look for 3x2, 2x3 and 3x3 sizes as well
        if (mi > 0) mi--;
        if (mj > 0) mj--;

        for (k in 0...2) {
            for (l in 0...2) {
                if (mi+k < 5 && mj+l < 5) {
                    if (!block[mi+k][mj+l].squared && !block[mi+1+k][mj+l].squared &&
                        !block[mi+k][mj+1+l].squared && !block[mi+1+k][mj+1+l].squared &&
                        block[mi+k][mj+l].color == col && block[mi+1+k][mj+l].color == col &&
                        block[mi+k][mj+1+l].color == col && block[mi+1+k][mj+1+l].color == col) {

                        placeSquare(mi+k, mj+l, 2, 2);
                        break;
                    }
                }
            }
        }
    }

    public function placeSquare(i: Int, j: Int, w: Int = 2, h: Int = 2)
    {
        for (k in 0...2)
            for (l in 0...2) {
                block[i+k][j+l].squared = true;
                block[i+k][j+l].bmp.scaleX = block[i+k][j+l].bmp.scaleY = 0;
                // block[i+k][j+l].bmp.x = block[i+k][j+l].bmp.y = 0;
            }

        block[i][j].redraw(0);
        block[i+1][j].redraw(2);
        block[i][j+1].redraw(6);
        block[i+1][j+1].redraw(8);
    }

    public function setColor(i: Int, j: Int, color: Int)
    {
        block[i][j].setColor(color);
    }

    public function setScale(mi: Int, mj: Int, scale: Float)
    {
        if (!block[mi][mj].squared)
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