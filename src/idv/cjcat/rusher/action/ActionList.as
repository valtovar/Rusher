package idv.cjcat.rusher.action 
{
  import flash.utils.Dictionary;
  import idv.cjcat.rusher.data.InList;
  import idv.cjcat.rusher.data.InListIterator;
  import idv.cjcat.rusher.engine.RusherObject;
	
  public final class ActionList extends Action
  {
    private var size_:int = 0;
    private var groups_:Dictionary = new Dictionary();
    
    public function size():int { return size_; }
    
    private var autoComplete_:Boolean;
    public function ActionList(autoComplete:Boolean = true)
    {
      autoComplete_ = autoComplete;
      
      onCancelled.add(cancelSubactions);
    }
    
    public function pushBack(action:Action, laneID:int = 0):void
    {
      getGroup(laneID).pushBack(action);
      action.laneID_ = laneID;
      injectDependency(action, laneID);
      ++size_;
    }
    
    public function pushFront(action:Action, laneID:int = 0):void
    {
      getGroup(laneID).pushFront(action);
      action.laneID_ = laneID;
      injectDependency(action, laneID);
      ++size_;
    }
    
    private function injectDependency(action:Action, laneID:int):void
    {
      action.parent_ = this;
      action.laneID_ = laneID;
      action.setInjector(getInjector());
      getInjector().injectInto(action);
    }
    
    override public function update(dt:Number):void
    {
      if (isPaused() || isCompleted()) return;
      
      //iterate through all lanes
      for (var key:* in groups_)
      {
        var group:InList = groups_[key];
        
        //empty lane, remove and continue
        if (group.size() == 0)
        {
          delete groups_[key];
          continue;
        }
        
        //iterate through actions in the current group
        var action:Action;
        var iter:InListIterator = group.getIterator();
        while (action = iter.data())
        {
          //action completed before update, remove and continue
          if (action.isCompleted())
          {
            iter.remove();
            --size_;
            continue;
          }
          
          //action not paused, update
          if (!action.isPaused())
          {
            //first update, call onStarted()
            if (!action.isStarted_) 
            {
              action.onStarted.dispatch();
              action.isStarted_ = true;
            }
            
            action.update(dt);
            
            //action cancelled or completed after update, remove and continue
            if (action.isCompleted())
            {
              iter.remove();
              --size_;
              continue;
            }
          }
          
          //action is blocking, break
          if (action.isBlocking()) break;
          
          iter.next();
        }
      }
      
      if (autoComplete_) complete();
    }
    
    
    //utility functions
    //-------------------------------------------------------------------------
    
    public static function serial(...actions):ActionList
    {
      var actionList:ActionList = new ActionList(true);
      for (var i:int = 0, len:int = actions.length; i < len; ++i)
      {
        var action:Action = actions[i];
        action.block();
        actionList.pushBack(action);
      }
      return actionList;
    }
    
    public static function parallel(...actions):ActionList
    {
      var actionList:ActionList = new ActionList(true);
      for (var i:int = 0, len:int = actions.length; i < len; ++i)
      {
        var action:Action = actions[i];
        action.unblock();
        actionList.pushBack(action);
      }
      return actionList;
    }
    
    //-------------------------------------------------------------------------
    //end of utility functions
    
    
    private function cancelSubactions():void 
    {
      //cancel all underlying actions
      for (var key:* in groups_)
      {
        var group:InList = groups_[key];
        var action:Action;
        var iter:InListIterator = group.getIterator();
        
        while (action = iter.data())
        {
          if (!action.isCompleted()) action.cancel();
          iter.next();
        }
        
        delete groups_[key];
      }
    }
    
    private function getGroup(laneID:int):InList
    {
      var group:InList;
      
      //create group if non-existent
      if (!(group = groups_[laneID])) groups_[laneID] = group = new InList();
      
      return group;
    }
  }
}