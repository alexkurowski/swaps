package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

import objects.menu.*;

class MenuState extends State
{
    private var score: TextField;

    private var playBtn: Button;
    // private var continueBtn: Button;

    // public var continuable: Bool;

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

        playBtn = new Button(128, 900, "PLAY");
        addChild(playBtn);

        // continueBtn = new Button(128, 1008, "CONTINUE");
        // continueBtn.visible = false;
        // addChild(continueBtn);

        // continuable = false;
    }

    override public function update()
    {
        playBtn.update();
        // if (continuable) continueBtn.update();

        if (playBtn.isDown()) {
            G.game.setState("game");
            // G.game.gameState.begin();
        }

        // if (continueBtn.isDown()) {
        //     G.game.setState("game");
        // }
    }

    public function set()
    {
        score.text = Std.string(G.score);
        // continueBtn.visible = continuable = cont;
    }
}