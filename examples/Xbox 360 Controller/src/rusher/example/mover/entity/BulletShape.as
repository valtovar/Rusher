package rusher.example.mover.entity 
{
  import flash.display.Shape;
  
  public class BulletShape extends Shape
  {
    
    public function BulletShape() 
    {
      graphics.lineStyle(2, 0x000000);
      graphics.beginFill(0xFFFFFF);
      graphics.drawCircle(0, 0, 5);
    }
  }
}
