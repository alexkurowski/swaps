package objects.game;

import flash.display.Sprite;

class Board extends Sprite
{
    public var block: Array<Array<Block>>;
    public var old: Array<Array<Block>>;

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

        old = block.copy();

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

    public function checkSquares(mi: Int, mj: Int, mergeCheck: Bool = true): Bool
    {
        // merging ->
        //   find squares, check its border [i-1], [j-1], [i+w+1], [j+h+1]
        // new squares ->
        //   check 8 neighbour blocks of two swapped blocks (if they aren't squared yet)

        var col = block[mi][mj].color;
        var squared = false;

        if (mergeCheck) if (checkSquaresMerge(mi, mj, col)) squared = true;

        if (checkAllSquaresMerge()) squared = true;

        if (checkSquaresNew(mi, mj, col)) squared = true;

        return squared;
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
            for (j in a...b+1) {
                if (block[mi][j].squared) {
                    if (j == a && block[mi][j].frame != 0 && block[mi][j].frame != 1 && block[mi][j].frame != 2) valid = false;
                    if (j == b && block[mi][j].frame != 6 && block[mi][j].frame != 7 && block[mi][j].frame != 8) valid = false;
                    if (j != a && j != b && block[mi][j].frame != 3 && block[mi][j].frame != 4 && block[mi][j].frame != 5) valid = false;
                }
                if (block[mi][j].color != col) valid = false;
            }

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
            for (j in a...b+1) {
                if (block[mi][j].squared) {
                    if (j == a && block[mi][j].frame != 2 && block[mi][j].frame != 1 && block[mi][j].frame != 0) valid = false;
                    if (j == b && block[mi][j].frame != 8 && block[mi][j].frame != 7 && block[mi][j].frame != 6) valid = false;
                    if (j != a && j != b && block[mi][j].frame != 5 && block[mi][j].frame != 4 && block[mi][j].frame != 3) valid = false;
                }
                if (block[mi][j].color != col) valid = false;
            }

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
            for (i in a...b+1) {
                if (block[i][mj].squared) {
                    if (i == a && block[i][mj].frame != 0 && block[i][mj].frame != 3 && block[i][mj].frame != 6) valid = false;
                    if (i == b && block[i][mj].frame != 2 && block[i][mj].frame != 5 && block[i][mj].frame != 8) valid = false;
                    if (i != a && i != b && block[i][mj].frame != 1 && block[i][mj].frame != 4 && block[i][mj].frame != 7) valid = false;
                }
                if (block[i][mj].color != col) valid = false;
            }

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
            for (i in a...b+1) {
                if (block[i][mj].squared) {
                    if (i == a && block[i][mj].frame != 6 && block[i][mj].frame != 3 && block[i][mj].frame != 0) valid = false;
                    if (i == b && block[i][mj].frame != 8 && block[i][mj].frame != 5 && block[i][mj].frame != 2) valid = false;
                    if (i != a && i != b && block[i][mj].frame != 7 && block[i][mj].frame != 4 && block[i][mj].frame != 1) valid = false;
                }
                if (block[i][mj].color != col) valid = false;
            }

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

                if (k == 0 && l == 0) frame = 0;
                else if (k > 0 && k < w-1 && l == 0) frame = 1;
                else if (k == w-1 && l == 0) frame = 2;
                else if (k == 0 && l > 0 && l < h-1) frame = 3;
                else if (k > 0 && k < w-1 && l > 0 && l < h-1) frame = 4;
                else if (k == w-1 && l > 0 && l < h-1) frame = 5;
                else if (k == 0 && l == h-1) frame = 6;
                else if (k > 0 && k < w-1 && l == h-1) frame = 7;
                else if (k == w-1 && l == h-1) frame = 8;
                else frame = -1;

                block[i+k][j+l].redraw(frame);
            }
        }
    }

    private function checkAllSquaresMerge(): Bool
    {
        var w: Int;
        var h: Int;
        var doMerge: Bool;

        for (i in 0...5) {
            for (j in 0...5) {
                if (block[i][j].squared && block[i][j].frame == 0) {
                    // find size
                    w = h = 1;
                    while (i+w < 5 && block[i+w][j].frame != 2) w++;
                    while (j+h < 5 && block[i][j+h].frame != 6) h++;
                    w++;
                    h++;

                    // to the right
                    doMerge = true;
                    if (i+w <= 5) {
                        for (l in 0...h) {
                            if (block[i+w][j+l].squared) {
                                if (l == 0 && block[i+w][j+l].frame != 0 && block[i+w][j+l].frame != 1 && block[i+w][j+l].frame != 2) doMerge = false;
                                if (l == h-1 && block[i+w][j+l].frame != 6 && block[i+w][j+l].frame != 7 && block[i+w][j+l].frame != 8) doMerge = false;
                                if (l != 0 && l != h-1 && block[i+w][j+l].frame != 3 && block[i+w][j+l].frame != 4 && block[i+w][j+l].frame != 5) doMerge = false;
                            }
                            if (block[i+w][j+l].color != block[i][j].color) doMerge = false;
                        }
                        if (doMerge) {
                            mergeSquare(i, j, 'right');
                            checkAllSquaresMerge();
                            return true;
                        }
                    }

                    // to the left
                    doMerge = true;
                    if (i-1 >= 0) {
                        for (l in 0...h) {
                            if (block[i-1][j+l].squared) {
                                if (l == 0 && block[i-1][j+l].frame != 0 && block[i-1][j+l].frame != 1 && block[i-1][j+l].frame != 2) doMerge = false;
                                if (l == h-1 && block[i-1][j+l].frame != 6 && block[i-1][j+l].frame != 7 && block[i-1][j+l].frame != 8) doMerge = false;
                                if (l != 0 && l != h-1 && block[i-1][j+l].frame != 3 && block[i-1][j+l].frame != 4 && block[i-1][j+l].frame != 5) doMerge = false;
                            }
                            if (block[i-1][j+l].color != block[i][j].color) doMerge = false;
                        }
                        if (doMerge) {
                            mergeSquare(i, j, 'left');
                            checkAllSquaresMerge();
                            return true;
                        }
                    }

                    // downwards
                    doMerge = true;
                    if (j+h <= 5) {
                        for (k in 0...w) {
                            if (block[i+k][j+h].squared) {
                                if (k == 0 && block[i+k][j+h].frame != 0 && block[i+k][j+h].frame != 3 && block[i+k][j+h].frame != 6) doMerge = false;
                                if (k == w-1 && block[i+k][j+h].frame != 2 && block[i+k][j+h].frame != 5 && block[i+k][j+h].frame != 8) doMerge = false;
                                if (k != 0 && k != w-1 && block[i+k][j+h].frame != 1 && block[i+k][j+h].frame != 4 && block[i+k][j+h].frame != 7) doMerge = false;
                            }
                            if (block[i+k][j+h].color != block[i][j].color) doMerge = false;
                        }
                        if (doMerge) {
                            mergeSquare(i, j, 'down');
                            checkAllSquaresMerge();
                            return true;
                        }
                    }

                    // upwards
                    doMerge = true;
                    if (j-1 >= 0) {
                        for (k in 0...w) {
                            if (block[i+k][j-1].squared) {
                                if (k == 0 && block[i+k][j-1].frame != 0 && block[i+k][j-1].frame != 3 && block[i+k][j-1].frame != 6) doMerge = false;
                                if (k == w-1 && block[i+k][j-1].frame != 2 && block[i+k][j-1].frame != 5 && block[i+k][j-1].frame != 8) doMerge = false;
                                if (k != 0 && k != w-1 && block[i+k][j-1].frame != 1 && block[i+k][j-1].frame != 4 && block[i+k][j-1].frame != 7) doMerge = false;
                            }
                            if (block[i+k][j-1].color != block[i][j].color) doMerge = false;
                        }
                        if (doMerge) {
                            mergeSquare(i, j, 'up');
                            checkAllSquaresMerge();
                            return true;
                        }
                    }
                }
            }
        }

        return false;
    }

    // place new square
    private function checkSquaresNew(mi: Int, mj: Int, col: Int): Bool
    {
        if (block[mi][mj].squared) return false;

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
                if (k == 0 && l == 0) frame = 0;
                else if (k > 0 && k < w-1 && l == 0) frame = 1;
                else if (k == w-1 && l == 0) frame = 2;
                else if (k == 0 && l > 0 && l < h-1) frame = 3;
                else if (k > 0 && k < w-1 && l > 0 && l < h-1) frame = 4;
                else if (k == w-1 && l > 0 && l < h-1) frame = 5;
                else if (k == 0 && l == h-1) frame = 6;
                else if (k > 0 && k < w-1 && l == h-1) frame = 7;
                else if (k == w-1 && l == h-1) frame = 8;
                else frame = -1;

                block[i+k][j+l].redraw(frame);
            }
        }
    }

    public function setColor(i: Int, j: Int, color: Int)
    {
        block[i][j].setColor(color);
    }

    public function setColorFrame(i: Int, j: Int, color: Int, frame: Int)
    {
        block[i][j].setColorFrame(color, frame);
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

    public function swap(sx: Int, sy: Int, ex: Int, ey: Int, rescale: Bool = true)
    {
        var col = block[sx][sy].color;
        setColor(sx, sy, block[ex][ey].color);
        setColor(ex, ey, col);

        if (rescale) {
            block[sx][sy].bmp.scaleX = block[sx][sy].bmp.scaleY = 0;
            block[ex][ey].bmp.scaleX = block[ex][ey].bmp.scaleY = 0;

            setScale(sx, sy, 1);
            setScale(ex, ey, 1);
        } else {
            block[sx][sy].bmp.scaleX = block[sx][sy].bmp.scaleY = 0.8;
            block[ex][ey].bmp.scaleX = block[ex][ey].bmp.scaleY = 1.4;

            setScale(sx, sy, 1);
            setScale(ex, ey, 1);
        }
    }

    private function fallSwap(sx: Int, sy: Int, ex: Int, ey: Int)
    {
        if (block[sx][sy].squared) {
            block[sx][sy].squared = false;
            block[ex][ey].squared = true;
            setColorFrame(ex, ey, block[sx][sy].color, block[sx][sy].frame);
            setColor(sx, sy, -1);
        } else {
            if (block[ex][ey].squared) block[ex][ey].squared = false;
            setColor(ex, ey, block[sx][sy].color);
            setColor(sx, sy, -1);
        }
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
                setColor(i+k, j+l, -1);
                // setColor(i+k, j+l, Std.random(3));
                // block[i+k][j+l].bmp.scaleX = block[i+k][j+l].bmp.scaleY = 0;
            }
        }

        fall();

        fallNew();
    }

    private function fall()
    {
        var done = true;
        var a: Int;
        var b: Int;
        var valid: Bool;

        for (i in 0...6) {
            for (j in 0...5) {
                if (!block[i][4-j].squared && block[i][4-j].color != -1 && block[i][5-j].color == -1) {
                    fallSwap(i, 4-j, i, 5-j);
                    block[i][5-j].y = block[i][4-j].y;
                    block[i][4-j].y = (4-j)*128;

                    block[i][5-j].preFallTimer = 10;
                    block[i][5-j].fallDown = true;
                    done = false;
                    break;
                } else
                if (block[i][4-j].squared && block[i][4-j].color != -1 && block[i][5-j].color == -1) {
                    a = b = i;
                    while (block[a][4-j].frame != 6 && block[a][4-j].frame != 3 && block[a][4-j].frame != 0) a--;
                    while (block[b][4-j].frame != 8 && block[b][4-j].frame != 5 && block[b][4-j].frame != 2) b++;

                    valid = true;
                    for (k in a...b+1)
                        if (block[k][5-j].color != -1) valid = false;

                    if (valid) {
                        for (k in a...b+1) {
                            fallSwap(k, 4-j, k, 5-j);
                            block[k][5-j].y = block[k][4-j].y;
                            block[k][4-j].y = (4-j)*128;

                            block[k][5-j].preFallTimer = 10;
                            block[k][5-j].fallDown = true;
                        }
                        done = false;
                        break;
                    }
                    // find frames 6 and 8, 3 and 5 or 0 and 2
                    // check if all blocks under them are -1
                    // if true, do a fall
                }
            }
        }

        if (!done) fall();
    }

    private function fallNew()
    {
        var newBlocks = [0, 0, 0, 0, 0, 0];

        for (i in 0...6) {
            for (j in 0...6) {
                if (block[i][j].color != -1) break;
                newBlocks[i]++;
            }
        }

        for (i in 0...6) {
            for (j in 0...newBlocks[i]) {
                block[i][j].squared = false;
                setColor(i, j, Std.random(3));
                block[i][j].y = -128 - 128*(newBlocks[i] - j);
                block[i][j].preFallTimer = 10;
                block[i][j].fallDown = true;
            }
        }
    }

    public function doneFalling(): Bool
    {
        for (i in 0...6) {
            for (j in 0...6) {
                if (block[i][j].fall) return false;
            }
        }
        return true;
    }

    public function update()
    {
        for (i in 0...6)
            for (j in 0...6)
                block[i][j].update();
    }
}