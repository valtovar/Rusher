package idv.cjcat.rusher.render2d 
{
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import idv.cjcat.rusher.engine.Component;
  
  public class Renderable2D extends Component
  {
    /** @private */
    internal var displayObject_:DisplayObject;
    public function get displayObject():DisplayObject { return displayObject_; }
    public function set displayObject(value:DisplayObject):void
    {
      displayObject_ = value;
    }
    
    public function Renderable2D(displayObject:DisplayObject = null)
    {
      this.displayObject = displayObject;
    }
    
    override public function init():void 
    {
      var renderer:Renderer2D = getInstance(Renderer2D);
      renderer.register(this);
      if (renderer.defaultContainer_ && displayObject_ && !displayObject_.parent)
      {
        renderer.defaultContainer_.addChild(displayObject_);
      }
    }
    
    override public function dispose():void 
    {
      if (displayObject_ && displayObject_.parent)
      {
        displayObject_.parent.removeChild(displayObject_);
      }
      Renderer2D(getInstance(Renderer2D)).unregister(this);
    }
  }
}