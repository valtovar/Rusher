package idv.cjcat.rusher.core 
{
    import flash.utils.Dictionary;
    import idv.cjcat.rusher.utils.ObjectPool;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    
    internal class EntityList implements IEntityCollection, IDisposable
    {
        private var _onAdd:ISignal = new Signal(EntityNode);
        public function get onAdd():ISignal { return _onAdd; }
        
        private var _onRemove:ISignal = new Signal(EntityNode);
        public function get onRemove():ISignal { return _onRemove; }
        
        private var _onClear:ISignal = new Signal(IEntityCollection);
        public function get onClear():ISignal { return _onClear; }
        
        private var _size:int = 0;
        public function size():int { return _size; }
        
        //(key, value) = (entity, node);
        private var _entityNodeMap:Dictionary = new Dictionary();
        
        internal var NodeClass:Class;
        internal var first:EntityNode;
        internal var last:EntityNode;
        
        private var _nodePool:ObjectPool;
        
        public function EntityList(NodeClass:Class) 
        {
            this.NodeClass = NodeClass;
            _nodePool = new ObjectPool(NodeClass);
        }
        
        public function hasEntity(entity:IEntity):Boolean
        {
            return Boolean(_entityNodeMap[entity]);
        }
        
        public function getIterator():IEntityIterator
        {
            return new EntityIterator(this);
        }
        
        internal function add(entity:IEntity):void
        {
            if (_entityNodeMap[entity]) return;
            
            var node:EntityNode = _nodePool.get();
            node.injectData(Entity(entity));
            
            if (first)
            {
                last._next = node;
                node._prev = last;
            }
            else
            {
                //special case: collection empty
                first = node;
            }
            
            ++_size;
            last = node;
            
            //store mapping
            _entityNodeMap[entity] = node;
            
            //signal adding
            _onAdd.dispatch(node);
        }
        
        internal function remove(entity:IEntity):void
        {
            var node:EntityNode = _entityNodeMap[entity];
            
            //node not found
            if (!node) return;
            
            if (node._prev) {
                node._prev._next = node._next;
            }
            else
            {
                //special case: removing first node
                first = node._next;
            }
            
            if (node._next)
            {
                node._next._prev = node._prev;
            }
            else
            {
                //special case: removing last node
                last = node._prev;
            }
            
            --_size;
            
            node._next = null;
            node._prev = null;
            
            //remove mapping
            delete _entityNodeMap[entity];
            
            //clean up node
            node._prev = node._next = null;
            node.dispose();
            
            //signal removal
            _onRemove.dispatch(node);
            
            //recycle
            _nodePool.recycle(node);
        }
        
        public function dispose():void
        {
            //dispose all nodes
            var node:EntityNode = first;
            if (node)
            {
                while (node)
                {
                    node.dispose();
                    node = node._next;
                }
            }
            
            _onAdd.removeAll();
            _onAdd = null;
            _onRemove.removeAll();
            _onRemove = null;
            _onClear.removeAll();
            _onClear = null;
            
            NodeClass = null;
            _entityNodeMap = null;
            first = null;
            last = null;
            
            _nodePool.clear();
            _nodePool = null;
        }
    }
}