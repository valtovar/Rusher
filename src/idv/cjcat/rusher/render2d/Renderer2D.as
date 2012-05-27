package idv.cjcat.rusher.render2d 
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.utils.Dictionary;
    import idv.cjcat.rusher.clock.Clock;
    import idv.cjcat.rusher.core.ISystem;
	
    public class Renderer2D implements ISystem
    {
        private var _layers:Dictionary = new Dictionary();
        private var _layerArray:Array = [];
        
        private var _camera:Camera = new Camera();
        public function get camera():Camera { return _camera; }
        public function set camera(value:Camera):void
        {
            if (value) _camera = value;
        }
        
        private var _hud:Sprite = new Sprite();
        public function get hud():DisplayObjectContainer { return _hud; }
        
        //the inner canvas is for camera rotation only
        private var _innerCanvas:Sprite = new Sprite();
        private var _canvas:Sprite = new Sprite();
        public function get canvas():DisplayObject { return _canvas; }
        
        private var _zDirty:Boolean = false;
        private function invalidate():void
        {
            _zDirty = true;
        }
        
        public function Renderer2D() 
        {
            
        }
        
        private var _clock:Clock = new Clock();
        [Inject]
        public function inject(clock:Clock):void
        {
            _clock = clock;
        }
        
        public function addLayer(layer:Layer):void
        {
            if (_layers[layer])
            {
                trace("WARNING: Layer already added.");
                return;
            }
            
            _layers[layer] = layer;
            _layerArray.push(layer);
            
            layer.onZChange.add(invalidate);
            invalidate();
            
            _innerCanvas.addChild(layer.sprite);
        }
        
        public function removeLayer(layer:Layer):void
        {
            var l:Layer;
            l = _layers[layer];
            if (l)
            {
                _innerCanvas.removeChild(layer.sprite);
                
                layer.onZChange.remove(invalidate);
                
                _layerArray.splice(_layerArray.indexOf(layer), 1);
                delete _layers[layer];
            }
            trace("WARNING: Layer not found.");
        }
        
        public function onAdd():void
        {
            _innerCanvas.addChild(_hud);
            _canvas.addChild(_innerCanvas);
            
            _clock.add(update);
        }
        
        /**
         * Render loop.
         */
        private function update(dt:Number):void
        {
            var i:int;
            var len:int = _layerArray.length;
            var layer:Layer;
            
            //check if layer z-indices are dirty
            if (_zDirty)
            {
                //sort layers
                _layerArray.sort(zSorter);
                
                //reorder layer
                for (i = 0; i < len; ++i)
                {
                    layer = _layerArray[i];
                    _innerCanvas.addChildAt(layer.sprite, i);
                }
                
                //HUD should always automatically be on the top
                
                //validate
                _zDirty = false;
            }
            
            //update layers
            for (i = 0; i < len; ++i)
            {
                layer = _layerArray[i];
                
                //calculate camera position difference
                var dx:Number = layer.x - camera.x;
                var dy:Number = layer.y - camera.y;
                var dz:Number = layer.z + camera.focalLength;
                
                //continue only if the layer is in front of the camera
                if (layer.sprite.visible = (dz > 0)?(true):(false))
                {
                    //update layer position
                    var focalLengthOverDz:Number = camera.focalLength / dz;
                    layer.sprite.x = dx * focalLengthOverDz;
                    layer.sprite.y = dy * focalLengthOverDz;
                    
                    //update perspective scale
                    if (layer.usePerspectiveScale)
                    {
                        layer.sprite.scaleX = focalLengthOverDz;
                        layer.sprite.scaleY = focalLengthOverDz;
                    }
                    else
                    {
                        layer.sprite.scaleX = 1;
                        layer.sprite.scaleY = 1;
                    }
                }
            }
        }
        
        private function zSorter(layer1:Layer, layer2:Layer):Number
        {
            if (layer1.z > layer2.z) return -1;
            if (layer1.z < layer2.z) return 1;
            return 0;
        }
        
        public function dispose():void
        {
            _clock.remove(update);
            _clock = null;
            
            _hud = null;
            _innerCanvas = null;
            _canvas = null;
            
            for (var key:* in _layers)
            {
                delete _layers[key];
            }
            _layers = null;
            
            _layerArray.length = 0;
            _layerArray = null;
        }
    }
}