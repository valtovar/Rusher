package idv.cjcat.rusher.state 
{
	import idv.cjcat.rusher.command.Command;
	import idv.cjcat.rusher.command.utils.Dummy;
  import idv.cjcat.rusher.engine.RusherObject;
	
	public class State extends RusherObject
	{
    /** @private */
    internal var stateMachine:StateMachine;
    
    public function State() 
    { }
    
    public function enter():void
    { }
    
    public function update(dt:Number):void
    { }
    
    public function exit():void
    { }
    
    protected final function goto(state:State):void
    {
      stateMachine.setState(state);
    }
	}
}