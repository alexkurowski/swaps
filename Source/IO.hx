package;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.net.SharedObject;

// Input & Output interface
class IO
{
    static public var down: Bool = false;

    static public var pressed: Bool = false;
    static private var _pressed: Bool = false;
    static public var released: Bool = false;
    static private var _released: Bool = false;

    // current touch position
    static public var x: Int = 0;
    static public var y: Int = 0;
    // previous touch position
    static public var _x: Int = 0;
    static public var _y: Int = 0;
    // first touch position
    static public var sx: Int = 0;
    static public var sy: Int = 0;

    static public var key = {BACK: false, OPTION: false, last: -1};

    static private var zoom: Float = 1;
    static private var stateX: Int = 0;
    static private var stateY: Int = 0;

    static public function set()
    {
        Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
        Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, onDown);

        Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
        Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, onUp);

        Lib.current.stage.addEventListener(MouseEvent.CLICK, onClick);
        Lib.current.stage.addEventListener(TouchEvent.TOUCH_TAP, onClick);

        Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
        Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, onMove);

        Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
    }

    static public function setZoom(zoom, stateX, stateY)
    {
        IO.zoom = zoom;
        IO.stateX = Math.floor(stateX);
        IO.stateY = Math.floor(stateY);
    }

    static private function onDown(e: Dynamic)
    {
        down = true;
        pressed = true;
        onMove(e);
        sx = x;
        sy = y;
    }

    static private function onUp(e: Dynamic)
    {
        down = false;
        released = true;
        onMove(e);
    }

    static private function onMove(e: Dynamic)
    {
        x = Math.floor(e.stageX / zoom - stateX / zoom);
        y = Math.floor(e.stageY / zoom - stateY / zoom);
    }

    static private function onClick(e: Dynamic)
    {
        // click = true;
        onMove(e);
    }

    static private function onKeyDown(e: KeyboardEvent)
    {
        //
    }

    static private function onKeyUp(e: KeyboardEvent)
    {
        if (e.keyCode == 27)   key.BACK = true;

        if (e.keyCode == 1668) key.OPTION = true;

        key.last = e.keyCode;
    }

    static public function update()
    {
        if (_pressed) pressed = false;
        if (_released) released = false;
        _pressed = pressed;
        _released = released;

        _x = x;
        _y = y;

        if (key.BACK) key.BACK = false;
        if (key.OPTION) key.OPTION = false;
    }
}