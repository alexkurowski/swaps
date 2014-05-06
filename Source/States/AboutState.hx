package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

import objects.menu.Button;
import objects.about.*;

class AboutState extends State
{
	private var text: TextField;

	private var okayBtn: Button;

	public function new()
	{
		super();

		name = "AboutState";
	}

	override public function begin()
	{
		text = H.newTextField(0, 60, 768, 60, G.scheme().fg, "center", "SWAPS\n\na game by\nmapi\nSOFT\n\n@mapi_mopi");
		addChild(text);

		addChild(okayBtn = new Button(128, 1000, "OK", G.scheme().color[1], G.scheme().color[2]));
	}

	override public function update()
	{
		okayBtn.update();

		if (okayBtn.isDown()) {
			G.game.setState("menu");
		}
	}
}