package rusher.extension.alternativa3d 
{
  import alternativa.engine3d.core.Camera3D;
  import alternativa.engine3d.core.View;
  import flash.display.Stage;
  import flash.display.Stage3D;
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
    
    private var stage_  :Stage = null;
    private var stage3D_:Stage3D = null;
    
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
      stage_   = getInstance(Stage);
      stage3D_ = stage_.stage3Ds[0];
      
      camera_.view = new View(stage_.stageWidth, stage_.stageHeight);
      camera_.view.antiAlias = 2;
      camera_.view.hideLogo();
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
      
      camera_.view.width  = stage_.stageWidth;
      camera_.view.height = stage_.stageHeight;
      camera_.render(stage3D_);
    }
  }
}
