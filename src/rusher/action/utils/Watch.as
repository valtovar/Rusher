package rusher.action.utils 
{
  import flash.utils.Dictionary;
  import rusher.action.Action;
  
  public class Watch extends Action
  {
    private var numActions_    :uint       = 0;
    private var counter_       :uint       = 0;
    private var watchedActions_:Dictionary = new Dictionary();
    
    public function Watch(...watchedActions)
    {
      for (var i:uint = 0, len:uint = watchedActions.length; i < len; ++i)
      {
        watch(watchedActions[i]);
      }
      onStarted.addOnce(checkWatchedActions);
    }
    
    private function checkWatchedActions():void
    {
      if (counter_ == numActions_) complete();
    }
    
    override public function update(dt:Number):void 
    {
      checkWatchedActions();
    }
    
    public function watch(action:Action):Watch
    {
      if (watchedActions_[action] == undefined)
      {
        ++numActions_;
        action.onFinished.addOnce(incrementCounter);
        watchedActions_[action] = action;
      }
      return this;
    }
    
    private function incrementCounter():void
    {
      ++counter_;
    }
  }
}
