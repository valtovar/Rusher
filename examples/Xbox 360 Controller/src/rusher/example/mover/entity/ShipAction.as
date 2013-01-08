package rusher.example.mover.entity 
{
  import flash.display.Stage;
  import rusher.action.Action;
  import rusher.action.ActionComponent;
  import rusher.action.ActionSystem;
  import rusher.engine.Engine;
  import rusher.engine.Entity;
  import rusher.extension.airxbc.X360Input;
  import rusher.render2d.Renderable2D;
  import rusher.transform.Transform2D;
  import rusher.utils.RusherMath;
	
  public class ShipAction extends Action
  {
    //get the engine (for creating bullet entities)
    [Inject] public var engine:Engine;
    
    //get the input system
    [Inject] public var input:X360Input;
    
    //get the action system (for adding vibration actions)
    [Inject] public var actions:ActionSystem;
    
    //get the transform component of the same entity of the parent action component
    [Inject] public var transform:Transform2D;
    
    //get the stage instance
    [Inject] public var stage:Stage;
    
    //speed in pixels per second
    private static const SPEED:Number = 300.0;
    
    //max angular velocity in radians per frame
    private static const MAX_ROTATION_SPEED:Number = 0.5;
    
    //dead zone for analog sticks
    private static const DEAD_ZONE:Number = 0.2;
    
    //vibration in seconds
    private static const VIBRATION_TIME:Number = 0.15;
    
    //bullet cool-down time in seconds
    private static const BULLET_COOL_DOWN_TIME:Number = 0.1;
    
    private var bulletCoolDownTimer_:Number = 0.0;
    override public function update(dt:Number):void 
    {
      //movement
      //-----------------------------------------------------------------------
      
      //query analog sticks
      var moveDirectionX:Number =  input.leftStickX();
      var moveDirectionY:Number = -input.leftStickY();
      var aimDirectionX :Number =  input.rightStickX();
      var aimDirectionY :Number = -input.rightStickY();
      
      //calculate movement direction vector
      if (moveDirectionX * moveDirectionX + moveDirectionY * moveDirectionY < DEAD_ZONE * DEAD_ZONE)
      {
        moveDirectionX = 0.0;
        moveDirectionY = 0.0;
      }
      
      //calculate direction vector
      var directionX:Number =  Math.sin(transform.rotation);
      var directionY:Number = -Math.cos(transform.rotation);
      
      //calculate delta rotation (dr)
      var dr:Number = 0.0;
      if (aimDirectionX * aimDirectionX + aimDirectionY * aimDirectionY >= DEAD_ZONE * DEAD_ZONE)
      {
        //normalize aim vector
        var aimLengthInv:Number = 1.0 / Math.sqrt(aimDirectionX * aimDirectionX + aimDirectionY * aimDirectionY);
        aimDirectionX *= aimLengthInv;
        aimDirectionY *= aimLengthInv;
        
        //finally calculate delta rotation
        var dot:Number = RusherMath.clamp(directionX * aimDirectionX + directionY * aimDirectionY, -1.0, 1.0);
        var cross:Number = directionX * aimDirectionY - directionY * aimDirectionX;
        dr = RusherMath.clamp(Math.acos(dot), -MAX_ROTATION_SPEED, MAX_ROTATION_SPEED);
      }
      
      //apply delta transform
      transform.x += moveDirectionX * SPEED * dt;
      transform.y += moveDirectionY * SPEED * dt;
      transform.rotation += RusherMath.sign(cross) * dr;
      
      //bounds
      transform.x = RusherMath.clamp(transform.x, -0.5 * stage.stageWidth , 0.5 * stage.stageWidth );
      transform.y = RusherMath.clamp(transform.y, -0.5 * stage.stageHeight + 40.0, 0.5 * stage.stageHeight - 40.0);
      
      //-----------------------------------------------------------------------
      //end of movement
      
      
      //shooting
      //-----------------------------------------------------------------------
      
      //count down bullet cool-down timer
      if (bulletCoolDownTimer_ > 0.0)
      {
        bulletCoolDownTimer_ -= dt;
      }
      else
      {
        //stop vibration
        input.setVibrationHigh(0.0);
      }
      
      if (input.isDown(X360Input.LT) || input.isDown(X360Input.RT))
      {
        if (bulletCoolDownTimer_ <= 0.0)
        {
          var bullet:Entity = engine.createEntity();
          bullet.addComponent
          (
            Transform2D, 
            transform.x + directionX * 22.0, 
            transform.y + directionY * 22.0, 
            transform.rotation - RusherMath.PI_2
          );
          bullet.addComponent(ActionComponent, new BulletAction());
          bullet.addComponent(Renderable2D, new BulletShape());
          
          //start high-frequency vibration
          input.setVibrationHigh(1.0);
          
          //reset bullet cool-down timer
          bulletCoolDownTimer_ = BULLET_COOL_DOWN_TIME;
        }
      }
      
      //-----------------------------------------------------------------------
      //end of shooting
    }
  }
}