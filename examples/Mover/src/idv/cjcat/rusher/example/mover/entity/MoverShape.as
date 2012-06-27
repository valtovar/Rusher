package idv.cjcat.rusher.example.mover.entity 
{
  import flash.display.Shape;
  
  public class MoverShape extends Shape
  {
    public function MoverShape()
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