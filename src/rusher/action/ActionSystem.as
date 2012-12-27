package rusher.action 
{
  import rusher.data.InList;
  import rusher.data.InListIterator;
  import rusher.engine.System;
  
  public class ActionSystem extends System
  {
    private var actions_:ActionList = new ActionList(false);
    private var actionComponents_:InList = new InList();
    
    private var initAction_:Action;
    private var initActionLane_:uint;
    public function ActionSystem(initAction:Action = null, initActionLane:uint = 0)
    {
      initAction_ = initAction;
      initActionLane_ = initActionLane;
    }
    
    public function pushBack(action:Action, laneID:int = 0):ActionSystem
    {
      actions_.pushBack(action, laneID);
      return this;
    }
    
    public function pushFront(action:Action, laneID:int = 0):ActionSystem
    {
      actions_.pushFront(action, laneID);
      return this;
    }
    
    public function cancelLane(laneID:int = 0):ActionSystem
    {
      actions_.cancelLane(laneID);
      return this;
    }
    
    public function pauseLane(laneID:int = 0):ActionSystem
    {
      actions_.pauseLane(laneID);
      return this;
    }
    
    public function resumeLane(laneID:int = 0):ActionSystem
    {
      actions_.resumeLane(laneID);
      return this;
    }
    
    public function blockLane(laneID:int = 0):ActionSystem
    {
      actions_.blockLane(laneID);
      return this;
    }
    
    public function unblockLane(laneID:int = 0):ActionSystem
    {
      actions_.unblockLane(laneID);
      return this;
    }
    
    public function register(actionComponent:ActionComponent):void
    {
      actionComponents_.pushBack(actionComponent);
    }
    
    public function unregister(actionComponent:ActionComponent):void
    {
      actionComponents_.remove(actionComponent);
    }
    
    override public function init():void 
    {
      actions_.setInjector(getInjector());
      
      if (initAction_)
      {
        pushBack(initAction_, initActionLane_);
        initAction_ = null;
      }
    }
    
    override public function dispose():void 
    {
      actions_.cancel();
    }
    
    override public function update(dt:Number):void 
    {
      actions_.update(dt);
      
      var comp:ActionComponent;
      var iter:InListIterator = actionComponents_.getIterator();
      while (comp = iter.data())
      {
        comp.update(dt);
        iter.next();
      }
    }
  }
}