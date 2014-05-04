package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

import objects.menu.*;

class MenuState extends State
{
    private var score: TextField;

    private var playBtn: Bitmap;

    public function new()
    {
        super();

        name = "MenuState";
    }

    override private function begin()
    {
        flash.Lib.stage.opaqueBackground = G.scheme().bg;

        score = H.newTextField(0, 540, 768, 92, G.scheme().fg, "center", Std.string(G.score));
        addChild(score);

        // playBtn
    }

    override public function update()
    {

    }
}