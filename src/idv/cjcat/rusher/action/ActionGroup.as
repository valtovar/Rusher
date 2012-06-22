package idv.cjcat.rusher.action 
{
  import flash.utils.Dictionary;
  import idv.cjcat.rusher.data.InList;
  import idv.cjcat.rusher.data.InListIterator;
  import idv.cjcat.rusher.engine.RusherObject;
	
  public final class ActionGroup extends Action
  {
    private var size_:int = 0;
    private var lanes_:Dictionary = new Dictionary();
    
    public function size():int { return size_; }
    
    public function pushBack(laneName:String, ...actions):ActionList
    {
      var lane:InList = getLane(laneName);
      for (var i:int = 0, len:int = actions.length; i < len; ++i)
      {
        var action:Action = actions[i];
        
        action.parent_ = this;
        action.setInjector(getInjector());
        getInjector().injectInto(action);
        
        lane.pushBack(action);
      }
      size_ += actions.length;
    }
    
    public function pushFront(laneName:String, ...actions):ActionList
    {
      var lane:InList = getLane(laneName);
      for (var i:int = actions.length - 1; i >= 0; --i)
      {
        var action:Action = actions[i];
        
        action.parent_ = this;
        action.setInjector(getInjector());
        getInjector().injectInto(action);
        
        lane.pushFront(action);
      }
      size_ += actions.length;
    }
    
    override public function update(dt:Number):void
    {
      if (isPaused() || isCancelled() || isCompleted()) return;
      
      for (var key:* in lanes_)
      {
        var lane:InList = lanes_[key];
        
        //empty lane, remove and continue
        if (lane.size() == 0)
        {
          delete lanes_[key];
          continue;
        }
        
        //iterate through actions in the current lane
        var action:Action;
        var iter:InListIterator = lane.getIterator();
        while (action = iter.data())
        {
          //action cancelled && completed before update, remove
          if (action.isCancelled() || action.isCompleted())
          {
            iter.remove();
            --size_;
            continue;
          }
          
          //action not paused, update
          if (!action.isPaused())
          {
            action.update(dt);
            
            //action cancelled && completed after update, remove
            if (action.isCancelled() || action.isCompleted())
            {
              iter.remove();
              --size_;
              continue;
            }
            else
            {
              //command is blocking, break
              if (action.isBlocking()) break;
            }
          }
        }
      }
    }
    
    override protected function onCancelled():void 
    {
      //cancel all underlying actions
      for (var key:* in lanes_)
      {
        var lane:InList = lanes_[key];
        var action:Action;
        var iter:InListIterator = lane.getIterator();
        
        
      }
    }
    
    private function getLane(laneName:String):InList
    {
      var lane:InList;
      
      //create lane if non-existent
      if (!(lane = lanes_[laneName])) lanes_[laneName] = lane = new InList();
      
      return lane;
    }
  }
}