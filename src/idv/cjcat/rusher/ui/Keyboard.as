package idv.cjcat.rusher.ui 
{
    import flash.display.Stage;
    import flash.events.KeyboardEvent;
    import flash.utils.Dictionary;
    import idv.cjcat.rusher.core.ISystem;
    import idv.cjcat.rusher.clock.Clock;
    
    /**
     * Keyboard system.
     */
    [Inject]
    public final class Keyboard implements ISystem
    {
        private var _downStatus:Array;
        
        /**
         * The pressed and released state are preserved for one clock cycle.
         * The *Status2 dictionaries are for temporarily storing key status.
         */
        private var _pressStatus1:Dictionary;
        private var _pressStatus2:Dictionary;
        private var _releaseStatus1:Dictionary;
        private var _releaseStatus2:Dictionary;
        
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
            return Boolean(_pressStatus2[keyCode]);
        }
        
        /**
         * Whether a key was released between the previous frame and the current frame. 
         * Remains true only for one frame.
         * @param	keyCode
         * @return
         */
        public function isReleased(keyCode:uint):Boolean
        {
            return Boolean(_releaseStatus2[keyCode]);
        }
		
		public function Keyboard()
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
            _downStatus = new Array(256);
            _pressStatus1 = new Dictionary();
            _pressStatus2 = new Dictionary();
            _releaseStatus1 = new Dictionary();
            _releaseStatus2 = new Dictionary();
            
            for (var i:int = 0; i < 256; ++i) _downStatus[i] = false;
            
            _stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, int.MAX_VALUE);
            _stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, int.MAX_VALUE);
            
            _clock.add(update);
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
        
        private function update(dt:Number):void
        {
            //swap press status dictionaries
            var temp:Dictionary;
            temp = _pressStatus1;
            _pressStatus1 = _pressStatus2;
            _pressStatus2 = temp;
            
            //swap up status dictionaries
            temp = _releaseStatus1;
            _releaseStatus1 = _releaseStatus2;
            _releaseStatus2 = temp;
            
            //clear first dictionaries
            var key:*;
            for (key in _pressStatus1) delete _pressStatus1[key];
            for (key in _releaseStatus1) delete _releaseStatus1[key];
        }
        
        public function dispose():void
        {
            _stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            _stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            
            _clock.remove(update);
			
            _stage = null;
            _clock = null;
            
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
    }
}