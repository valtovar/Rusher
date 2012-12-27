package rusher.action 
{
  import rusher.engine.Component;
  
  public class ActionComponent extends Component
  {
    private var actions_:ActionList = new ActionList(false);
    
    private var initAction_:Action;
    private var initActionLane_:uint;
    public function ActionComponent(initAction:Action = null, initActionLane:uint = 0)
    {
      initAction_ = initAction;
      initActionLane_ = initActionLane;
    }
    
    public function pushBack(action:Action, laneID:int = 0):ActionComponent
    {
      actions_.pushBack(action, laneID);
      return this;
    }
    
    public function pushFront(action:Action, laneID:int = 0):ActionComponent
    {
      actions_.pushFront(action, laneID);
      return this;
    }
    
    public function cancelLane(laneID:int = 0):ActionComponent
    {
      actions_.cancelLane(laneID);
      return this;
    }
    
    public function pauseLane(laneID:int = 0):ActionComponent
    {
      actions_.pauseLane(laneID);
      return this;
    }
    
    public function resumeLane(laneID:int = 0):ActionComponent
    {
      actions_.resumeLane(laneID);
      return this;
    }
    
    public function blockLane(laneID:int = 0):ActionComponent
    {
      actions_.blockLane(laneID);
      return this;
    }
    
    public function unblockLane(laneID:int = 0):ActionComponent
    {
      actions_.unblockLane(laneID);
      return this;
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