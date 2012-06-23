package idv.cjcat.rusher.component 
{
  import flash.geom.Matrix;
  import flash.geom.Point;
  import idv.cjcat.rusher.data.InList;
  import idv.cjcat.rusher.data.InListIterator;
  import idv.cjcat.rusher.engine.Component;
  import idv.cjcat.rusher.engine.Entity;
  import idv.cjcat.rusher.utils.geom.Vec2D;
  import idv.cjcat.rusher.utils.RusherMath;
	
  public class Transform2D extends Component
  {
    private var version_:uint = 1;
    private var matrixVersion_:uint = 0;
    private var matrix_:Matrix = new Matrix();
    
    public var inheritsScale:Boolean = true;
    
    public function calculateMatrix():Matrix {
      var owner:Entity = getInstance(Entity);
      
      //early out
      if (matrixVersion_ == version_ && !owner.getParent()) return matrix_;
      
      //make identity
      matrix_.identity();
      
      //has parent
      if (owner.getParent())
      {
        var parentTransform:Transform2D = owner.getParent().getComponent(Transform2D);
        var parentMatrix:Matrix = parentTransform.calculateMatrix();
        
        //inherits all parent transform
        if (inheritsScale)
        {
          matrix_.scale(scaleX_, scaleY_);
          matrix_.rotate(rotation_ * RusherMath.DEGREE_TO_RADIAN);
          matrix_.translate(x_, y_);
          matrix_.concat(parentMatrix);
        }
        //only inherits parent translation and rotation
        else
        {
          var mountPoint:Point = parentMatrix.transformPoint(new Point(x_, y_));
          
          matrix_.scale(scaleX_, scaleY_);
          matrix_.rotate((rotation_ + parentTransform.rotation_) * RusherMath.DEGREE_TO_RADIAN);
          matrix_.translate(mountPoint.x, mountPoint.y);
        }
      }
      else
      //no parent
      {
        //calculate matrix normally
        matrix_.scale(scaleX_, scaleY_);
        matrix_.rotate(rotation_ * RusherMath.DEGREE_TO_RADIAN);
        matrix_.translate(x_, y_);
      }
      
      matrixVersion_ = version_;
      return matrix_;
    }
    
    //position
    private var x_:Number;
    private var y_:Number;
    public function get x():Number { return x_; }
    public function set x(value:Number):void
    {
      x_ = value;
      ++version_;
    }
    public function get y():Number { return y_; }
    public function set y(value:Number):void
    {
      y_ = value;
      ++version_;
    }
    
    //rotation
    private var rotation_ :Number = 0;
    public function get rotation():Number { return rotation_; }
    public function set rotation(value:Number):void
    {
      rotation_ = value;
      ++version_;
    }
    
    //scale
    private var scaleX_:Number;
    private var scaleY_:Number
    public function get scaleX():Number { return scaleX_; }
    public function set scaleX(value:Number):void
    {
      scaleX_ = value;
      ++version_;
    }
    public function get scaleY():Number { return scaleY_; }
    public function set scaleY(value:Number):void
    {
      scaleY_ = value;
      ++version_;
    }
    
    public function Transform2D
    (
      x:Number = 0.0, y:Number = 0.0, 
      rotation:Number = 0.0, 
      scaleX:Number = 1.0, scaleY:Number = 1.0
    )
    {
      x_ = x;
      y_ = y;
      rotation_ = rotation;
      scaleX_ = scaleX;
      scaleY_ = scaleY;
    }
  }
}