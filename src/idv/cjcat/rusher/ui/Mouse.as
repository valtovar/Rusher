package idv.cjcat.rusher.ui 
{
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import idv.cjcat.rusher.core.ISystem;
    import idv.cjcat.rusher.clock.Clock;
    
    /**
     * Mouse system.
     */
    [Inject]
    public final class Mouse implements ISystem
    {
        private var _x:Number = 0;
        private var _y:Number = 0;
        /**
         * Mouse X coordinate in stage coordinate system.
         */
        public function get x():Number { return _x; }
        /**
         * Mouse Y coordinate in stage coordinate system.
         */
        public function get y():Number { return _y; }
        
        private var _prevX:Number = 0;
        private var _prevY:Number = 0;
        private var _dx:Number = 0;
        private var _dy:Number = 0;
        /**
         * Mouse X coordinate difference between the previous and the current frame.
         */
        public function get dx():Number { return _dx; }
        /**
         * Mouse Y coordinate difference between the previous and the current frame.
         */
        public function get dy():Number { return _dy; }
        
        private var _downStatus:Boolean = false;
        
        /**
         * The pressed and released state are preserved for one clock cycle.
         * The *Status2 flags are for temporarily storing key status.
         */
        private var _pressStatus1:Boolean = false;
        private var _pressStatus2:Boolean = false;
        private var _releaseStatus1:Boolean = false;
        private var _releaseStatus2:Boolean = false;
        
        /**
         * Whether the pointer button (usually left mouse button) is in the down state. 
         * Always return true if the pointer button is down.
         */
        public function isDown():Boolean { return _downStatus; }
        /**
         * Whether the pointer button was pressed between the previous frame and the current frame. 
         * Remains true only for one frame.
         */
        public function isPressed():Boolean { return _pressStatus2; }
        /**
         * Whether the pointer button was released between the previous frame and the current frame. 
         * Remains true only for one frame.
         */
        public function isReleased():Boolean { return _releaseStatus2; }
        
        public function Mouse()
        {
            
        }
        
        private var _stage:Stage;
        private var _clock:Clock;
        [Inject]
        public function inject(stage:Stage, clock:Clock):void
        {
            _stage = stage;
            _clock = clock;
        }
        
        public function onAdd():void
        {
            _clock.add(update);
            _stage.addEventListener(MouseEvent.MOUSE_DOWN, onDown, false, int.MAX_VALUE);
            _stage.addEventListener(MouseEvent.MOUSE_UP, onUp, false, int.MAX_VALUE);
        }
        
        private function update(dt:Number):void 
        {
            //record previous position
            _prevX = _x;
            _prevY = _y;
            
            //record current position
            _x = _stage.mouseX;
            _y = _stage.mouseY;
            
            //calculate difference between frames
            _dx = _x - _prevX;
            _dy = _y - _prevY;
            
            //handle initial NaN exceptions when stage starts up
            if (isNaN(_dx)) _dx = 0;
            if (isNaN(_dy)) _dy = 0;
            
            //swap press status flag
            var temp:Boolean;
            temp = _pressStatus1;
            _pressStatus1 = _pressStatus2;
            _pressStatus2 = temp;
            
            //swap up status flag
            temp = _releaseStatus1;
            _releaseStatus1 = _releaseStatus2;
            _releaseStatus2 = temp;
            
            //clear first flags
            _pressStatus1 = false;
            _releaseStatus1 = false;
        }
        
        private function onDown(e:MouseEvent):void 
        {
            if (!_downStatus) _pressStatus2 = true;
            _downStatus = true;
        }
        
        private function onUp(e:MouseEvent):void 
        {
            if (_downStatus) _releaseStatus2 = true;
            _downStatus = false;
        }
        
        public function onRemove():void
        {
            _stage.removeEventListener(Event.ENTER_FRAME, update);
            _stage.removeEventListener(MouseEvent.MOUSE_DOWN, onDown);
            _stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
        }
        
        public function dispose():void
        {
            _clock.remove(update);
            _clock = null;
            
            _stage = null;
        }
    }
}