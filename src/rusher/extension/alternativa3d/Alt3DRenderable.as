package rusher.extension.alternativa3d 
{
  import alternativa.engine3d.core.Object3D;
  import alternativa.engine3d.core.Resource;
  import rusher.engine.Component;
  
  public class Alt3DRenderable extends Component
  {
    
    private var registered_:Boolean = false;
    
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
            resource.upload(renderer.stage3D_.context3D);
        }
      }
    }
    
    public function Alt3DRenderable(object:Object3D = null)
    {
      object_ = object;
    }
    
    override public function init():void 
    {
      Alt3DRenderer(getInstance(Alt3DRenderer)).register(this);
      registered_ = true;
    }
    
    override public function dispose():void 
    {
      Alt3DRenderer(getInstance(Alt3DRenderer)).unregister(this);
      registered_ = true;
    }
  }
}
