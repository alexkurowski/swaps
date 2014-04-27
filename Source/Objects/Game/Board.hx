package objects.game;

import flash.display.Sprite;

class Board extends Sprite
{
    public var block: Array<Array<Block>>;
    
    public function new()
    {
        super();

        y = 400;

        block = [];
        for (i in 0...6) {
            block[i] = [];
            for (j in 0...6) {
                block[i][j] = new Block(i, j, i*128, j*128);
                addChild(block[i][j]);
            }
        }
    }
}