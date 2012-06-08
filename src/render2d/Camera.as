package idv.cjcat.rusher.render2d 
{
  import idv.cjcat.rusher.engine.IComponent;
  
  public class Camera implements IComponent
  {
    public var x:Number;
    public var y:Number;
    public var rotation:Number;
    public var focalLength:Number;
    
    public function Camera
    (
      focalLength:Number = 200
    )
    {
      x = y = rotation = 0;
      
      this.focalLength = focalLength;
    }
    
    public function dispose():void
    {
      
    }
  }
}