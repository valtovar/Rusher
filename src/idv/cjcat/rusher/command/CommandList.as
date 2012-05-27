package idv.cjcat.rusher.command 
{
    import flash.utils.Dictionary;
	import idv.cjcat.rusher.utils.ObjectPool;
    internal class CommandList 
    {
        
        internal var size:int = 0;
        
        //(key, value) = (command, node);
        private var _commandNodeMap:Dictionary = new Dictionary();
        
        internal var first:CommandNode;
        internal var last:CommandNode;
    
    private var _nodePool:ObjectPool;
        
        public function CommandList() 
        {
            _nodePool = new ObjectPool(CommandNode);
        }
        
        internal function add(command:Command):void
        {
            var node:CommandNode = _nodePool.get();
            node.command = command;
            
            if (first)
            {
                last.next = node;
                node.prev = last;
            }
            else
            {
                //special case: collection empty
                first = node;
            }
            
            ++size;
            last = node;
            
            //store mapping
            _commandNodeMap[command] = node;
            
            //listen to complete event
            command.onComplete.addOnce(remove);
            
            //execute command
            command.execute();
        }
        
        internal function remove(command:Command):void
        {
            var node:CommandNode = _commandNodeMap[command];
            
            //node not found
            if (!node) return;
            
            if (node.prev) {
                node.prev.next = node.next;
            }
            else
            {
                //special case: removing first node
                first = node.next;
            }
            
            if (node.next)
            {
                node.next.prev = node.prev;
            }
            else
            {
                //special case: removing last node
                last = node.prev;
            }
            
            --size;
            
            node.next = null;
            node.prev = null;
            
            //recycle node
            _nodePool.recycle(node);
            node.command = null;
            
            //remove mapping
            delete _commandNodeMap[command];
        }
    }
}