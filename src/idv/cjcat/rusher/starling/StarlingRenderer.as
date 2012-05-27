package idv.cjcat.rusher.starling 
{
    import flash.display.Stage;
    import flash.display.StageAlign;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    import idv.cjcat.rusher.clock.Clock;
    import idv.cjcat.rusher.core.ISystem;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Sprite;
	
    public class StarlingRenderer implements ISystem
    {
        private var _onInit:ISignal = new Signal();
        public function get onInit():ISignal { return _onInit; }
        
        private var _layers:Dictionary;
        private var _layerArray:Array;
        
        private var _camera:StarlingCamera;
        public function get camera():StarlingCamera { return _camera; }
        public function set camera(value:StarlingCamera):void
        {
            if (value) _camera = value;
        }
        
        private var _hud:Sprite;
        public function get hud():DisplayObjectContainer { return _hud; }
        
        //the inner canvas is for camera panning only
        private var _innerCanvas:Sprite;
        //the 2nd inner canvas is for camera rotation only
        private var _innerCanvas2:Sprite;
        private var _canvas:StarlingCanvas;
        public function get canvas():DisplayObject { return _innerCanvas; }
        
        private var _zDirty:Boolean = false;
        private function invalidate():void
        {
            _zDirty = true;
        }
        
        private var _autoStart:Boolean;
        
        public function StarlingRenderer(autoStart:Boolean = true) 
        {
            _autoStart = autoStart;
        }
        
        private var _starling:Starling;
        
        private var _clock:Clock;
        private var _stage:Stage;
        [Inject]
        public function inject(stage:Stage, clock:Clock):void
        {
            _clock = clock;
            _stage = stage;
            
            _starling = new Starling(StarlingCanvas, stage);
            if (_autoStart) start();
        }
        
        public function start():void
        {
            _starling.start();
        }
        
        public function stop():void
        {
            _starling.stop();
        }
        
        public function addLayer(layer:StarlingLayer):void
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
            
            _innerCanvas2.addChild(layer.sprite);
        }
        
        public function removeLayer(layer:StarlingLayer):void
        {
            var l:StarlingLayer;
            l = _layers[layer];
            if (l)
            {
                _innerCanvas2.removeChild(layer.sprite);
                
                layer.onZChange.remove(invalidate);
                
                _layerArray.splice(_layerArray.indexOf(layer), 1);
                delete _layers[layer];
            }
            trace("WARNING: Layer not found.");
        }
        
        public function onAdd():void
        {
            _layers = new Dictionary();
            _layerArray = [];
            
            _hud = new Sprite();
            _innerCanvas = new Sprite();
            _innerCanvas2 = new Sprite();
            _innerCanvas.addChild(_innerCanvas2);
            _innerCanvas2.addChild(_hud);
            
            _clock.add(update);
        }
        
        private var _initialized:Boolean = false;
        
        /**
         * Render loop.
         */
        private function update(dt:Number):void
        {
            //if context3D is not ready, don't update.
            if (!(_canvas = StarlingCanvas.instance)) return;
            
            //initielize canvas only once
            if (!_initialized)
            {
                _canvas.addChild(_innerCanvas);
                _initialized = true
                
                _stage.align = StageAlign.TOP_LEFT;
                _stage.addEventListener(Event.RESIZE, reshape);
                
                _onInit.dispatch();
            }
            
            //update inner canvas center
            var hw:Number = 0.5 * _stage.stageWidth;
            var hh:Number = 0.5 * _stage.stageHeight;
            _innerCanvas2.x = hw;
            _innerCanvas2.y = hh;
            _hud.x = -hw;
            _hud.y = -hh;
            
            
            //main update routine begins
            var i:int;
            var len:int = _layerArray.length;
            var layer:StarlingLayer;
            
            //check if layer z-indices are dirty
            if (_zDirty)
            {
                //sort layers
                _layerArray.sort(zSorter);
                
                //reorder layer
                for (i = 0; i < len; ++i)
                {
                    layer = _layerArray[i];
                    _innerCanvas2.addChildAt(layer.sprite, i);
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
                var dx:Number = layer.x - camera.x - hw;
                var dy:Number = layer.y - camera.y - hh;
                var dz:Number = layer.z - camera.z;
                
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
        
        private function zSorter(layer1:StarlingLayer, layer2:StarlingLayer):Number
        {
            if (layer1.z > layer2.z) return -1;
            if (layer1.z < layer2.z) return 1;
            return 0;
        }
        
        private function reshape(e:Event = null):void
        {
            _starling.viewPort = new Rectangle(0, 0, _stage.stageWidth, _stage.stageHeight);
        }
        
        public function dispose():void
        {
            _clock.remove(update);
            _clock = null;
            
            _hud.dispose();
            _hud = null;
            _innerCanvas2.dispose();
            _innerCanvas2 = null;
            _innerCanvas.dispose();
            _innerCanvas = null;
            _canvas.dispose();
            _canvas = null;
            
            _starling.stop();
            _starling.dispose();
            _starling = null;
            
            _stage = null;
            
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