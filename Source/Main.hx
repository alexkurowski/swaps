package;

import flash.display.Sprite;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import openfl.Assets;
import flash.net.SharedObject;

import states.*;


class Main extends Sprite {
	
	private var state: State;

	public var menuState: MenuState;
	public var gameState: GameState;
	public var infoState: InfoState;

	private var currentState: String;

	private var centerStateX: Int;
	private var centerStateY: Int;

	private var lerpSpeed: Float;

	public var zoom: Float;

	var firstStart: Bool;
	var previousTime: Float;

	public function new () {
		
		super();

		stage.addEventListener(Event.ENTER_FRAME, start);
	}

	private function start(e: Event) {
		stage.removeEventListener(Event.ENTER_FRAME, start);

		load();

		begin();
		
		stage.addEventListener(Event.ENTER_FRAME, update);
		stage.addEventListener(Event.RESIZE, resize);
	}

	public function setState(newState: String)
	{
		currentState = newState;

		resize();
	}

	// load assets and options into the memory
	private function load()
	{
		G.graphics = {};

		// menu
		G.graphics.info = Assets.getBitmapData("assets/img/info.png");
		
		// game
		G.graphics.block = Assets.getBitmapData("assets/img/block.png");

		G.graphics.square = [];
		for (i in 0...9)
			G.graphics.square[i] = Assets.getBitmapData("assets/img/square" + i + ".png");

		G.graphics.face = [];
		G.graphics.face[4] = Assets.getBitmapData("assets/img/face04.png");
		G.graphics.face[6] = Assets.getBitmapData("assets/img/face06.png");
		G.graphics.face[8] = Assets.getBitmapData("assets/img/face08.png");
		G.graphics.face[9] = Assets.getBitmapData("assets/img/face09.png");
		G.graphics.face[10] = Assets.getBitmapData("assets/img/face10.png");
		G.graphics.face[12] = Assets.getBitmapData("assets/img/face12.png");
		G.graphics.face[15] = Assets.getBitmapData("assets/img/face15.png");
		G.graphics.face[16] = Assets.getBitmapData("assets/img/face16.png");
		G.graphics.face[18] = Assets.getBitmapData("assets/img/face18.png");
		G.graphics.face[20] = Assets.getBitmapData("assets/img/face20.png");
		G.graphics.face[24] = Assets.getBitmapData("assets/img/face24.png");
		G.graphics.face[25] = Assets.getBitmapData("assets/img/face25.png");
		G.graphics.face[30] = Assets.getBitmapData("assets/img/face30.png");
		G.graphics.face[36] = Assets.getBitmapData("assets/img/face36.png");

		G.graphics.retry = Assets.getBitmapData("assets/img/retry.png");
		G.graphics.menu = Assets.getBitmapData("assets/img/menu.png");

		// settings
		G.graphics.music = Assets.getBitmapData("assets/img/music.png");
		G.graphics.vibro = Assets.getBitmapData("assets/img/vibro.png");
		

		G.font = Assets.getFont("assets/Bariol_Bold.otf");


		G.colorScheme = [];
		G.colorScheme[0] = {bg: 0xffffff,
							color: [0xf50c5d, 0x8ffe3b, 0x455eff],
							fg: 0x535353};
		G.currentScheme = 0;


		G.file = SharedObject.getLocal("options");
		var needSave: Bool = false;

		if (G.file.data.music == null) {
			G.file.data.music = true;
			needSave = true;
		}

		if (G.file.data.vibro == null) {
			G.file.data.vibro = true;
			needSave = true;
		}

		if (G.file.data.score == null) {
			G.file.data.score = 0;
			needSave = true;
		}

		if (G.file.data.level == null) {
			G.file.data.level = 1;
			needSave = true;
		}

		if (G.file.data.purchased == null) {
			#if android
				G.file.data.purchased = false;
			#else
				G.file.data.purchased = true;
			#end
		}

		if (needSave) {
			try {
				G.file.flush();
			} catch (e: Dynamic) {}
		}

		G.music = G.file.data.music;
		G.vibro = G.file.data.vibro;
		G.score = G.file.data.score;
		G.level = G.file.data.level;
		G.purchased = G.file.data.purchased;
		G.nextScore = G.level * 400;
		G.maxPopsNotPurchased = 20;
	}

	// game's entry point
	private function begin()
	{
		G.game = this;

		lerpSpeed = 0.15;
		centerStateX = 0;

		flash.Lib.stage.opaqueBackground = G.scheme().bg;

		addChild(menuState = new MenuState());
		addChild(gameState = new GameState());
		addChild(infoState = new InfoState());

		setState("menu");

		IO.set();

		previousTime = Lib.getTimer();
	}

	private function resize(?e: Event)
	{
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.quality = flash.display.StageQuality.BEST;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

		var ratioX = Lib.current.stage.stageWidth / 768;
		var ratioY = Lib.current.stage.stageHeight / 1280;
		zoom = Math.min(ratioX, ratioY);

		menuState.scaleX = menuState.scaleY = zoom;
		gameState.scaleX = gameState.scaleY = zoom;
		infoState.scaleX = infoState.scaleY = zoom;

		centerStateX = Std.int(Lib.current.stage.stageWidth / 2 - 768 * zoom / 2);
		
		// menuState.y = gameState.y = settingsState.y = aboutState.y = Lib.current.stage.stageHeight / 2 - 1280 * zoom / 2;
		menuState.y = gameState.y = infoState.y = Lib.current.stage.stageHeight / 2 - 1280 * zoom / 2;

		IO.setZoom(zoom, centerStateX, menuState.y);
	}

	private function update(e: Event)
	{
		menuState.x = H.lerp(menuState.x, (currentState == "menu" ? centerStateX : (currentState == "game" ? centerStateX - 1000 : centerStateX + 1000)), lerpSpeed);
		gameState.x = H.lerp(gameState.x, (currentState == "game" ? centerStateX : centerStateX + 1000), lerpSpeed);
		infoState.x = H.lerp(infoState.x, (currentState == "info" ? centerStateX : centerStateX - 1000), lerpSpeed);

		var currentTime = Lib.getTimer();
		var deltaTime = currentTime - previousTime;
		previousTime = currentTime;

		G.dt = deltaTime * 0.001 * 60;

		IO.touchUpdate();

		if (currentState == "menu") menuState.update();
		if (currentState == "game" && gameState.x == centerStateX) gameState.update();
		if (currentState == "info") infoState.update();

		IO.keyUpdate();
	}

}