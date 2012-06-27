package idv.cjcat.rusher.example.mover
{
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.utils.Dictionary;
  import flash.utils.getTimer;
  import idv.cjcat.rusher.action.ActionSystem;
  import idv.cjcat.rusher.engine.Engine;
  import idv.cjcat.rusher.example.mover.engine.StartUp;
  import idv.cjcat.rusher.example.RusherExample;
  import idv.cjcat.rusher.input.Input;
  import idv.cjcat.rusher.render2d.Renderer2D;
  
  [SWF(width="640", height="480", backgroundColor="#000000", frameRate="60")]
	public class Main extends RusherExample
	{
		private var engine:Engine;
    
		public function Main()
    {
      super("Mover");
      
      engine = new Engine(stage);
      
      engine.addSystem(Input);
      engine.addSystem(ActionSystem, new StartUp());
      engine.addSystem(Renderer2D, canvas);
      
      addEventListener(Event.ENTER_FRAME, mainLoop);
    }
    
    private var oldTime:int = 0;
    private function mainLoop(e:Event):void 
    {
      var newTime:int = getTimer();
      var dt:Number = (newTime - oldTime) / 1000.0;
      engine.update(dt);
      oldTime = newTime;
    }
	}
}