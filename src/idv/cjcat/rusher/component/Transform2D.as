package idv.cjcat.rusher.component 
{
  import idv.cjcat.rusher.engine.Component;
  import idv.cjcat.rusher.utils.geom.Vec2D;
	
  public class Transform2D extends Component
  {
    private var position_:Vec2D = null;
    public function get position():Vec2D { return position_; }
    
    public var rotation:Number = 0;
    
    private var scale_:Vec2D = null;
    public function get scale():Vec2D { return scale_; }
    
    public function Transform2D
    (
      x:Number = 0, y:Number = 0, 
      rotation:Number = 0, 
      scaleX:Number = 1, scaleY:Number = 1
    )
    {
      position_ = new Vec2D(x, y);
      this.rotation = rotation;
      scale_ = new Vec2D(scaleX, scaleY);
    }
  }
}