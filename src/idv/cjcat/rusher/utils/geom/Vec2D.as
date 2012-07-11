package idv.cjcat.rusher.utils.geom {
  import idv.cjcat.rusher.utils.ObjectPool;
  import idv.cjcat.rusher.utils.RusherMath;
	
	/**
	 * 2D Vector with common vector operations.
	 */
	public final class Vec2D
  {
    private static const pool_:ObjectPool = new ObjectPool();
    
		private var x_:Number;
		private var y_:Number;
		
		public function Vec2D(x:Number = 0, y:Number = 0)
    {
			x_ = x;
			y_ = y;
		}
		
		public function get x():Number { return x_; }
		public function set x(value:Number):void
    {
			x_ = value;
		}
		
		public function get y():Number { return y_; }
		public function set y(value:Number):void
    {
			y_ = value;
		}
		
		public function clone():Vec2D
    {
			return new Vec2D(x_, y_);
		}
    
		/**
		 * Dot product.
		 * @param	vector
		 * @return
		 */
		public function dot(rhs:Vec2D):Number
    {
			return (x_ * rhs.x_) + (y_ * rhs.y_);
		}
    
    public function add(rhs:Vec2D):Vec2D
    {
      return clone().addThis(rhs);
    }
    public function addThis(rhs:Vec2D):Vec2D
    {
      x_ += rhs.x;
      y_ += rhs.y;
      return this;
    }
    
    public function sub(rhs:Vec2D):Vec2D
    {
      return clone().subThis(rhs);
    }
    public function subThis(rhs:Vec2D):Vec2D
    {
      x_ -= rhs.x;
      y_ -= rhs.y;
      return this;
    }
		
		/**
		 * Vector projection.
		 * @param	target
		 * @return
		 */
		public function project(target:Vec2D):Vec2D
    {
			return clone().projectThis(target);
		}
		public function projectThis(target:Vec2D):Vec2D
    {
			var temp:Vec2D = pool_.get();
      temp.set(target.x_, target.y_).normalize().setLength(this.dot(temp));
			x_ = temp.x_;
			y_ = temp.y_;
			pool_.put(temp);
      return this;
		}
    
    public function reflectThis(target:Vec2D):Vec2D
    {
      var temp:Vec2D = pool_.get();
      temp.set(x_, y_).projectThis(target);
      x_ += 2.0 * (temp.x_ - x_);
      y_ += 2.0 * (temp.y_ - y_);
      pool_.put(temp);
      return this;
    }
		
		/**
		 * Rotates a clone of the vector.
		 * @param	angle
		 * @param	useRadian
		 * @return The rotated clone vector.
		 */
		public function rotate(angle:Number, useRadian:Boolean = false):Vec2D
    {
			return clone().rotateThis(angle, useRadian);
		}
		
		/**
		 * Rotates the vector.
		 * @param	angle
		 * @param	useRadian
     * @return Reference to this vector.
		 */
		public function rotateThis(angle:Number, useRadian:Boolean = false):Vec2D
    {
			if (!useRadian) angle = angle * RusherMath.DEGREE_TO_RADIAN;
			var originalX:Number = x_;
			x_ = originalX * Math.cos(angle) - y_ * Math.sin(angle);
			y_ = originalX * Math.sin(angle) + y_ * Math.cos(angle);
      return this;
		}
		
		/**
		 * Unit vector.
		 * @return
		 */
		public function unitVec():Vec2D
    {
			return clone().normalize();
		}
    
    /**
     * Normalizes this vector.
     * @return Reference to this vector.
     */
    public function normalize():Vec2D
    {
      var length_inv:Number = 1.0 / length();
      x_ *= length_inv;
      y_ *= length_inv;
      return this;
    }
		
		/**
		 * Vector length.
		 */
		public function length():Number
    {
			return Math.sqrt(x_ * x_ + y_ * y_);
		}
		public function setLength(value:Number):Vec2D
    {
			if ((x_ == 0) && (y_ == 0)) return this;
			var factor:Number = value / length();
			
			x_ = x_ * factor;
			y_ = y_ * factor;
      return this;
		}
    public function lengthSQ():Number
    {
      return x_ * x_ + y_ * y_;
    }
		
		/**
		 * Sets the vector's both components at once.
		 * @param	x
		 * @param	y
		 */
		public function set(x:Number, y:Number):Vec2D
    {
			x_ = x;
			y_ = y;
      return this;
		}
		
		/**
		 * The angle between the vector and the positive x axis in degrees.
		 */
		public function angle():Number { return Math.atan2(y_, x_) * RusherMath.RADIAN_TO_DEGREE; }
		public function setAngle(value:Number):Vec2D
    {
			var originalLength:Number = length();
			var rad:Number = value * RusherMath.DEGREE_TO_RADIAN;
			x_ = originalLength * Math.cos(rad);
			y_ = originalLength * Math.sin(rad);
      return this;
		}
		
		public function toString():String
    {
			return "[Vec2D" + " x=" + x_ + " y=" + y_ + "]";
		}
	}
}