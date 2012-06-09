package idv.cjcat.rusher.state 
{
  import idv.cjcat.rusher.data.InListIterator;
  import idv.cjcat.rusher.engine.Entity;
  import idv.cjcat.rusher.engine.IComponent;
	
  public class StateMachineComponent extends StateMachineCollector implements IComponent
  {
    private var initStates_:Array;
    
    public function StateMachineComponent(...initStates)
    {
      initStates_ = initStates;
    }
    
    public function onAdded():void
    {
      var system:StateMachineSystem = getSystem(StateMachineSystem);
      system.register(this);
      
      for (var i:int = 0, len:int = initStates_.length; i < len; ++i)
      {
        add(new StateMachine(initStates_[i]));
      }
    }
    
    public function onRemoved():void
    {
      var iter:InListIterator = stateMachines_.getIterator();
      var stateMachine:StateMachine;
      while (stateMachine = iter.data())
      {
        stateMachine.dispose();
        iter.next();
      }
      
      var system:StateMachineSystem = getSystem(StateMachineSystem);
      system.unregister(this);
    }
    
    /** @private */
    internal function update(dt:Number):void
    {
      var iter:InListIterator = stateMachines_.getIterator();
      var stateMachine:StateMachine;
      while (stateMachine = iter.data())
      {
        stateMachine.update(dt);
        iter.next();
      }
    }
  }
}