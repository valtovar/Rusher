package rusher.example.mover.entity 
{
  import flash.display.Stage;
  import rusher.action.Action;
  import rusher.transform.Transform2D;
  import rusher.input.Input;
  import rusher.input.Key;
  import rusher.utils.RusherMath;
	
  public class MoverAction extends Action
  {
    //get the input system
    [Inject] public var input:Input;
    
    //get the transform component of the same entity of the parent action component
    [Inject] public var transform:Transform2D;
    
    //get the stage instance
    [Inject] public var stage:Stage;
    
    //speed in pixels per second
    private static const SPEED:Number = 300.0;
    
    override public function update(dt:Number):void 
    {
      var dx:Number = 0.0;
      var dy:Number = 0.0;
      
      if (input.isDown(Key.LEFT )) dx -= SPEED;
      if (input.isDown(Key.RIGHT)) dx += SPEED;
      if (input.isDown(Key.UP   )) dy -= SPEED;
      if (input.isDown(Key.DOWN )) dy += SPEED;
      
      if (dx != 0.0 && dy != 0.0)
      {
        dx *= Math.SQRT1_2;
        dy *= Math.SQRT1_2;
      }
      
      if (dx != 0.0 || dy != 0.0)
      {
        transform.rotation = Math.atan2(dy, dx) + RusherMath.PI_2;
      }
      
      transform.x += dx * dt;
      transform.y += dy * dt;
      
      //bounds
      transform.x = RusherMath.clamp(transform.x, -0.5 * stage.stageWidth , 0.5 * stage.stageWidth );
      transform.y = RusherMath.clamp(transform.y, -0.5 * stage.stageHeight + 40.0, 0.5 * stage.stageHeight - 40.0);
    }
  }
}