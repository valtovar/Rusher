package idv.cjcat.rusher.render2d 
{
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import idv.cjcat.rusher.component.Transform2D;
  import idv.cjcat.rusher.data.InList;
  import idv.cjcat.rusher.data.InListIterator;
  import idv.cjcat.rusher.engine.System;
	
  public class Renderer2D extends System
  {
    private var renderables_:InList = new InList();
    
    /** @private */
    internal function register(target:Renderable2D):void
    {
      renderables_.pushBack(target);
    }
    
    /** @private */
    internal function unregister(target:Renderable2D):void
    {
      renderables_.remove(target);
    }
    
    /** @private */
    internal var defaultContainer_:DisplayObjectContainer;
    public function Renderer2D(defaultContainer:DisplayObjectContainer = null)
    {
      defaultContainer_ = defaultContainer;
    }
    
    override public function update(dt:Number):void 
    {
      var iter:InListIterator = renderables_.getIterator();
      var renderable:Renderable2D;
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
