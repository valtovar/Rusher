package idv.cjcat.rusher.action.utils 
{
  import idv.cjcat.rusher.action.Action;
	
  public class Wait extends Action
  {
    private var duration_:Number;
    private var timer_:Number = -1;
    
    public function Wait(duration:Number)
    {
      if (duration <= 0) duration = 0;
      duration_ = duration;
    }
    
    override public function update(dt:Number):void 
    {
      if (timer_ < 0) timer_ = duration_;
      timer_ -= dt;
      if (timer_ <= 0) complete();
    }
  }
}