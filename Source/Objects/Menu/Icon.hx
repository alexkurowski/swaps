package objects.menu;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

class Icon extends Sprite
{
    private var bmp: Bitmap;
    private var txt: TextField;
    private var image: String;

    private var state: String;

    public function new(x: Int, y: Int, image: String)
    {
        super();

        this.x = x;
        this.y = y;

        this.image = image;

        bmp = new Bitmap();
        bmp.smoothing = true;
        addChild(bmp);

        state = '';
        update();
    }

    public function update()
    {
        var newState: String = 'normal';

        if (IO.x > x && IO.x < x+192 && IO.y > y && IO.y < y + 192) {
            if (IO.down) newState = 'hover';
            if (IO.released) newState = 'down';
        }

        if (state != newState) {
            switch (image) {
                case "about":    bmp.bitmapData = G.graphics.about.clone();
                case "scores":   bmp.bitmapData = G.graphics.scores.clone();
                case "settings": bmp.bitmapData = G.graphics.settings.clone();
                case "messages": bmp.bitmapData = G.graphics.messages.clone();
            }
            switch (newState) {
                case "normal": bmp.bitmapData.colorTransform(bmp.bitmapData.rect, H.recolor(G.scheme().fg));
                case "hover":  bmp.bitmapData.colorTransform(bmp.bitmapData.rect, H.recolor(G.scheme().color[0]));
                case "down":   bmp.bitmapData.colorTransform(bmp.bitmapData.rect, H.recolor(G.scheme().color[0]));
            }
            
            state = newState;
        }
    }

    public function isDown(): Bool
    {
        return state == 'down';
    }
}