package rusher.example.mover.entity 
{
  import flash.display.Stage;
  import rusher.action.Action;
  import rusher.engine.Entity;
  import rusher.transform.Transform2D;
  
  public class BulletAction extends Action
  {
    //get reference to the bullet entity (for self-destruction)
    [Inject] public var self:Entity;
    
    //get the transform component of the same entity of the parent action component
    [Inject] public var transform:Transform2D;
    
    //get the stage instance
    [Inject] public var stage:Stage;
    
    //speed in pixels per second
    private static const SPEED:Number = 500.0;
    
    override public function update(dt:Number):void 
    {
      var directionX:Number = Math.cos(transform.rotation);
      var directionY:Number = Math.sin(transform.rotation);
      
      transform.x += directionX * SPEED * dt;
      transform.y += directionY * SPEED * dt;
      
      //self-destruct when out of bound
      if
      (
        transform.x < -0.6 * stage.stageWidth || transform.x > 0.6 * stage.stageWidth ||
        transform.y < -0.6 * stage.stageHeight || transform.y > 0.6 * stage.stageWidth
      )
      {
        self.destroy();
      }
    }
  }
}
