package idv.cjcat.rusher.state 
{
  import idv.cjcat.rusher.data.InList;
  import idv.cjcat.rusher.engine.RusherObject;
  import idv.cjcat.rusher.state.StateMachine;
  
  public class StateMachineCollector extends RusherObject
  {
    /** @private */
    protected var stateMachines_:InList = new InList();
    
    public function StateMachineCollector()
    { }
    
    public function add(stateMachine:StateMachine):void
    {
      stateMachines_.add(stateMachine);
      stateMachine.setInjector(getInjector());
      getInjector().injectInto(stateMachine);
    }
    
    public function remove(stateMachine:StateMachine):void
    {
      stateMachines_.remove(stateMachine);
      stateMachine.setInjector(null);
    }
  }
}