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
    private var onCancelled_:ISignal = new Signal();
    private var onPaused_   :ISignal = new Signal();
    private var onFinished_ :ISignal = new Signal();
    private var onResumed_  :ISignal = new Signal();
    
    public function get onStarted  ():ISignal { return onStarted_  ; }
    public function get onCompleted():ISignal { return onCompleted_; }
    public function get onCancelled():ISignal { return onCancelled_; }
    public function get onFinished ():ISignal { return onFinished_ ; }
    public function get onPaused   ():ISignal { return onPaused_   ; }
    public function get onResumed  ():ISignal { return onResumed_  ; }
    
    //-------------------------------------------------------------------------
    //end of signals
    
    
    /** @private */
    internal var parent_:ActionList = null;
    public function getParent():ActionList { return parent_; }
    
    /** @private */
    internal var laneID_:int = 0;
    public function laneID():int { return laneID_; }
    
    /** @private */
    internal var instantUpdate_:Boolean;
    
    /** @private */
    internal var isStarted_  :Boolean = false;
    
    private var isBlocking_  :Boolean = false;
    private var isFinished_ :Boolean = false;
    private var isPaused_    :Boolean = false;
    
    public final function isStarted ():Boolean { return isStarted_ ; }
    public final function isBlocking():Boolean { return isBlocking_; }
    public final function isFinished():Boolean { return isFinished_; }
    public final function isPaused  ():Boolean { return isPaused_  ; }
    
    public function update(dt:Number):void
    { }
    
    public final function block   ():Action { isBlocking_  = true;  return this; }
    public final function unblock ():Action { isBlocking_  = false; return this; }
    
    public function Action(instantUpdate:Boolean = false)
    {
      instantUpdate_ = instantUpdate;
    }
    
    //only the action can complete itself
    protected final function complete():void
    {
      isFinished_ = true;
      onCompleted.dispatch();
      onFinished.dispatch();
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
      isFinished_ = true;
      onCancelled.dispatch();
      onFinished.dispatch();
    }
  }
}