package rusher.example.mover.engine 
{
  import rusher.action.Action;
  import rusher.action.ActionComponent;
  import rusher.engine.Engine;
  import rusher.engine.Entity;
  import rusher.example.mover.entity.ShipAction;
  import rusher.example.mover.entity.ShipShape;
  import rusher.render2d.Renderable2D;
  import rusher.transform.Transform2D;
	
  public class StartUp extends Action
  {
    //get the engine
    [Inject] public var engine:Engine;
    
    override public function update(dt:Number):void 
    {
      var mover:Entity = engine.createEntity("mover");
      mover.addComponent(ActionComponent, new ShipAction());
      mover.addComponent(Transform2D);
      mover.addComponent(Renderable2D , new ShipShape());
      
      //complete after one update
      complete();
    }
  }
}