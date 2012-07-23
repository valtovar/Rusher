package idv.cjcat.rusher.action.utils 
{
  import idv.cjcat.rusher.action.Action;
	
  public class Invoke extends Action
  {
    public var func:Function;
    public var args:Array;
    
    public function Invoke(func:Function, ...args)
    {
      this.func = func;
      this.args = args;
      
      onStarted.addOnce(init);
    }
    
    private function init():void 
    {
      func.apply(null, args);
      complete();
    }
  }
}
