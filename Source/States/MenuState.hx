package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

import objects.menu.*;

class MenuState extends State
{
    private var score: TextField;

    private var playBtn: Button;
    
    private var aboutIco: Icon;
    private var scoresIco: Icon;
    private var settingsIco: Icon;
    private var messagesIco: Icon;

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

        addChild(playBtn = new Button(128, 900, "PLAY"));

        addChild(settingsIco = new Icon(0, 0, "settings"));
        addChild(scoresIco = new Icon(192, 0, "scores"));
        addChild(aboutIco = new Icon(384, 0, "about"));
        addChild(messagesIco = new Icon(576, 0, "messages"));
    }

    override public function update()
    {
        playBtn.update();

        settingsIco.update();
        scoresIco.update();
        aboutIco.update();
        messagesIco.update();

        if (playBtn.isDown()) {
            G.game.setState("game");
        }

        if (aboutIco.isDown()) {
            trace('about');
        }

        if (scoresIco.isDown()) {
            trace('scores');
        }

        if (settingsIco.isDown()) {
            trace('settings');
        }

        if (messagesIco.isDown()) {
            trace('messages');
        }
    }

    public function set()
    {
        score.text = Std.string(G.score);
        // continueBtn.visible = continuable = cont;
    }
}