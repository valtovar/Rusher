package idv.cjcat.rusher.action 
{
  import idv.cjcat.rusher.engine.Component;
  
  public class ActionComponent extends Component
  {
    private var actions_:ActionList = new ActionList(false);
    
    private var initAction_:Action;
    private var initActionLane_:uint;
    public function ActionComponent(initAction:Action, initActionLane:uint = 0)
    {
      initAction_ = initAction;
      initActionLane_ = initActionLane;
    }
    
    public function pushBack(action:Action, laneID:int = 0):void
    {
      actions_.pushBack(action, laneID);
    }
    
    public function pushFront(action:Action, laneID:int = 0):void
    {
      actions_.pushFront(action, laneID);
    }
    
    override public function init():void 
    {
      actions_.setInjector(getInjector());
      
      if (initAction_)
      {
        pushBack(initAction_, initActionLane_);
        initAction_ = null;
      }
      
      ActionSystem(getInstance(ActionSystem)).register(this);
    }
    
    override public function dispose():void 
    {
      actions_.cancel();
      
      ActionSystem(getInstance(ActionSystem)).unregister(this);
    }
    
    /** @private */
    internal function update(dt:Number):void 
    {
      actions_.update(dt);
    }
  }
}