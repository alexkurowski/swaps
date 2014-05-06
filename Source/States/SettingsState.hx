package states;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.text.TextField;

import objects.menu.*;
import objects.settings.*;

class SettingsState extends State
{
	private var musicBtn: ToggleButton;
	private var vibroBtn: ToggleButton;

	private var buyBtn: Button;

	private var saveBtn: Button;

	private var caption: TextField;
	private var captionTimer: Int;

	private var fadeSpeed: Float;

	public function new()
	{
		super();

		name = "SettingsState";
	}

	override public function begin()
	{
		addChild(musicBtn = new ToggleButton(384-76-164, 555, "music", G.music));
		addChild(vibroBtn = new ToggleButton(384+76, 555, "vibro", G.vibro));

		// if (!G.purchased)
			addChild(buyBtn = new Button(128, 870, "BUY ($0.99)", G.scheme().color[1], G.scheme().color[0]));

		addChild(saveBtn = new Button(128, 1000, "SAVE", G.scheme().color[1], G.scheme().color[2]));

		addChild(caption = H.newTextField(0, 1160, 768, 50, G.scheme().fg));
		captionTimer = 0;

		fadeSpeed = 0.1;
	}

	override public function update()
	{
		musicBtn.update();
		if (musicBtn.isDown()) {
			showCaption('music is ' + (musicBtn.state ? 'on' : 'off'));
			G.music = musicBtn.state;
		}
		vibroBtn.update();
		if (vibroBtn.isDown()) {
			showCaption('vibration is ' + (vibroBtn.state ? 'on' : 'off'));
			G.vibro = vibroBtn.state;
		}

		if (buyBtn != null) buyBtn.update();

		saveBtn.update();

		if (saveBtn.isDown()) {
			save();
			G.game.setState("menu");
		}

		if (captionTimer > 0) {
			captionTimer--;
			if (caption.alpha < 1) caption.alpha += fadeSpeed;
		} else {
			if (caption.alpha > 0) caption.alpha -= fadeSpeed;
		}
	}

	public function reset()
	{
		saveBtn.update();
		caption.alpha = 0;
		captionTimer = 0;
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

	private function showCaption(text: String)
	{
		caption.text = text;
		captionTimer = 240;
	}
}