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
    }
    
    public function pushBack(action:Action, groupID:int = 0):void
    {
      getGroup(groupID).pushBack(action);
      injectDependency(action, groupID);
      ++size_;
    }
    
    public function pushFront(action:Action, groupID:int = 0):void
    {
      getGroup(groupID).pushFront(action);
      injectDependency(action, groupID);
      ++size_;
    }
    
    private function injectDependency(action:Action, groupID:int):void
    {
      action.parent_ = this;
      action.groupID_ = groupID;
      action.setInjector(getInjector());
      getInjector().injectInto(action);
    }
    
    override public function update(dt:Number):void
    {
      if (isPaused() || isCancelled() || isCompleted()) return;
      
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
          //action cancelled before update, remove and continue
          if (action.isCancelled())
          {
            iter.remove();
            --size_;
            continue;
          }
          
          //action not paused, update
          if (!action.isPaused())
          {
            action.update(dt);
            
            //action cancelled or completed after update, remove and continue
            if (action.isCancelled() || action.isCompleted())
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
    
    override protected function onCancelled():void 
    {
      //cancel all underlying actions
      for (var key:* in groups_)
      {
        var group:InList = groups_[key];
        var action:Action;
        var iter:InListIterator = group.getIterator();
        
        while (action = iter.data())
        {
          if (!action.isCancelled()) action.cancel();
          iter.next();
        }
        
        delete groups_[key];
      }
    }
    
    private function getGroup(groupID:int):InList
    {
      var group:InList;
      
      //create group if non-existent
      if (!(group = groups_[groupID])) groups_[groupID] = group = new InList();
      
      return group;
    }
  }
}