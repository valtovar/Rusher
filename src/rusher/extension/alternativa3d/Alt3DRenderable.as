package rusher.extension.alternativa3d 
{
  import alternativa.engine3d.core.Object3D;
  import alternativa.engine3d.core.Resource;
  import flash.display.Stage;
  import flash.display.Stage3D;
  import rusher.engine.Component;
  import rusher.transform.Transform3D;
  
  public class Alt3DRenderable extends Component
  {
    
    private var registered_:Boolean = false;
    
    private var stage_  :Stage   = null;
    private var stage3D_:Stage3D = null;
    
    /** @private */
    internal var object_:Object3D;
    public function get object():Object3D { return object_; }
    public function set object(value:Object3D):void
    {
      //dispose old resource
      if (registered_ && object_)
      {
        for each (var resource:Resource in object_.getResources(true))
        {
          if (resource.isUploaded)
            resource.dispose();
        }
      }
      
      object_ = value;
    }
    
    public function updateResources():void
    {
      if (registered_ && object_)
      {
        var renderer:Alt3DRenderer = getInstance(Alt3DRenderer);
        for each (var resource:Resource in object_.getResources(true))
        {
          if (!resource.isUploaded)
            resource.upload(stage3D_.context3D);
        }
      }
    }
    
    public function Alt3DRenderable(object:Object3D = null)
    {
      object_ = object;
    }
    
    override public function init():void 
    {
      stage_ = getInstance(Stage);
      stage3D_ = stage_.stage3Ds[0];
      
      Alt3DRenderer(getInstance(Alt3DRenderer)).registerRenderable(this);
      registered_ = true;
    }
    
    override public function dispose():void 
    {
      Alt3DRenderer(getInstance(Alt3DRenderer)).unregisterRenderable(this);
      registered_ = true;
    }
    
    /** @private */
    internal function update(dt:Number):void
    {
      if (object_)
      {
        updateResources();
        
        var transform:Transform3D = getInstance(Transform3D);
        object_.x         = transform.x;
        object_.y         = transform.y;
        object_.z         = transform.z;
        object_.rotationX = transform.rotationX;
        object_.rotationY = transform.rotationY;
        object_.rotationZ = transform.rotationZ;
        object_.scaleX    = transform.scaleX;
        object_.scaleY    = transform.scaleY;
        object_.scaleZ    = transform.scaleZ;
      }
    }
  }
}
