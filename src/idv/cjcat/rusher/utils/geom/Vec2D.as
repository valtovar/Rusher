package idv.cjcat.rusher.utils.geom {
    import idv.cjcat.rusher.utils.RusherMath;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
	
	/**
	 * 2D Vector with common vector operations.
	 */
	public final class Vec2D {
		
		
		//signals
		//------------------------------------------------------------------------------------------------
		
		private var _onChange:ISignal = new Signal(Vec2D);
		/**
		 * Signature: (vector:Vec2D)
		 */
		public function get onChange():ISignal { return _onChange; }
		
		//------------------------------------------------------------------------------------------------
		//end of signals
		
		
		private var _x:Number;
		private var _y:Number;
		
		public function Vec2D(x:Number = 0, y:Number = 0)
    {
			_x = x;
			_y = y;
		}
		
		public function get x():Number { return _x; }
		public function set x(value:Number):void
    {
			_x = value;
			onChange.dispatch(this);
		}
		
		public function get y():Number { return _y; }
		public function set y(value:Number):void
    {
			_y = value;
			onChange.dispatch(this);
		}
		
		public function clone():Vec2D
    {
			return new Vec2D(_x, _y);
		}
		
		/**
		 * Dot product.
		 * @param	vector
		 * @return
		 */
		public function dot(vector:Vec2D):Number
    {
			return (_x * vector._x) + (_y * vector._y);
		}
		
		/**
		 * Vector projection.
		 * @param	target
		 * @return
		 */
		public function project(target:Vec2D):Vec2D
    {
			var temp:Vec2D = clone();
			temp.projectThis(target);
			return temp;
		}
		
		public function projectThis(target:Vec2D):void
    {
			var temp:Vec2D = Vec2DPool.get(target._x, target._y);
			temp.length = 1;
			temp.length = dot(temp);
			_x = temp._x;
			_y = temp._y;
			Vec2DPool.recycle(temp);
		}
		
		/**
		 * Rotates a clone of the vector.
		 * @param	angle
		 * @param	useRadian
		 * @return The rotated clone vector.
		 */
		public function rotate(angle:Number, useRadian:Boolean = false):Vec2D
    {
			var temp:Vec2D = new Vec2D(_x, _y);
			temp.rotateThis(angle, useRadian);
			return temp;
		}
		
		/**
		 * Rotates the vector.
		 * @param	angle
		 * @param	useRadian
		 */
		public function rotateThis(angle:Number, useRadian:Boolean = false):void
    {
			if (!useRadian) angle = angle * RusherMath.DEGREE_TO_RADIAN;
			var originalX:Number = _x;
			_x = originalX * Math.cos(angle) - _y * Math.sin(angle);
			_y = originalX * Math.sin(angle) + _y * Math.cos(angle);
			
			onChange.dispatch(this);
		}
		
		/**
		 * Unit vector.
		 * @return
		 */
		public function unitVec():Vec2D
    {
			if (length == 0) return new Vec2D();
			var length_inv:Number = 1 / length;
			return new Vec2D(_x * length_inv, _y * length_inv);
		}
		
		/**
		 * Vector length.
		 */
		public function get length():Number
    {
			return Math.sqrt(_x * _x + _y * _y);
		}
		public function set length(value:Number):void
    {
			if ((_x == 0) && (_y == 0)) return;
			var factor:Number = value / length;
			
			_x = _x * factor;
			_y = _y * factor;
			
			onChange.dispatch(this);
		}
		
		/**
		 * Sets the vector's both components at once.
		 * @param	x
		 * @param	y
		 */
		public function set(x:Number, y:Number):void
    {
			_x = x;
			_y = y;
			
			onChange.dispatch(this);
		}
		
		/**
		 * The angle between the vector and the positive x axis in degrees.
		 */
		public function get angle():Number { return Math.atan2(_y, _x) * RusherMath.RADIAN_TO_DEGREE; }
		public function set angle(value:Number):void
    {
			var originalLength:Number = length;
			var rad:Number = value * RusherMath.DEGREE_TO_RADIAN;
			_x = originalLength * Math.cos(rad);
			_y = originalLength * Math.sin(rad);
			onChange.dispatch(this);
		}
		
		public function toString():String
    {
			return "[Vec2D" + " x=" + _x + " y=" + _y + "]";
		}
	}
}