package idv.cjcat.rusher.action 
{
  import idv.cjcat.rusher.engine.RusherObject;
	
  public class Action extends RusherObject
  {
    /** @private */
    internal var parent_:ActionGroup = null;
    public function parent():ActionGroup { return parent_; }
    
    private var isBlocking_ :Boolean = false;
    private var isCompleted_:Boolean = false;
    private var isPaused_   :Boolean = false;
    private var isCancelled_:Boolean = false;
    
    public function isBlocking ():Boolean { return isBlocking_;  }
    public function isCompleted():Boolean { return isCompleted_; }
    public function isPaused   ():Boolean { return isPaused_;    }
    public function isCancelled():Boolean { return isCancelled_; }
    
    public function update(dt:Number):void
    { }
    
    protected function onPaused():void
    { }
    
    protected function onResumed():void
    { }
    
    protected function onCancelled():void
    { }
    
    public final function block   ():void { isBlocking_  = true;  }
    public final function unblock ():void { isBlocking_  = false; }
    
    //only the action can complete itself
    protected final function complete():void { isCompleted_ = true;  }
    
    public final function pause():void
    {
      onPaused ();
      isPaused_ = true;
    }
    
    public final function resume():void
    {
      onResumed();
      isPaused_ = false;
    }
    
    public final function cancel():void
    {
      onCancelled();
      isCancelled_ = true;
    }
  }
}