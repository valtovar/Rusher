package idv.cjcat.rusher.starling 
{
  import idv.cjcat.rusher.component.Transform2D;
  import idv.cjcat.rusher.data.InList;
  import idv.cjcat.rusher.data.InListIterator;
  import idv.cjcat.rusher.engine.System;
  import idv.cjcat.rusher.utils.RusherMath;
  import starling.display.DisplayObject;
  import starling.display.DisplayObjectContainer;
	
  public class StarlingRenderer extends System
  {
    private var targets_:InList = new InList();
    
    /** @private */
    internal function register(target:StarlingRenderTarget):void
    {
      targets_.pushBack(target);
    }
    
    /** @private */
    internal function unregister(target:StarlingRenderTarget):void
    {
      targets_.remove(target);
    }
    
    public var defaultContainer:DisplayObjectContainer;
    public function StarlingRenderer(defaultContainer:DisplayObjectContainer = null)
    {
      this.defaultContainer= defaultContainer;
    }
    
    override public function update(dt:Number):void 
    {
      var iter:InListIterator = targets_.getIterator();
      var target:StarlingRenderTarget;
      while (target = iter.data())
      {
        var displayObject:DisplayObject = target.displayObject;
        if (displayObject)
        {
          var transform:Transform2D = target.getInstance(Transform2D);
          
          //no object-mounting yet
          displayObject.x = transform.x;
          displayObject.y = transform.y;
          displayObject.rotation = RusherMath.DEGREE_TO_RADIAN * transform.rotation;
          displayObject.scaleX = transform.scaleX;
          displayObject.scaleY = transform.scaleY;
        }
        
        iter.next();
      }
    }
  }
}