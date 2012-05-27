package idv.cjcat.rusher.utils 
{
	public class ObjectPool 
	{
        private var _ObjectClass:Class;
        private var _objects:Array;
        private var _firstEmptyIndex:uint;
        
        public function ObjectPool(ObjectClass:Class) 
        {
            _ObjectClass = ObjectClass;
            _objects = [new _ObjectClass()];
            _firstEmptyIndex = 0;
        }
        
        public function get():*
        {
            if (_firstEmptyIndex > 0)
            {
            --_firstEmptyIndex;
            var obj:* = _objects[_firstEmptyIndex];
            _ObjectClass[_firstEmptyIndex] = null;
            
            return obj;
            }
            return new _ObjectClass();
        }
        
        public function recycle(object:*):void
        {
            _objects[_firstEmptyIndex++] = object;
            
            //expand pool size
            if (_firstEmptyIndex == _objects.length)
            {
                _objects.length <<= 1;
                //trace("expand");
            }
        }
        
        public function clear():void 
        {
            _objects.length = 0;
            _firstEmptyIndex = 0;
        }
	}
}