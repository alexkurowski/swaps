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

        if (checkSquaresMerge(mi, mj, col)) return;

        if (checkSquaresNew(mi, mj, col)) return;
    }
    // merging with existed squares
    private function checkSquaresMerge(mi: Int, mj: Int, col: Int): Bool
    {
        var valid: Bool;
        var a: Int;
        var b: Int;
        if (mi > 0)
        if (validMerge(mi-1, mj, col)) {
            a = b = mj;
            while (a > 0 && block[mi-1][a].frame != 2) a--;
            while (b < 5 && block[mi-1][b].frame != 8) b++;

            valid = true;
            for (j in a...b+1)
                if (block[mi][j].squared || block[mi][j].color != col) valid = false;

            if (valid) {
                mergeSquare(mi-1, mj, 'right');
                if (mi < 5) checkSquaresMerge(mi+1, mj, col);
                return true;
            }
        }

        if (mi < 5)
        if (validMerge(mi+1, mj, col)) {
            a = b = mj;
            while (a > 0 && block[mi+1][a].frame != 0) a--;
            while (b < 5 && block[mi+1][b].frame != 6) b++;

            valid = true;
            for (j in a...b+1)
                if (block[mi][j].squared || block[mi][j].color != col) valid = false;

            if (valid) {
                mergeSquare(mi+1, mj, 'left');
                if (mi > 0) checkSquaresMerge(mi-1, mj, col);
                return true;
            }
        }

        if (mj > 0)
        if (validMerge(mi, mj-1, col)) {
            a = b = mi;
            while (a > 0 && block[a][mj-1].frame != 6) a--;
            while (b < 5 && block[b][mj-1].frame != 8) b++;

            valid = true;
            for (i in a...b+1)
                if (block[i][mj].squared || block[i][mj].color != col) valid = false;

            if (valid) {
                mergeSquare(mi, mj-1, 'down');
                if (mj < 5) checkSquaresMerge(mi, mj+1, col);
                return true;
            }
        }

        if (mj < 5)
        if (validMerge(mi, mj+1, col)) {
            a = b = mi;
            while (a > 0 && block[a][mj+1].frame != 0) a--;
            while (b < 5 && block[b][mj+1].frame != 2) b++;

            valid = true;
            for (i in a...b+1)
                if (block[i][mj].squared || block[i][mj].color != col) valid = false;

            if (valid) {
                mergeSquare(mi, mj+1, 'up');
                if (mj > 0) checkSquaresMerge(mi, mj-1, col);
                return true;
            }
        }

        return false;
    }

    private function validMerge(i: Int, j: Int, col: Int): Bool
    {
        if (i < 0 || i > 5 || j < 0 || j > 5) return false;
        if (block[i][j].squared && block[i][j].color == col) return true;
        return false;
    }

    private function mergeSquare(mi: Int, mj: Int, side: String)
    {
        var i = mi;
        var j = mj;
        var w = 1;
        var h = 1;

        // find top left corner
        while (block[i][j].frame != 0) {
            if (block[i][j].frame != 0 && block[i][j].frame != 3 && block[i][j].frame != 6) i--;
            if (block[i][j].frame >= 3) j--;
        }

        // find width and height
        while (block[i+w][j+h].frame != 8) {
            if (block[i+w][j].frame != 2) w++;
            if (block[i][j+h].frame != 6) h++;
        }

        // expand to the side
        if (side == 'left') {
            i--;
            w++;
        }
        if (side == 'right') {
            w++;
        }
        if (side == 'up') {
            j--;
            h++;
        }
        if (side == 'down') {
            h++;
        }

        w++;
        h++;

        var frame = 0;
        for (k in 0...w) {
            for (l in 0...h) {
                block[i+k][j+l].squared = true;
                block[i+k][j+l].bmp.scaleX = block[i+k][j+l].bmp.scaleY = 0;

                frame = -1;
                if (frame == -1) if (k == 0 && l == 0) frame = 0;
                if (frame == -1) if (k > 0 && k < w-1 && l == 0) frame = 1;
                if (frame == -1) if (k == w-1 && l == 0) frame = 2;
                if (frame == -1) if (k == 0 && l > 0 && l < h-1) frame = 3;
                if (frame == -1) if (k > 0 && k < w-1 && l > 0 && l < h-1) frame = 4;
                if (frame == -1) if (k == w-1 && l > 0 && l < h-1) frame = 5;
                if (frame == -1) if (k == 0 && l == h-1) frame = 6;
                if (frame == -1) if (k > 0 && k < w-1 && l == h-1) frame = 7;
                if (frame == -1) if (k == w-1 && l == h-1) frame = 8;

                block[i+k][j+l].redraw(frame);
            }
        }
    }

    // place new square
    private function checkSquaresNew(mi: Int, mj: Int, col: Int): Bool
    {
        if (mi > 0 && mi < 5 && mj > 0 && mj < 5)
        if (validNew(mi-1, mj-1, col) && validNew(mi, mj-1, col) && validNew(mi+1, mj-1, col) &&
            validNew(mi-1, mj, col) && validNew(mi, mj, col) && validNew(mi+1, mj, col) &&
            validNew(mi-1, mj+1, col) && validNew(mi, mj+1, col) && validNew(mi+1, mj+1, col)) {
            newSquare(mi-1, mj-1, 3, 3);
            return true;
        }

        if (mi > 0 && mi < 5 && mj > 0)
        if (validNew(mi-1, mj-1, col) && validNew(mi, mj-1, col) && validNew(mi+1, mj-1, col) &&
            validNew(mi-1, mj, col) && validNew(mi, mj, col) && validNew(mi+1, mj, col)) {
            newSquare(mi-1, mj-1, 3, 2);
            return true;
        }

        if (mi > 0 && mi < 5 && mj < 5)
        if (validNew(mi-1, mj, col) && validNew(mi, mj, col) && validNew(mi+1, mj, col) &&
            validNew(mi-1, mj+1, col) && validNew(mi, mj+1, col) && validNew(mi+1, mj+1, col)) {
            newSquare(mi-1, mj, 3, 2);
            return true;
        }

        if (mi > 0 && mj > 0 && mj < 5)
        if (validNew(mi-1, mj-1, col) && validNew(mi, mj-1, col) &&
            validNew(mi-1, mj, col) && validNew(mi, mj, col) &&
            validNew(mi-1, mj+1, col) && validNew(mi, mj+1, col)) {
            newSquare(mi-1, mj-1, 2, 3);
            return true;
        }

        if (mi < 5 && mj > 0 && mj < 5)
        if (validNew(mi, mj-1, col) && validNew(mi+1, mj-1, col) &&
            validNew(mi, mj, col) && validNew(mi+1, mj, col) &&
            validNew(mi, mj+1, col) && validNew(mi+1, mj+1, col)) {
            newSquare(mi, mj-1, 2, 3);
            return true;
        }

        if (mi > 0 && mj > 0)
        if (validNew(mi-1, mj-1, col) && validNew(mi, mj-1, col) &&
            validNew(mi-1, mj, col) && validNew(mi, mj, col)) {
            newSquare(mi-1, mj-1, 2, 2);
            return true;
        }

        if (mi < 5 && mj > 0)
        if (validNew(mi, mj-1, col) && validNew(mi+1, mj-1, col) &&
            validNew(mi, mj, col) && validNew(mi+1, mj, col)) {
            newSquare(mi, mj-1, 2, 2);
            return true;
        }

        if (mi > 0 && mj < 5)
        if (validNew(mi-1, mj, col) && validNew(mi, mj, col) &&
            validNew(mi-1, mj+1, col) && validNew(mi, mj+1, col)) {
            newSquare(mi-1, mj, 2, 2);
            return true;
        }

        if (mi < 5 && mj < 5)
        if (validNew(mi, mj, col) && validNew(mi+1, mj, col) &&
            validNew(mi, mj+1, col) && validNew(mi+1, mj+1, col)) {
            newSquare(mi, mj, 2, 2);
            return true;
        }

        return false;
    }

    private function validNew(i: Int, j: Int, col: Int): Bool
    {
        if (!block[i][j].squared && block[i][j].color == col) return true;
        return false;
    }

    public function newSquare(i: Int, j: Int, w: Int, h: Int)
    {
        var frame = 0;
        for (k in 0...w) {
            for (l in 0...h) {
                block[i+k][j+l].squared = true;
                block[i+k][j+l].bmp.scaleX = block[i+k][j+l].bmp.scaleY = 0;

                frame = -1;
                if (frame == -1) if (k == 0 && l == 0) frame = 0;
                if (frame == -1) if (k > 0 && k < w-1 && l == 0) frame = 1;
                if (frame == -1) if (k == w-1 && l == 0) frame = 2;
                if (frame == -1) if (k == 0 && l > 0 && l < h-1) frame = 3;
                if (frame == -1) if (k > 0 && k < w-1 && l > 0 && l < h-1) frame = 4;
                if (frame == -1) if (k == w-1 && l > 0 && l < h-1) frame = 5;
                if (frame == -1) if (k == 0 && l == h-1) frame = 6;
                if (frame == -1) if (k > 0 && k < w-1 && l == h-1) frame = 7;
                if (frame == -1) if (k == w-1 && l == h-1) frame = 8;

                block[i+k][j+l].redraw(frame);
            }
        }
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
        var w = 1;
        var h = 1;

        // find top left corner
        while (block[i][j].frame != 0) {
            if (block[i][j].frame != 0 && block[i][j].frame != 3 && block[i][j].frame != 6) i--;
            if (block[i][j].frame >= 3) j--;
        }

        // find width and height
        while (block[i+w][j+h].frame != 8) {
            if (block[i+w][j].frame != 2) w++;
            if (block[i][j+h].frame != 6) h++;
        }

        for (k in 0...w+1) {
            for (l in 0...h+1) {
                block[i+k][j+l].squared = false;
                // TODO: make them fall instead
                setColor(i+k, j+l, Std.random(3));
                block[i+k][j+l].bmp.scaleX = block[i+k][j+l].bmp.scaleY = 0;
            }
        }
    }

    public function update()
    {
        for (i in 0...6)
            for (j in 0...6)
                block[i][j].update();
    }
}