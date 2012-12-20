package rusher.action.utils 
{
  import rusher.action.Action;
  
  public class Watch extends Action
  {
    private var numActions_:uint = 0;
    private var counter_   :uint = 0;
    
    override public function update(dt:Number):void 
    {
      if (counter_ == numActions_) complete();
    }
    
    public function watch(action:Action):Watch
    {
      ++numActions_;
      action.onFinished.addOnce(incrementCounter);
      return this;
    }
    
    private function incrementCounter():void
    {
      ++counter_;
    }
  }
}
