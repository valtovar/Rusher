package idv.cjcat.rusher.action 
{
  import flash.utils.Dictionary;
  import idv.cjcat.rusher.data.InList;
  import idv.cjcat.rusher.data.InListIterator;
  import idv.cjcat.rusher.engine.RusherObject;
	
  public final class ActionList extends Action
  {
    private var size_:int = 0;
    private var lanes_:Dictionary = new Dictionary();
    
    public function size():int { return size_; }
    
    private var autoComplete_:Boolean;
    public function ActionList(autoComplete:Boolean = true)
    {
      autoComplete_ = autoComplete;
      
      onCancelled.add(cancelSubactions);
    }
    
    public function pushBack(action:Action, laneID:int = 0):void
    {
      getLane(laneID).pushBack(action);
      action.laneID_ = laneID;
      ++size_;
    }
    
    public function pushFront(action:Action, laneID:int = 0):void
    {
      getLane(laneID).pushFront(action);
      action.laneID_ = laneID;
      ++size_;
    }
    
    private function injectDependency(action:Action):void
    {
      action.parent_ = this;
      action.setInjector(getInjector());
      getInjector().injectInto(action);
    }
    
    override public function update(dt:Number):void
    {
      if (isPaused() || isCompleted()) return;
      
      //iterate through all lanes
      for (var key:* in lanes_)
      {
        var group:InList = lanes_[key];
        
        //empty lane, remove and continue
        if (group.size() == 0)
        {
          delete lanes_[key];
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
              //set iterator & lane ID (key)
              injectDependency(action);
              
              action.onStarted.dispatch();
              action.isStarted_ = true;
              
              //action cancelled or completed after init, remove and continue
              if (action.isCompleted())
              {
                iter.remove();
                --size_;
                continue;
              }
              
              //action does not update instantly after init if it's not completed, continue
              if (!action.instantUpdate_) continue;
            }
            
            //update action
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
      
      if (size_ == 0 && autoComplete_) complete();
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
      for (var key:* in lanes_)
      {
        var group:InList = lanes_[key];
        var action:Action;
        var iter:InListIterator = group.getIterator();
        
        while (action = iter.data())
        {
          if (!action.isCompleted()) action.cancel();
          iter.next();
        }
        
        delete lanes_[key];
      }
    }
    
    private function getLane(laneID:int):InList
    {
      var lane:InList;
      
      //create group if non-existent
      if (!(lane = lanes_[laneID])) lanes_[laneID] = lane = new InList();
      
      return lane;
    }
  }
}