package rusher.transform 
{
  import rusher.engine.Component;
  
  public class Transform3D extends Component
  {
    public var x        :Number = 0.0;
    public var y        :Number = 0.0;
    public var z        :Number = 0.0;
    public var rotationX:Number = 0.0;
    public var rotationY:Number = 0.0;
    public var rotationZ:Number = 0.0;
    public var scaleX   :Number = 1.0;
    public var scaleY   :Number = 1.0;
    public var scaleZ   :Number = 1.0;
    
    public function Transform3D
    (
      x        :Number = 0.0, 
      y        :Number = 0.0, 
      z        :Number = 0.0, 
      rotationX:Number = 0.0, 
      rotationY:Number = 0.0, 
      rotationZ:Number = 0.0, 
      scaleX   :Number = 1.0, 
      scaleY   :Number = 1.0, 
      scaleZ   :Number = 1.0
    )
    {
      set(x, y, z, rotationX, rotationY, rotationZ, scaleX, scaleY, scaleZ);
    }
    
    public function set
    (
      x        :Number = 0.0, 
      y        :Number = 0.0, 
      z        :Number = 0.0, 
      rotationX:Number = 0.0, 
      rotationY:Number = 0.0, 
      rotationZ:Number = 0.0, 
      scaleX   :Number = 1.0, 
      scaleY   :Number = 1.0, 
      scaleZ   :Number = 1.0
    ):Transform3D
    {
      return setPosition(x, y, z).setRotation(rotationX, rotationY, rotationZ).setScale(scaleX, scaleY, scaleZ);
    }
    
    public function setPosition(x:Number, y:Number, z:Number):Transform3D
    {
      this.x = x;
      this.y = y;
      this.z = z;
      return this;
    }
    
    public function setRotation(rotationX:Number, rotationY:Number, rotationZ:Number):Transform3D
    {
      this.rotationX = rotationX;
      this.rotationY = rotationY;
      this.rotationZ = rotationZ;
      return this;
    }
    
    public function setScale(scaleX:Number, scaleY:Number, scaleZ:Number):Transform3D
    {
      this.scaleX = scaleX;
      this.scaleY = scaleY;
      this.scaleZ = scaleZ;
      return this;
    }
  }
}