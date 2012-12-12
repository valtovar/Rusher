package idv.cjcat.rusher.starling 
{
  import idv.cjcat.rusher.data.InList;
  import idv.cjcat.rusher.data.InListIterator;
  import idv.cjcat.rusher.engine.System;
  import idv.cjcat.rusher.engine.Transform2D;
  import starling.display.DisplayObject;
  import starling.display.DisplayObjectContainer;
	
  public class StarlingRenderer extends System
  {
    private var renderables_:InList = new InList();
    
    /** @private */
    internal function register(target:StarlingRenderable):void
    {
      renderables_.pushBack(target);
    }
    
    /** @private */
    internal function unregister(target:StarlingRenderable):void
    {
      renderables_.remove(target);
    }
    
    public var defaultContainer:DisplayObjectContainer;
    public function StarlingRenderer(defaultContainer:DisplayObjectContainer = null)
    {
      this.defaultContainer= defaultContainer;
    }
    
    override public function update(dt:Number):void 
    {
      var iter:InListIterator = renderables_.getIterator();
      var renderable:StarlingRenderable;
      while (renderable = iter.data())
      {
        var displayObject:DisplayObject = renderable.displayObject;
        if (displayObject)
        {
          var transform:Transform2D = renderable.getInstance(Transform2D);
          displayObject.x        = transform.x;
          displayObject.y        = transform.y;
          displayObject.rotation = transform.rotation;
          displayObject.scaleX   = transform.scaleX;
          displayObject.scaleY   = transform.scaleY;
        }
        
        iter.next();
      }
    }
  }
}