package idv.cjcat.rusher.starling 
{
  import idv.cjcat.rusher.engine.Component;
  import starling.display.BlendMode;
  import starling.display.DisplayObject;
  
  public class StarlingRenderTarget extends Component
  {
    /** @private */
    internal var displayObject_:DisplayObject;
    public function get displayObject():DisplayObject { return displayObject_; }
    public function set displayObject(value:DisplayObject):void
    {
      if (displayObject_ && displayObject_.parent) displayObject_.removeFromParent();
      
      displayObject_ = value;
      
      var renderer:StarlingRenderer = getInstance(StarlingRenderer);
      if (renderer.defaultContainer && displayObject_ && !displayObject_.parent)
      {
        renderer.defaultContainer.addChild(displayObject_);
      }
    }
    
    private var cachedDisplayObject_:DisplayObject;
    public function StarlingRenderTarget(displayObject:DisplayObject = null)
    {
      cachedDisplayObject_ = displayObject;
    }
    
    override public function init():void 
    {
      this.displayObject = cachedDisplayObject_;
      StarlingRenderer(getInstance(StarlingRenderer)).register(this);
    }
    
    override public function dispose():void 
    {
      if (displayObject_ && displayObject_.parent)
      {
        displayObject_.removeFromParent();
      }
      StarlingRenderer(getInstance(StarlingRenderer)).unregister(this);
    }
  }
}