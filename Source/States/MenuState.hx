package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

import objects.menu.*;

class MenuState extends State
{
    private var info: Bitmap;

    private var swaps: TextField;

    private var score: TextField;
    private var arrow: TextField;
    private var author: TextField;

    private var showInfo: Bool;
    private var infoTimer: Int;

    private var musicBtn: ToggleButton;
    private var vibroBtn: ToggleButton;

    private var fadeDelay: Int;
    private var fadeSpeed: Float;

    private var sx: Int;
    private var ox: Float;

    public function new()
    {
        super();

        name = "MenuState";
    }

    override private function begin()
    {
        // info = new Bitmap(G.graphics.info);
        // info.smoothing = true;
        // info.x = 768/2 - info.width/2;
        // info.y = 10;
        // info.alpha = 0.25;
        // info.bitmapData.colorTransform(info.bitmapData.rect, H.recolor(G.scheme().fg));
        // addChild(info);

        // showInfo = false;

        addChild(musicBtn = new ToggleButton(50, 10, "music", G.music));
        // addChild(vibroBtn = new ToggleButton(180, 10, "vibro", G.vibro)).alpha = 0;

        addChild(swaps = H.newTextField(0, 226, 768, 200, G.scheme().fg, "center", "SWAPS")).alpha = 0;
        addChild(score = H.newTextField(0, 546, 768, 92, G.scheme().fg, "center", Std.string(G.score)));
        addChild(arrow = H.newTextField(20, 546, 728, 86, G.scheme().fg, "right", ">")).alpha = 0;

        addChild(author = H.newTextField(0, 1220, 768, 40, G.scheme().fg, "center", "a game by mapisoft")).alpha = 0;

        fadeDelay = 160;
        fadeSpeed = 0.005;
    }

    override public function update()
    {
        if (fadeDelay > 0) fadeDelay--;
        else {
            if (author.alpha < 0.5) author.alpha += fadeSpeed;
            if (swaps.alpha < 0.4) swaps.alpha += fadeSpeed;
            if (arrow.alpha < 0.3) arrow.alpha += fadeSpeed;
        }

        musicBtn.update();
        if (musicBtn.isDown()) {
            G.music = musicBtn.state;
        }

        if (IO.pressed) {
            sx = IO.x;
            ox = x;
        }

        if (IO.down) {
            if (IO.x > sx) sx = IO.x;
            x = ox - (sx - IO.x) * scaleX;
        }

        if (IO.released) {
            // x = ox;
            if (sx - IO.x > 100) G.game.setState("game");
            else if (sx - IO.x < -100) G.game.setState("info");
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
        // showInfo = false;
        // info.alpha = 0.25;
        // author.alpha = 0;
        // musicBtn.alpha = 0;
        // vibroBtn.alpha = 0;
        fadeDelay = 160;
        author.alpha = 0;
        swaps.alpha = 0;
        arrow.alpha = 0;
        score.text = Std.string(G.score);
    }
}