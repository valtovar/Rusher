package idv.cjcat.rusher.action.greensock
{
  import com.greensock.TweenLite;
  import idv.cjcat.rusher.action.Action;
  
  public class TweenFrom extends Action
  {
    private var target_:Object;
    private var duration_:Number;
    
    private var vars_:Object;
    public function get vars():Object { return vars_; }
    public function set vars(value:Object):void
    {
      if (!value) value = {};
      vars_ = value;
    }
    
    public function TweenFrom(target:Object = null, duration:Number = 0, vars:Object = null)
    {
      if (vars == null) vars = {};
      this.target_ = target;
      this.duration_ = duration;
      this.vars = vars;
    }
    
    private var time_:Number;
    private var tween_:TweenLite;
    override public function update(dt:Number):void 
    {
      if (!tween_) 
      {
        if (!vars) vars = { };
        vars.paused = true;
        tween_ = TweenLite.from(target_, duration_, vars);
        tween_.renderTime(0);
        
        onCancelled.add(tween_.kill);
      }
      else
      {
        time_ += dt;
        tween_.renderTime(time_);
        if (time_ >= duration_) complete();
      }
    }
  }
}