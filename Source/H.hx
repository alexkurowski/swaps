package;

import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.geom.ColorTransform;

// helper class
class H
{
    static public function lerp(current: Float, dest: Float, speed: Float): Float
    {
        if (current != dest) {
            current = current * (1 - speed) + dest * speed;
            if (Math.abs(current - dest) <= 0.1 * speed) current = dest;
        }
        return current;
    }

    static public function sign(x: Float): Int
    {
        if (x < 0) return -1;
        if (x > 0) return 1;
        return 0;
    }

    static public function randomNot(range: Int, not: Int): Int
    {
        var result: Int;
        do {
            result = Std.random(range);
        } while (result == not);
        return result;
    }


    static public function recolor(color: Int): ColorTransform
    {
        var colorTransform = new ColorTransform();
        colorTransform.color = color;
        colorTransform.redMultiplier = colorTransform.greenMultiplier = colorTransform.blueMultiplier = 1;
        colorTransform.redOffset = -255 + colorTransform.redOffset;
        colorTransform.greenOffset = -255 + colorTransform.greenOffset;
        colorTransform.blueOffset = -255 + colorTransform.blueOffset;
        return colorTransform;
    }

    static public function newTextField(x: Int, y: Int, width: Int, size: Int, color: Int, align: String = "center", text: String = ""): TextField
    {
        var format = new TextFormat(G.font.fontName, size, color);
        switch(align) {
            case "left":
                format.align = TextFormatAlign.LEFT;
            case "center":
                format.align = TextFormatAlign.CENTER;
            case "right":
                format.align = TextFormatAlign.RIGHT;
        }

        var field = new TextField();
        field.x = x;
        field.y = y;
        field.width = width;
        field.height = 1280;
        field.selectable = false;
        field.defaultTextFormat = format;
        field.text = text;

        return field;
    }
}