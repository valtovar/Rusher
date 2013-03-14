package rusher.extension.alternativa3d 
{
  import alternativa.engine3d.core.Camera3D;
  import alternativa.engine3d.core.View;
  import flash.display.Stage;
  import rusher.engine.Component;
  import rusher.transform.Transform3D;
  
  public class Alt3DCamera extends Component
  {
    /** @private */
    internal var camera_:Camera3D;
    
    public var nearClipping:Number;
    public var farClipping:Number;
    public var target:Transform3D = null;
    public var fov:Number;
    public var orthographic:Boolean;
    
    public function Alt3DCamera(near:Number = 0.1, far:Number = 10000.0)
    {
      camera_ = new Camera3D(near, far);
      nearClipping = near;
      farClipping  = far;
      
      fov = camera_.fov;
      orthographic = camera_.orthographic;
    }
    
    public function setActive():void
    {
      getInstance(Alt3DRenderer).setCamera(this);
    }
    
    override public function init():void 
    {
      var stage:Stage = getInstance(Stage);
      
      camera_.view = new View(stage.stageWidth, stage.stageHeight);
      camera_.view.antiAlias = 4;
      //camera_.view.hideLogo();
    }
    
    /** @private */
    internal function update(dt:Number):void
    {
      var transform:Transform3D = getInstance(Transform3D);
      camera_.x = transform.x;
      camera_.y = transform.y;
      camera_.z = transform.z;
      camera_.rotationX = transform.rotationX;
      camera_.rotationY = transform.rotationY;
      camera_.rotationZ = transform.rotationZ;
      camera_.nearClipping = nearClipping;
      camera_.farClipping  = farClipping;
      camera_.fov = fov;
      camera_.orthographic = orthographic;
      
      if (target)
      {
        camera_.lookAt(target.x, target.y, target.z);
      }
    }
  }
}
