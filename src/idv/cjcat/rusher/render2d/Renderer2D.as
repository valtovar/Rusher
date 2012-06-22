package idv.cjcat.rusher.render2d 
{
  import flash.display.DisplayObject;
  import flash.geom.Transform;
  import idv.cjcat.rusher.component.Transform2D;
  import idv.cjcat.rusher.data.InList;
  import idv.cjcat.rusher.data.InListIterator;
  import idv.cjcat.rusher.engine.System;
	
  public class Renderer2D extends System
  {
    private var targets_:InList = new InList();
    
    /** @private */
    internal function register(target:RenderTarget2D):void
    {
      targets_.pushBack(target);
    }
    
    /** @private */
    internal function unregister(target:RenderTarget2D):void
    {
      targets_.remove(target);
    }
    
    override public function update(dt:Number):void 
    {
      var iter:InListIterator = targets_.getIterator();
      var target:RenderTarget2D;
      while (target = iter.data())
      {
        var displayObject:DisplayObject = target.displayObject;
        if (displayObject)
        {
          var transform:Transform2D = target.getSibling(Transform2D);
          var displayTransform:Transform = displayObject.transform;
          displayTransform.matrix = transform.calculateMatrix();
          displayObject.transform = displayTransform;
        }
        
        iter.next();
      }
    }
  }
}