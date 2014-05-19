package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

import objects.menu.*;

class MenuState extends State
{
    private var info: Bitmap;

    private var swaps: Bitmap;

    private var score: TextField;
    private var arrowRight: TextField;
    private var arrowLeft: TextField;
    private var author: TextField;

    private var showInfo: Bool;
    private var infoTimer: Int;

    private var musicBtn: ToggleButton;

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
        // addChild(musicBtn = new ToggleButton(50, 10, "music", G.music));
        
        addChild(swaps = new Bitmap(G.graphics.logo)).y = 220;
        swaps.smoothing = true;
        swaps.bitmapData.colorTransform(swaps.bitmapData.rect, H.recolor(G.scheme().fg));
        swaps.alpha = 0;
        addChild(score = H.newTextField(0, 548, 768, 92, G.scheme().fg, "center", Std.string(G.score)));
        addChild(arrowRight = H.newTextField(20, 548, 728, 86, G.scheme().fg, "right", ">")).alpha = 0;
        addChild(arrowLeft = H.newTextField(20, 548, 728, 86, G.scheme().fg, "left", "<")).alpha = 0;

        // addChild(new Bitmap(new flash.display.BitmapData(768, 384, false, 0x80888888))).y = 700;

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
            if (arrowRight.alpha < 0.3) arrowRight.alpha += fadeSpeed;
            if (arrowLeft.alpha < 0.3) arrowLeft.alpha += fadeSpeed;
        }

        // musicBtn.update();
        // if (musicBtn.isDown()) {
        //     G.music = musicBtn.state;
        // }

        if (IO.pressed) {
            sx = IO.x;
            ox = x;
        }

        if (IO.down) {
            x = ox - (sx - IO.x) * scaleX;
        }

        if (IO.released) {
            if (G.file.data.music != G.music) save();
            if (sx - IO.x > 100) G.game.setState("game");
            else if (sx - IO.x < -100) G.game.setState("info");
        }
    }

    private function save()
    {
        G.file.data.music = G.music;
        // color scheme here
        try {
            G.file.flush();
        } catch (e: Dynamic) {}
    }

    public function set()
    {
        fadeDelay = 160;
        author.alpha = 0;
        swaps.alpha = 0;
        arrowRight.alpha = 0;
        arrowLeft.alpha = 0;
        score.text = Std.string(G.score);
    }
}