package idv.cjcat.rusher.command 
{
  import idv.cjcat.rusher.engine.RusherObject;
  import org.swiftsuspenders.Injector;
  
  public class Command extends RusherObject
  {
    /** @private */
    internal var isComplete:Boolean;
    
    public function Command()
    { }
    
    public function execute():void
    { }
    
    public function update(dt:Number):void
    { }
    
    protected final function complete():void
    {
      isComplete = true;
    }
  }
}