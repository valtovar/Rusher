package rusher.action.utils 
{
  import rusher.action.Action;
	
  public class WaitFrame extends Action
  {
    private var numFrames_:int = 0;
    
    public function WaitFrame(numFrames:int = 1)
    {
      numFrames_ = numFrames;
    }
    
    override public function update(dt:Number):void 
    {
      if (numFrames_-- >= 0)
        complete();
    }
  }
}
