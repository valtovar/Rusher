package rusher.extension.alternativa3d 
{
  import alternativa.engine3d.core.Camera3D;
  import alternativa.engine3d.core.Object3D;
  import alternativa.engine3d.core.Resource;
  import flash.display.Stage;
  import flash.display.Stage3D;
  import flash.events.Event;
  import rusher.data.InList;
  import rusher.data.InListIterator;
  import rusher.engine.System;
  import rusher.transform.Transform3D;
  
  public class Alt3DRenderer extends System
  {
    private var camera_     :Alt3DCamera = null;
    private var root_       :Object3D    = null;
    private var renderables_:InList      = new InList();
    
    private var stage_  :Stage   = null;
    
    /** @private */
    internal var stage3D_:Stage3D = null;
    
    /** @private */
    internal function register(target:Alt3DRenderable):void
    {
      renderables_.pushBack(target);
      root_.addChild(target.object_);
    }
    
    /** @private */
    internal function unregister(target:Alt3DRenderable):void
    {
      renderables_.remove(target);
      root_.removeChild(target.object_);
    }
    
    public function setCamera(camera:Alt3DCamera):void
    {
      var resource:Resource;
      
      if (camera_)
      {
        stage_.removeChild(camera_.camera_.view);
        root_.removeChild(camera_.camera_);
      }
      
      camera_ = camera;
      
      if (camera_)
      {
        root_.addChild(camera_.camera_);
        stage_.addChild(camera_.camera_.view);
      }
    }
    
    public function Alt3DRenderer()
    { }
    
    override public function init():void 
    {
      root_ = new Object3D();
      stage_ = getInstance(Stage);
      stage3D_ = stage_.stage3Ds[0];
			stage3D_.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			stage3D_.requestContext3D();
    }
    
    private function onContextCreate(e:Event):void
    {
			stage3D_ = stage_.stage3Ds[0];
    }
    
    override public function update(dt:Number):void 
    {
      if (!stage3D_)
        return;
      
      if (!camera_)
        return;
        
      var iter:InListIterator = renderables_.getIterator();
        
      var renderable:Alt3DRenderable;
      while (renderable = iter.data())
      {
        var object:Object3D = renderable.object_;
        if (object)
        {
          renderable.updateResources();
          
          var transform:Transform3D = renderable.getInstance(Transform3D);
          object.x         = transform.x;
          object.y         = transform.y;
          object.z         = transform.z;
          object.rotationX = transform.rotationX;
          object.rotationY = transform.rotationY;
          object.rotationZ = transform.rotationZ;
          object.scaleX    = transform.scaleX;
          object.scaleY    = transform.scaleY;
          object.scaleZ    = transform.scaleZ;
        }
        
        iter.next();
      }
      
      camera_.update(dt);
      camera_.camera_.view.width  = stage_.stageWidth;
      camera_.camera_.view.height = stage_.stageHeight;
      camera_.camera_.render(stage3D_);
    }
  }
}
