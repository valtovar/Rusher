package idv.cjcat.rusher.command 
{
	
    internal class CommandNode 
    {
        internal var command:Command;
        
        internal var next:CommandNode;
        internal var prev:CommandNode;
        
        public function CommandNode() 
        {
            this.command = command;
        }
    }
}