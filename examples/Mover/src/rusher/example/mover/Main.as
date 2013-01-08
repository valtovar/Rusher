package rusher.example.mover
{
  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.utils.Dictionary;
  import flash.utils.getTimer;
  import rusher.action.ActionSystem;
  import rusher.engine.Engine;
  import rusher.example.mover.engine.StartUp;
  import rusher.example.RusherExample;
  import rusher.input.Input;
  import rusher.render2d.Renderer2D;
  
  [SWF(width="640", height="480", backgroundColor="#000000", frameRate="60")]
	public class Main extends RusherExample
	{
		private var engine:Engine;
    
		public function Main()
    {
      super("Mover", 0x888080, "Use the ARROW KEYS to move.");
      
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