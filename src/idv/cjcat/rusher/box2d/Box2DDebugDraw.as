package idv.cjcat.rusher.box2d 
{
    import Box2D.Dynamics.b2DebugDraw;
    import flash.display.Sprite;
    import flash.display.Stage;
    import idv.cjcat.rusher.core.IComponent;
    import idv.cjcat.rusher.core.ISystem;
    import idv.cjcat.rusher.clock.Clock;
    
    public class Box2DDebugDraw extends Sprite implements ISystem, IComponent
    {
        private var _debugDraw:b2DebugDraw;
        
        public function Box2DDebugDraw(alpha:Number = 1) 
        {
            _debugDraw = new b2DebugDraw();
            _debugDraw.SetDrawScale(1 / Box2DWorld.PIXELS_TO_METERS);
            _debugDraw.SetSprite(this);
            
            _debugDraw.AppendFlags(Box2DDebugDrawFlag.CENTER_OF_MASS);
            _debugDraw.AppendFlags(Box2DDebugDrawFlag.JOINT);
            _debugDraw.AppendFlags(Box2DDebugDrawFlag.SHAPE);
            
            this.alpha = alpha;
        }
        
        private var _stage:Stage;
        private var _clock:Clock;
        private var _world:Box2DWorld;
        [Inject]
        public function inject(stage:Stage, clock:Clock, world:Box2DWorld):void
        {
            _stage = stage;
            _clock = clock;
            _world = world;
        }
        
        public function onAdd():void
        {
            if (_world)
            {
                _world.world.SetDebugDraw(_debugDraw);
            }
            else
            {
                trace("WARNING: Add the Box2DWorld system to the engine first.");
            }
            _clock.add(update);
            //_stage.addChild(this);
        }
        
        private function update(dt:Number):void
        {
            _world.world.DrawDebugData();
        }
        
        public function dispose():void
        {
            //_stage.removeChild(this);
            _stage = null;
            
            _clock.remove(update);
            _clock = null;
            
            _world = null;
            _debugDraw = null;
        }
    }
}