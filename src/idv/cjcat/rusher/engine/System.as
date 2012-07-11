package idv.cjcat.rusher.engine 
{
  
  public class System extends RusherObject implements ISystem
  {
    private var active_:Boolean = true;
    public function get active():Boolean { return active_; }
    public function set active(value:Boolean):void
    {
      active_ = value;
    }
    
    public function init():void
    { }
    
    public function dispose():void
    { }
    
    public function update(dt:Number):void
    { }
  }
}
