package idv.cjcat.rusher.clock 
{
    import flash.display.Stage;
    import flash.events.Event;
    import flash.utils.getTimer;
    import idv.cjcat.rusher.core.ISystem;
    import org.osflash.signals.Signal;
	
    /**
     * Clock system.
     */
    public final class Clock extends Signal implements ISystem
    {
        private var _timestamp:int = 0;
        /**
         * Current timestamp in milliseconds.
         */
        public function get timestamp():int { return _timestamp; }
        
        public function Clock()
        {
            super(Number);
        }
        
        private var _stage:Stage;
        
        [Inject]
        public function inject(stage:Stage):void
        {
            _stage = stage;
        }
        
        public function onAdd():void
        {
            _stage.addEventListener(Event.ENTER_FRAME, tick);
        }
        
        public function dispose():void
        {
            _stage.removeEventListener(Event.ENTER_FRAME, tick);
            
            removeAll();
            _stage = null;
        }
        
        private function tick(e:Event):void
        {
            _timestamp = getTimer();
            dispatch(1 / _stage.frameRate);
        }
    }
}