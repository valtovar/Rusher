package rusher.example.mover.engine 
{
  import rusher.action.Action;
  import rusher.action.ActionComponent;
  import rusher.transform.Transform2D;
  import rusher.engine.Engine;
  import rusher.engine.Entity;
  import rusher.example.mover.entity.MoverAction;
  import rusher.example.mover.entity.MoverShape;
  import rusher.render2d.Renderable2D;
	
  public class StartUp extends Action
  {
    //get the engine
    [Inject] public var engine:Engine;
    
    override public function update(dt:Number):void 
    {
      var mover:Entity = engine.createEntity("mover");
      mover.addComponent(ActionComponent, new MoverAction());
      mover.addComponent(Transform2D);
      mover.addComponent(Renderable2D , new MoverShape());
      
      //complete after one update
      complete();
    }
  }
}