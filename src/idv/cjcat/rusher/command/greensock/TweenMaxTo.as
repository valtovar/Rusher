package idv.cjcat.rusher.command.greensock
{
    import com.greensock.TweenMax;
    import idv.cjcat.rusher.command.Command;
    
    public class TweenMaxTo extends Command
    {
            
        public var target:Object;
        public var duration:Number;
        
        private var _vars:Object;
        public function get vars():Object { return _vars; }
        public function set vars(value:Object):void
        {
            if (!value) value = {};
            _vars = value;
        }
        
        public function TweenMaxTo(target:Object = null, duration:Number = 0, vars:Object = null)
        {
            this.target = target;
            this.duration = duration;
            this.vars = vars;
        }
        
        override public function execute():void
        {
            _vars.onComplete = complete;
            TweenMax.to(target, duration, _vars);
        }
    }
}