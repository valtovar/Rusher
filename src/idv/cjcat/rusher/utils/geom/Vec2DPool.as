package idv.cjcat.rusher.utils.geom {
	
	internal class Vec2DPool
  {
		
		private static var _vec:Vector.<Vec2D> = Vector.<Vec2D>([new Vec2D()]);
		private static var _position:int = 0;
		
		public static function get(x:Number = 0, y:Number = 0):Vec2D 
    {
			if (_position == _vec.length)
      {
				//expand
				_vec.length <<= 1;
				
				for (var i:int = _position; i < _vec.length; i++)
        {
					_vec[i] = new Vec2D();
				}
			}
			_position++;
			var vec:Vec2D = _vec[_position - 1];
			vec.x = x;
			vec.y = y;
			return vec;
		}
		
		public static function recycle(vec:Vec2D):void
    {
			if (_position == 0) return;
			if (!vec) return;
			
			_vec[_position - 1] = vec;
			if (_position) _position--;
			
			if (_vec.length >= 16)
      {
				
				if (_position < (_vec.length >> 4))
        {
          //constract
					_vec.length >>= 1;
				}
			}
		}
	}
}
