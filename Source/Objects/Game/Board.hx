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

    public function findSquares(mi: Int, mj: Int): Bool
    {
        var found = false;

        for (i in 0...5) {
            for (j in 0...5) {
                if (!block[i][j].squareIndex == -1 &&
                    block[i][j].color == block[i+1][j].color &&
                    block[i][j].color == block[i][j+1].color &&
                    block[i][j].color == block[i+1][j+1].color) {
                    found = true;

                    var newIndex = placeSquare(i, j, mi, mj);
                    block[i][j].visible = block[i+1][j].visible = block[i][j+1].visible = block[i+1][j+1].visible = false;
                    block[i][j].squareIndex = block[i+1][j].squareIndex = block[i][j+1].squareIndex = block[i+1][j+1].squareIndex = newIndex;
                }
            }
        }

        return found;
    }

    public function placeSquare(i: Int, j: Int): Int
    {
        if (square == null) square = [];

        var index = square.length;

        for (k in 0...square.length) {
            if (!square.active) {
                index = k;
                break;
            }
        }

        square[index] = new Square(i, j, 2, 2, block[i][j].color, mi, mj);
        addChild(square[index]);

        return index;
    }

    public function setColor(i: Int, j: Int, color: Int)
    {
        block[i][j].setColor(color);
    }

    public function setScale(mi: Int, mj: Int, scale: Float)
    {
        if (!block[mi][mj].inSquare)
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