package idv.cjcat.rusher.core 
{
    internal final class EntityIterator implements IEntityIterator
    {
        private var _collection:EntityList;
        private var _current:EntityNode;
        
        public function EntityIterator(collection:EntityList) 
        {
            _collection = collection;
            _current = _collection.first;
        }
        
        public function begin():void
        {
            _current = _collection.first;
        }
        
        public function hasNext():Boolean
        {
            if (_current) return Boolean(_current._next);
            return false;
        }
        
        public function next():void
        {
            if (_current) _current = _current._next;
            else trace("WARNING: The iterator has reached the end of collection.");
        }
        
        public function end():void
        {
            _current = _collection.last;
        }
        
        public function remove():void
        {
            _collection.remove(_current._entity);
        }
        
        public function current():*
        {
            return (_current)?(_current):(null);
        }
        
        public function dispose():void
        {
            _collection = null;
            _current = null;
        }
    }
}