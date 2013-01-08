package rusher.example.mover.entity 
{
  import flash.display.Shape;
  
  public class ShipShape extends Shape
  {
    public function ShipShape()
    {
      graphics.lineStyle(2, 0x000000);
      
      graphics.beginFill(0xFFFFFF);
      graphics.moveTo(  0, -30);
      graphics.lineTo( 15,  20);
      graphics.lineTo(-15,  20);
      graphics.lineTo(  0, -30);
      graphics.endFill();
    }
  }
}
