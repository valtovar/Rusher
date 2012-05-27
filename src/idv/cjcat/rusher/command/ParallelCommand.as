package idv.cjcat.rusher.command 
{
    public class ParallelCommand extends CompositeCommand
    {
        public function ParallelCommand(...commands) 
        {
            super(commands);
        }
        
        private var _idle:Boolean = true;
        private var _commandCounter:int;
        override public function execute():void
        {
            if (_idle)
            {
                if (childrenCommands.length)
                {
                    _commandCounter = 0;
                    var command:Command;
                    for (var i:int = 0, len:int = childrenCommands.length; i < len; ++i)
                    {
                        command = childrenCommands[i];
                        command.onComplete.addOnce(onCommandComplete);
                        commandManager.execute(command);
                    }
                    _idle = false;
                }
                else
                {
                    //zero command
                    complete();
                }
            }
        }
        
        private function onCommandComplete(command:Command):void
        {
            ++_commandCounter;
            
            if (_commandCounter == childrenCommands.length)
            {
                complete();
                _idle = true;
            }
        }
    }
}