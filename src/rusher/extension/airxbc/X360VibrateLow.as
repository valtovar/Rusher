package rusher.extension.airxbc 
{
  import rusher.action.Action;
	
  public class X360VibrateLow extends Action
  {
    public var amount      :Number = 0.0;
    public var time        :Number = 0.0;
    public var controllerID:uint = 0;
    
    public function X360VibrateLow(amount:Number, time:Number = -1.0, controllerID:uint = 0) 
    {
      this.amount       = amount      ;
      this.time         = time        ;
      this.controllerID = controllerID;
      
      onStarted .addOnce(init);
      onFinished.addOnce(dispose);
    }
    
    private var input_:X360Input;
    private var timer_:Number = 0.0;
    private function init():void
    {
      input_ = getInstance(X360Input);
      timer_ = time;
    }
    
    private function dispose():void
    {
      input_.setVibrationLow(0.0, controllerID);
    }
    
    override public function update(dt:Number):void 
    {
      input_.setVibrationLow(amount, controllerID);
      if ((timer_ -= dt) <= 0.0) complete();
    }
  }
}
