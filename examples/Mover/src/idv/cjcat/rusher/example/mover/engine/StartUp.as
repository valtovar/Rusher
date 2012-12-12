package idv.cjcat.rusher.example.mover.engine 
{
  import idv.cjcat.rusher.action.Action;
  import idv.cjcat.rusher.action.ActionComponent;
  import idv.cjcat.rusher.component.Transform2D;
  import idv.cjcat.rusher.engine.Engine;
  import idv.cjcat.rusher.engine.Entity;
  import idv.cjcat.rusher.example.mover.entity.MoverAction;
  import idv.cjcat.rusher.example.mover.entity.MoverShape;
  import idv.cjcat.rusher.render2d.Renderable2D;
	
  public class StartUp extends Action
  {
    //get the engine
    [Inject] public var engine:Engine;
    
    override public function update(dt:Number):void 
    {
      var mover:Entity = engine.createEntity("mover");
      mover.addComponent(ActionComponent, new MoverAction());
      mover.addComponent(Renderable2D , new MoverShape());
      
      //complete after one update
      complete();
    }
  }
}