package idv.cjcat.rusher.input 
{
  import flash.display.Stage;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.utils.Dictionary;
  import idv.cjcat.rusher.engine.System;
  
  /**
   * Keyboard system.
   */
  public final class Input extends System
  {
    private static const STATUS_SIZE:int = 257;
    private static const MOUSE_KEY_CODE:int = 256;
    
    private var prevDownStatus_ :Vector.<Boolean> = new Vector.<Boolean>(STATUS_SIZE, true);
    private var downStatus_     :Vector.<Boolean> = new Vector.<Boolean>(STATUS_SIZE, true);
    private var pressStatus_    :Vector.<Boolean> = new Vector.<Boolean>(STATUS_SIZE, true);
    private var releasetatus_   :Vector.<Boolean> = new Vector.<Boolean>(STATUS_SIZE, true);
    
    private var mouseX_      :Number = 0;
    private var mouseY_      :Number = 0;
    private var mousePrevX_  :Number = 0;
    private var mousePrevY_  :Number = 0;
    private var mouseDeltaX_ :Number = 0;
    private var mouseDeltaY_ :Number = 0;
    private var mouseWheel_  :Number = 0;
    
    private var stage_:Stage = null;
    
		public function Input()
		{ }
    
    /**
     * Whether a key is in the down state. 
     * Always return true if the key is down.
     * @param	keyCode
     * @return
     */
    public function isDown(keyCode:uint):Boolean
    {
      return downStatus_[keyCode];
    }
    
    /**
     * Whether a key was pressed between the previous frame and the current frame. 
     * Remains true only for one frame.
     * @param	keyCode
     * @return
     */
    public function isPressed(keyCode:uint):Boolean
    {
      return pressStatus_[keyCode];
    }
    
    /**
     * Whether a key was released between the previous frame and the current frame. 
     * Remains true only for one frame.
     * @param	keyCode
     * @return
     */
    public function isReleased(keyCode:uint):Boolean
    {
      return releasetatus_[keyCode];
    }
    
    /**
     * Whether the mouse button is in the down state. 
     * Always return true if the key is down.
     * @return
     */
    public function mouseIsDown():Boolean
    {
      return downStatus_[MOUSE_KEY_CODE];
    }
    
    /**
     * Whether the mouse button was pressed between the previous frame and the current frame. 
     * Remains true only for one frame.
     * @return
     */
    public function mouseIsPressed():Boolean
    {
      return pressStatus_[MOUSE_KEY_CODE];
    }
    
    /**
     * Whether the mouse button was released between the previous frame and the current frame. 
     * Remains true only for one frame.
     * @return
     */
    public function mouseIsReleased():Boolean
    {
      return releasetatus_[MOUSE_KEY_CODE];
    }
    
    public function mouseX()      :Number { return mouseX_;      }
    public function mouseY()      :Number { return mouseY_;      }
    public function mouseDeltaX() :Number { return mouseDeltaX_; }
    public function mouseDeltaY() :Number { return mouseDeltaY_; }
    public function mouseWheel()  :Number { return mouseWheel_;  }
    
    override public function init():void
    {
      stage_ = getInstance(Stage);
      
      //claer all status
      for (var i:int = 0; i < STATUS_SIZE; ++i)
      {
        prevDownStatus_[i] = false;
        downStatus_    [i] = false;
        pressStatus_   [i] = false;
        releasetatus_  [i] = false;
      }
      
      stage_.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown   , false, int.MAX_VALUE);
      stage_.addEventListener(KeyboardEvent.KEY_UP  , onKeyUp     , false, int.MAX_VALUE);
      stage_.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown , false, int.MAX_VALUE);
      stage_.addEventListener(MouseEvent.MOUSE_UP   , onMouseUp   , false, int.MAX_VALUE);
      stage_.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, int.MAX_VALUE);
    }
    
    override public function dispose():void
    {
      stage_.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown   );
      stage_.removeEventListener(KeyboardEvent.KEY_UP  , onKeyUp     );
      stage_.removeEventListener(MouseEvent.MOUSE_DOWN , onMouseDown );
      stage_.removeEventListener(MouseEvent.MOUSE_UP   , onMouseUp   );
      stage_.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
      
      stage_ = null;
      
      prevDownStatus_    = null;
      downStatus_        = null;
      pressStatus_       = null;
      releasetatus_      = null;
    }
    
    override public function update(dt:Number):void
    {
      //update key status
      for (var i:int = 0; i < STATUS_SIZE; ++i)
      {
        //fill in press and release status
        pressStatus_   [i] =  downStatus_[i] && !prevDownStatus_[i];
        releasetatus_  [i] = !downStatus_[i] &&  prevDownStatus_[i];
        
        //copy current status to previous
        prevDownStatus_[i] =  downStatus_[i];
      }
      
      //update mouse status
      mousePrevX_  = mouseX_;
      mousePrevY_  = mouseY_;
      mouseX_      = stage_.mouseX;
      mouseY_      = stage_.mouseY;
      mouseDeltaX_ = mouseX_ - mousePrevX_;
      mouseDeltaY_ = mouseY_ - mousePrevY_;
    }
    
    private function onKeyDown(e:KeyboardEvent):void 
    {
      if (e.keyCode < 0 || e.keyCode >= downStatus_.length) return;
			downStatus_[e.keyCode] = true;
    }
    
    private function onKeyUp(e:KeyboardEvent):void 
    {
      if (e.keyCode < 0 || e.keyCode >= downStatus_.length) return;
      downStatus_[e.keyCode] = false;
    }
    
    private function onMouseDown(e:MouseEvent):void
    {
      downStatus_[MOUSE_KEY_CODE] = true;
    }
    
    private function onMouseUp(e:MouseEvent):void
    {
      downStatus_[MOUSE_KEY_CODE] = false;
    }
    
    private function onMouseWheel(e:MouseEvent):void
    {
      mouseWheel_ = e.delta;
    }
  }
}