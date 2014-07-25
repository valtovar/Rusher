package rusher.extension.alternativa3d 
{
  import alternativa.engine3d.core.Light3D;
  import alternativa.engine3d.lights.AmbientLight;
  import alternativa.engine3d.lights.DirectionalLight;
  import alternativa.engine3d.lights.OmniLight;
  import alternativa.engine3d.lights.SpotLight;
  import rusher.engine.Component;
  import rusher.transform.Transform3D;
  
  public class Alt3DLight extends Component
  {
    
    public static const AMBIENT    :String = "ambient"    ;
    public static const DIRECTIONAL:String = "direcitonal";
    public static const OMNI       :String = "omni"       ;
    public static const SPOTLIGHT  :String = "spotlight"  ;
    
    /** @private */
    internal var light_:Light3D = null;
    
    public var target:Transform3D = null;
    
    public var color            :uint   = 0xFFFFFF;
    public var intensity        :Number = 1.0;
    public var attenuationBegin :Number = 10.0;
    public var attenuationEnd   :Number = 1000.0;
    public var spotligihtFalloff:Number = 0.75;
    public var spotlightHotspot :Number = 0.5;
    
    private var type_:String;
    public function get type():String { return type_; }
    public function set type(value:String):void
    {
      var renderer:Alt3DRenderer = getInstance(Alt3DRenderer);
      
      if (light_)
        renderer.unregisterLight(this);
        
      switch (value)
      {
        case AMBIENT:
          light_ = new AmbientLight(color);
          break;
        case DIRECTIONAL:
          light_ = new DirectionalLight(color);
          break;
        case OMNI:
          light_ = new OmniLight(color, 10.0, 1000.0);
          break;
        case SPOTLIGHT:
          light_ = new SpotLight(color, 10.0, 1000.0, 0.75, 0.5);
          break;
      }
      
      type_ = value;
      if (light_)
        renderer.registerLight(this);
    }
    
    public function Alt3DLight(type:String = OMNI, color:uint = 0xFFFFFF, intensity:Number = 1.0) 
    {
      type_ = type;
      this.color = color;
    }
    
    override public function init():void 
    {
      //trigger setter and light registration
      this.type = type_;
    }
    
    /** @private */
    internal function update(dt:Number):void
    {
      light_.color     = color    ;
      light_.intensity = intensity;
      
      //pull transform
      switch (type_)
      {
        case OMNI:
        case SPOTLIGHT:
          var transform:Transform3D = getInstance(Transform3D);
          light_.x         = transform.x;
          light_.y         = transform.y;
          light_.z         = transform.z;
          light_.rotationX = transform.rotationX;
          light_.rotationY = transform.rotationY;
          light_.rotationZ = transform.rotationZ;
          light_.scaleX    = transform.scaleX;
          light_.scaleY    = transform.scaleY;
          light_.scaleZ    = transform.scaleZ;
          break;
      }
      
      //update specific light properties
      switch (type_)
      {
        case DIRECTIONAL:
          var directional:DirectionalLight = DirectionalLight(light_);
          if (target)
            directional.lookAt(target.x, target.y, target.z);
          break;
        case OMNI:
          var omni:OmniLight = OmniLight(light_);
          omni.attenuationBegin = attenuationBegin;
          omni.attenuationEnd   = attenuationEnd  ;
          break;
        case SPOTLIGHT:
          var spotlight:SpotLight = SpotLight(light_);
          spotlight.attenuationBegin = attenuationBegin ;
          spotlight.attenuationEnd   = attenuationEnd   ;
          spotlight.falloff          = spotligihtFalloff;
          spotlight.hotspot          = spotlightHotspot ;
          break;
      }
    }
  }
}

