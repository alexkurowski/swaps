package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

import objects.menu.*;

class InfoState extends State
{
    private var musicBtn: ToggleButton;
    private var vibroBtn: ToggleButton;

    private var author: TextField;

    public function new ()
    {
        super();

        name = "InfoState";
    }

    override public function begin()
    {
        addChild(musicBtn = new ToggleButton(384 - 120 - 64, 100, "music", G.music));
        addChild(vibroBtn = new ToggleButton(384 + 120, 100, "vibro", G.vibro));

        author = H.newTextField(0, 1220, 768, 40, G.scheme().fg, "center", "a game by mapisoft");
        author.alpha = 0.5;
        addChild(author);
    }

    override public function update()
    {
        musicBtn.update();
        vibroBtn.update();
    }
}