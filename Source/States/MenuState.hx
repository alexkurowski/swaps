package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

import objects.menu.*;

class MenuState extends State
{
    private var info: Bitmap;

    private var score: TextField;
    private var author: TextField;

    private var showInfo: Bool;
    private var infoTimer: Int;

    private var musicBtn: ToggleButton;
    private var vibroBtn: ToggleButton;

    private var fadeSpeed: Float;

    public function new()
    {
        super();

        name = "MenuState";
    }

    override private function begin()
    {
        info = new Bitmap(G.graphics.info);
        info.smoothing = true;
        info.x = 768/2 - info.width/2;
        info.y = 10;
        info.alpha = 0.25;
        info.bitmapData.colorTransform(info.bitmapData.rect, H.recolor(G.scheme().fg));
        addChild(info);

        showInfo = false;

        addChild(musicBtn = new ToggleButton(50, 10, "music", G.music)).alpha = 0;
        addChild(vibroBtn = new ToggleButton(180, 10, "vibro", G.vibro)).alpha = 0;

        score = H.newTextField(0, 546, 768, 92, G.scheme().fg, "center", Std.string(G.score));
        addChild(score);

        author = H.newTextField(0, 1220, 768, 40, G.scheme().fg, "center", "a game by mapisoft");
        author.alpha = 0;
        addChild(author);

        fadeSpeed = 0.05;
    }

    override public function update()
    {
        if (showInfo) {
            infoTimer--;
            if (infoTimer <= 0) showInfo = false;

            if (info.alpha > 0) info.alpha -= fadeSpeed;
            if (author.alpha < 0.5) author.alpha += fadeSpeed;
            if (G.music) {
                if (musicBtn.alpha < 1) musicBtn.alpha += fadeSpeed;
            } else {
                if (musicBtn.alpha > 0.6) musicBtn.alpha -= fadeSpeed;
                if (musicBtn.alpha < 0.6) musicBtn.alpha += fadeSpeed;
            }
            if (G.vibro) {
                if (vibroBtn.alpha < 1) vibroBtn.alpha += fadeSpeed;
            } else {
                if (vibroBtn.alpha > 0.6) vibroBtn.alpha -= fadeSpeed;
                if (vibroBtn.alpha < 0.6) vibroBtn.alpha += fadeSpeed;
            }

            updateButtons();
        } else {
            infoTimer = 0;

            if (info.alpha < 0.25) info.alpha += fadeSpeed;
            if (author.alpha > 0) author.alpha -= fadeSpeed*0.5;
            if (musicBtn.alpha > 0) musicBtn.alpha -= fadeSpeed*0.5;
            if (vibroBtn.alpha > 0) vibroBtn.alpha -= fadeSpeed*0.5;
            if (IO.x > 384-64 && IO.x < 384+64 && IO.y < 64 && IO.released) {
                showInfo = true;
                infoTimer = 420;
            }
        }

        if (IO.y > 120 && IO.y < 1160 && IO.released) {
            if (showInfo) {
                save();
            }
            G.game.setState("game");
        }
    }

    private function updateButtons()
    {
        musicBtn.update();
        if (musicBtn.isDown()) {
            G.music = musicBtn.state;
            infoTimer = 420;
        }
        vibroBtn.update();
        if (vibroBtn.isDown()) {
            G.vibro = vibroBtn.state;
            infoTimer = 420;
        }
    }

    private function save()
    {
        G.file.data.music = G.music;
        G.file.data.vibro = G.vibro;
        // color scheme here
        try {
            G.file.flush();
        } catch (e: Dynamic) {}
    }

    public function set()
    {
        showInfo = false;
        info.alpha = 0.25;
        author.alpha = 0;
        musicBtn.alpha = 0;
        vibroBtn.alpha = 0;
        score.text = Std.string(G.score);
    }
}