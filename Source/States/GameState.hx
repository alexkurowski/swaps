package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import objects.game.*;
import objects.Background;

class GameState extends State
{
    public var map: Board;

    public function new()
    {
        super();

        name = "GameState";
    }

    override private function begin()
    {
        addChild(new Background(0xffffff));

        map = new Board();
        addChild(map);
    }

    override public function update()
    {

    }
}