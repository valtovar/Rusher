package idv.cjcat.rusher.component 
{
  import idv.cjcat.rusher.data.InList;
  import idv.cjcat.rusher.data.InListIterator;
  import idv.cjcat.rusher.engine.Component;
  import idv.cjcat.rusher.engine.Entity;
  import idv.cjcat.rusher.utils.geom.Vec2D;
	
  public class Transform2D extends Component
  {
    
    //position
    private var localX_ :Number = 0;
    private var globalX_:Number = 0;
    private var localY_ :Number = 0;
    private var globalY_:Number = 0;
    public function get x():Number { return globalX_; }
    public function set x(value:Number)
    {
      globalX_ = localX_ = value;
      updateChildren();
    }
    public function get y():Number { return globalY_; }
    public function set y(value:Number)
    {
      globalY_ = localY_ = value;
      updateChildren();
    }
    
    //rotation
    private var localRotation_ :Number = 0;
    private var globalRotation_:Number = 0;
    public function get rotation():Number { return globalRotation_; }
    public function set rotation(value:Number):void
    {
      globalRotation_ = localRotation_ = value;
      updateChildren();
    }
    
    //scale
    private var localScaleX_ :Number = 0;
    private var globalScaleX_:Number = 0
    private var localScaleY_ :Number = 0;
    private var globalScaleY_:Number = 0;
    public function get scaleX():Number { return globalScaleX_; }
    public function set scaleX(value):Number
    {
      globalScaleX_ = localScaleX_ = value;
      updateChildren();
    }
    public function get scaleY():Number { return globalScaleY_; }
    public function set scaleY(value):Number
    {
      globalScaleY_ = localScaleY_ = value;
      updateChildren();
    }
    
    public function Transform2D
    (
      x:Number = 0, y:Number = 0, 
      rotation:Number = 0, 
      scaleX:Number = 1, scaleY:Number = 1
    )
    {
      this.x = x;
      this.y = y;
      this.rotation = rotation;
      this.scaleX = scaleX;
      this.scaleY = scaleY;
    }
    
    override public function onAdded():void 
    {
      getOwner().onMounted.add(onMounted);
      getOwner().onUnmounted.add(onUnmounted);
    }
    
    override public function onRemoved():void 
    {
      getOwner().onMounted.remove(onMounted);
      getOwner().onUnmounted.remove(onUnmounted);
    }
    
    
    //mounting
    //-------------------------------------------------------------------------
    
    private var children_:InList = new InList();
    
    private function onMounted(child:Entity):void
    {
      children_.add(child.getComponent(Transform2D));
    }
    
    private function onUnmounted(child:Entity):void
    {
      children_.remove(child.getComponent(Transform2D));
    }
    
    private function updateChildren():void
    {
      var iter:InListIterator = children_.getIterator();
      var child:Transform2D;
      while (child = iter.data())
      {
        //TODO: MAAAAAAAAAAAAAAATH
        
        iter.next();
      }
    }
    
    //-------------------------------------------------------------------------
    //end of mounting
  }
}