package idv.cjcat.rusher.action 
{
  import idv.cjcat.rusher.engine.RusherObject;
  import org.osflash.signals.ISignal;
  import org.osflash.signals.Signal;
	
  public class Action extends RusherObject
  {
    //signals
    //-------------------------------------------------------------------------
    
    private var onStarted_  :ISignal = new Signal();
    private var onCompleted_:ISignal = new Signal();
    private var onPaused_   :ISignal = new Signal();
    private var onResumed_  :ISignal = new Signal();
    private var onCancelled_:ISignal = new Signal();
    
    public function get onStarted  ():ISignal { return onStarted_  ; }
    public function get onCompleted():ISignal { return onCompleted_; }
    public function get onPaused   ():ISignal { return onPaused_   ; }
    public function get onResumed  ():ISignal { return onResumed_  ; }
    public function get onCancelled():ISignal { return onCancelled_; }
    
    //-------------------------------------------------------------------------
    //end of signals
    
    
    /** @private */
    internal var parent_:ActionList = null;
    public function getParent():ActionList { return parent_; }
    
    /** @private */
    internal var laneID_:int = 0;
    public function laneID():int { return laneID_; }
    
    /** @private */
    internal var isStarted_  :Boolean = false;
    
    private var isBlocking_  :Boolean = false;
    private var isCompleted_ :Boolean = false;
    private var isPaused_    :Boolean = false;
    
    public function isStarted  ():Boolean { return isStarted_  ; }
    public function isBlocking ():Boolean { return isBlocking_ ; }
    public function isCompleted():Boolean { return isCompleted_; }
    public function isPaused   ():Boolean { return isPaused_;    }
    
    public function update(dt:Number):void
    { }
    
    public final function block   ():void { isBlocking_  = true;  }
    public final function unblock ():void { isBlocking_  = false; }
    
    //only the action can complete itself
    protected final function complete():void
    {
      isCompleted_ = true;
      onCompleted.dispatch();
    }
    
    public final function pause():void
    {
      isPaused_ = true;
      onPaused.dispatch();
    }
    
    public final function resume():void
    {
      isPaused_ = false;
      onResumed.dispatch();
    }
    
    public final function cancel():void
    {
      onCancelled.dispatch();
      complete();
    }
  }
}