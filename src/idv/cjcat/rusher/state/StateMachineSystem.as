package idv.cjcat.rusher.state 
{
  import idv.cjcat.rusher.data.InList;
  import idv.cjcat.rusher.data.InListIterator;
  import idv.cjcat.rusher.engine.ISystem;
  
  public class StateMachineSystem extends StateMachineCollector implements ISystem
  {
    private var components_:InList = new InList();
    private var initStates_:Array;
    
    public function StateMachineSystem(...initStates)
    {
      initStates_ = initStates;
    }
    
    public function register(component:StateMachineComponent):void
    {
      components_.pushBack(component);
    }
    
    public function unregister(component:StateMachineComponent):void
    {
      components_.remove(component);
    }
    
    public function onAdded():void
    {
      for (var i:int = 0, len:int = initStates_.length; i < len; ++i)
      {
        add(new StateMachine(new initStates_[i]));
      }
    }
    
    public function onRemoved():void
    {
      var stateMachineIter:InListIterator = stateMachines_.getIterator();
      var stateMachine:StateMachine;
      while (stateMachine = stateMachineIter.data())
      {
        stateMachine.dispose();
        stateMachineIter.next();
      }
    }
    
    public function update(dt:Number):void
    {
      //update engine state machines
      var stateMachineIter:InListIterator = stateMachines_.getIterator();
      var stateMachine:StateMachine;
      while (stateMachine = stateMachineIter.data())
      {
        stateMachine.update(dt);
        stateMachineIter.next();
      }
      
      //update component state machines
      var componentIter:InListIterator = components_.getIterator();
      var component:StateMachineComponent;
      while (component = componentIter.data())
      {
        component.update(dt);
        componentIter.next();
      }
    }
  }
}