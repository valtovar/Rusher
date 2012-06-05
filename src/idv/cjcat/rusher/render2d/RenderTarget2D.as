package idv.cjcat.rusher.render2d 
{
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import idv.cjcat.rusher.engine.Component;
  
  public class RenderTarget2D extends Component
  {
    /** @private */
    internal var displayObject_:DisplayObject;
    public function get displayObject():DisplayObject { return displayObject_; }
    public function set displayObject(value:DisplayObject):void
    {
      displayObject_ = value;
    }
    
    public function RenderTarget2D(displayObject:DisplayObject = null)
    {
      this.displayObject = displayObject;
    }
    
    override public function onAdded():void 
    {
      Renderer2D(getSystem(Renderer2D)).register(this);
    }
    
    override public function onRemoved():void 
    {
      Renderer2D(getSystem(Renderer2D)).unregister(this);
    }
  }
}