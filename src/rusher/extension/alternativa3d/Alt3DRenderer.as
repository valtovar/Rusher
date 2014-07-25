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
    private var lights_     :InList      = new InList();
    
    private var stage_  :Stage   = null;
    private var stage3D_:Stage3D = null;
    
    /** @private */
    internal function registerRenderable(renderable:Alt3DRenderable):void
    {
      renderables_.pushBack(renderable);
      root_.addChild(renderable.object_);
    }
    
    /** @private */
    internal function unregisterRenderable(renderable:Alt3DRenderable):void
    {
      renderables_.remove(renderable);
      root_.removeChild(renderable.object_);
    }
    
    /** @private */
    internal function registerLight(light:Alt3DLight):void
    {
      lights_.pushBack(light);
      root_.addChild(light.light_);
    }
    
    /** @private */
    internal function unregisterLight(light:Alt3DLight):void
    {
      lights_.remove(light);
      root_.addChild(light.light_);
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
      {
        return;
      }
      
      if (!camera_)
      {
        trace("WARNING - No active Alt3DCamera.");
        return;
      }
        
      var iter:InListIterator;
        
      var renderable:Alt3DRenderable;
      iter = renderables_.getIterator();
      while (renderable = iter.data())
      {
        renderable.update(dt);
        iter.next();
      }
      
      var light:Alt3DLight
      iter = lights_.getIterator();
      while (light = iter.data())
      {
        light.update(dt);
        iter.next();
      }
      
      camera_.update(dt);
    }
  }
}
