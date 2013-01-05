package rusher.transform 
{
  import rusher.engine.Component;
  
  public class Transform2D extends Component
  {
    public var x       :Number = 0.0;
    public var y       :Number = 0.0;
    public var rotation:Number = 0.0;
    public var scaleX  :Number = 1.0;
    public var scaleY  :Number = 1.0;
    
    public function Transform2D
    (
      x       :Number = 0.0, 
      y       :Number = 0.0, 
      rotation:Number = 0.0, 
      scaleX  :Number = 1.0, 
      scaleY  :Number = 1.0
    )
    {
      set(x, y, rotation, scaleX, scaleY);
    }
    
    public function set
    (
      x       :Number = 0.0, 
      y       :Number = 0.0, 
      rotation:Number = 0.0, 
      scaleX  :Number = 1.0, 
      scaleY  :Number = 1.0
    ):Transform2D
    {
      return setPosition(x, y).setRotation(rotation).setScale(scaleX, scaleY);
    }
    
    public function setPosition(x:Number, y:Number):Transform2D
    {
      this.x = x;
      this.y = y;
      return this;
    }
    
    public function setRotation(rotation:Number):Transform2D
    {
      this.rotation = rotation;
      return this;
    }
    
    public function setScale(scaleX:Number, scaleY:Number):Transform2D
    {
      this.scaleX = scaleX;
      this.scaleY = scaleY;
      return this;
    }
  }
}