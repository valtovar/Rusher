package idv.cjcat.rusher.command 
{
    import idv.cjcat.rusher.core.IDisposable;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    import org.swiftsuspenders.Injector;
    
    public class Command implements IDisposable
    {
        private var _onComplete:ISignal = new Signal(Command);
        public function get onComplete():ISignal { return _onComplete; }
        
        public function Command()
        {
            
        }
        
        /**
         * @private
         */
        internal function injectChildren(injector:Injector):void
        {
            
        }
        
        public function execute():void
        {
            
        }
        
        public function update(dt:Number):void
        {
            
        }
        
        public final function complete():void
        {
            onComplete.dispatch(this);
        }
        
        public function dispose():void
        {
            
        }
    }
}