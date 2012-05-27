package idv.cjcat.rusher.command 
{
    import idv.cjcat.rusher.core.ISystem;
    import idv.cjcat.rusher.clock.Clock;
    import org.swiftsuspenders.Injector;
    
    public final class CommandManager implements ISystem
    {
        public function CommandManager()
        {
            
        }
        
        private var _injector:Injector
        private var _clock:Clock
        private var _commands:CommandList;
        [Inject]
        public function inject(injector:Injector, clock:Clock):void
        {
            _injector = injector;
            _clock = clock;
            
            _commands = new CommandList();
        }
        
        public function execute(command:Command):void
        {
            _injector.injectInto(command);
            command.injectChildren(_injector);
            _commands.add(command);
        }
        
        public function onAdd():void
        {
            _clock.add(update);
        }
        
        private function update(dt:Number):void
        {
            var node:CommandNode = _commands.first;
            if (!node) return;
            
            while (node)
            {
                node.command.update(dt);
                node = node.next;
            }
        }
        
        public function dispose():void
        {
            _clock.remove(update);
            
            _injector = null;
            _clock = null;
            
            _commands = null;
        }
    }
}