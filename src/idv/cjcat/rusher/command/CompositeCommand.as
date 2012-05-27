package idv.cjcat.rusher.command 
{
    import org.swiftsuspenders.Injector;
    
    internal class CompositeCommand extends Command
    {
        internal var childrenCommands:Array = [];
        
        public function CompositeCommand(commands:Array) 
        {
            for (var i:int = 0, len:int = commands.length; i < len; ++i)
            {
                append(commands[i]);
            }
        }
        
        internal var commandManager:CommandManager;
        [Inject]
        public function injectManager(commandManager:CommandManager):void
        {
            this.commandManager = commandManager;
        }
        
        
        public function append(command:Command):void
        {
            childrenCommands.push(command);
        }
        
        override final internal function injectChildren(injector:Injector):void 
        {
            for (var i:int = 0, len:int = childrenCommands.length; i < len; ++i)
            {
                var command:Command = childrenCommands[i];
                injector.injectInto(command);
                command.injectChildren(injector);
            }
        }
    }
}