package idv.cjcat.rusher.input 
{
  import flash.display.Stage;
  import flash.events.KeyboardEvent;
  import flash.utils.Dictionary;
  import idv.cjcat.rusher.engine.System;
  
  /**
   * Keyboard system.
   */
  public final class Keyboard extends System
  {
    private var _downStatus:Array = new Array(256);
    
    /**
     * The pressed and released state are preserved for one clock cycle.
     * The *Status2 dictionaries are for temporarily storing key status.
     */
    private var _pressStatus1:Dictionary   = new Dictionary();
    private var _pressStatus2:Dictionary   = new Dictionary();
    private var _releaseStatus1:Dictionary = new Dictionary();
    private var _releaseStatus2:Dictionary = new Dictionary();
    
    private var _stage:Stage = null;
    
		public function Keyboard()
		{ }
    
    /**
     * Whether a key is in the down state. 
     * Always return true if the key is down.
     * @param	keyCode
     * @return
     */
    public function isDown(keyCode:uint):Boolean
    {
      return _downStatus[keyCode];
    }
    
    /**
     * Whether a key was pressed between the previous frame and the current frame. 
     * Remains true only for one frame.
     * @param	keyCode
     * @return
     */
    public function isPressed(keyCode:uint):Boolean
    {
      return Boolean(_pressStatus1[keyCode]);
    }
    
    /**
     * Whether a key was released between the previous frame and the current frame. 
     * Remains true only for one frame.
     * @param	keyCode
     * @return
     */
    public function isReleased(keyCode:uint):Boolean
    {
      return Boolean(_releaseStatus1[keyCode]);
    }
    
    override public function onAdded():void
    {
      _stage = getInstance(Stage);
      
      for (var i:int = 0; i < 256; ++i) _downStatus[i] = false;
      
      _stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, int.MAX_VALUE);
      _stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, int.MAX_VALUE);
    }
    
    override public function onRemoved():void
    {
      _stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      _stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      
      _stage = null;
      
      _downStatus.length = 0;
      _downStatus = null;
      
      var key:*;
      for (key in _pressStatus1) delete _pressStatus1[key];
      for (key in _pressStatus2) delete _pressStatus2[key];
      for (key in _releaseStatus1) delete _releaseStatus1[key];
      for (key in _releaseStatus2) delete _releaseStatus2[key];
      _pressStatus1 = null;
      _pressStatus2 = null;
      _releaseStatus1 = null;
      _releaseStatus2 = null;
    }
    
    override public function update(dt:Number):void
    {
      var temp:Dictionary;
      
      //swap press status dictionaries
      temp = _pressStatus1;
      _pressStatus1 = _pressStatus2;
      _pressStatus2 = temp;
      
      //swap up status dictionaries
      temp = _releaseStatus1;
      _releaseStatus1 = _releaseStatus2;
      _releaseStatus2 = temp;
      
      //clear first dictionaries
      var key:*;
      for (key in _pressStatus2) delete _pressStatus2[key];
      for (key in _releaseStatus2) delete _releaseStatus2[key];
    }
    
    private function onKeyDown(e:KeyboardEvent):void 
    {
      if (!_downStatus[e.keyCode]) _pressStatus2[e.keyCode] = true;
			_downStatus[e.keyCode] = true;
    }
    
    private function onKeyUp(e:KeyboardEvent):void 
    {
      if (_downStatus[e.keyCode]) _releaseStatus2[e.keyCode] = true;
      _downStatus[e.keyCode] = false;
    }
  }
}