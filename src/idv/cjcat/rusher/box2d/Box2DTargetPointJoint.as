package idv.cjcat.rusher.box2d 
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2MouseJoint;
    import Box2D.Dynamics.Joints.b2MouseJointDef;
    import idv.cjcat.rusher.core.IComponent;
    import idv.cjcat.rusher.utils.geom.Vec2D;
    
    public class Box2DTargetPointJoint implements IComponent
    {
        private var _target:b2Vec2 = new b2Vec2(0, 0);
        public function get target():Vec2D {
            return new Vec2D
            (
                _target.x * Box2DWorld.METERS_TO_PIXELS, 
                _target.y * Box2DWorld.METERS_TO_PIXELS
            );
        }
        public function set target(value:Vec2D):void
        {
            _target.Set
            (
                value.x * Box2DWorld.PIXELS_TO_METERS, 
                value.y * Box2DWorld.PIXELS_TO_METERS
            );
        }
        
        private var _dampingRatio:Number;
        public function get dampingRatio():Number { return _dampingRatio; }
        public function set dampingRatio(value:Number):void
        {
            _dampingRatio = value;
            if (_joint) _joint.SetDampingRatio(_dampingRatio);
        }
        
        private var _frequencyHz:Number;
        public function get frequencyHz():Number { return _frequencyHz; }
        public function set frequencyHz(value:Number):void
        {
            _frequencyHz = value;
            if (_joint) _joint.SetFrequency(_frequencyHz);
        }
        
        private var _maxForce:Number;
        public function get maxForce():Number { return _maxForce; }
        public function set maxForce(value:Number):void
        {
            _maxForce = value;
            if (_joint) _joint.SetMaxForce(_maxForce);
        }
        
        private var _body:Box2DBody;
        public function get body():Box2DBody { return _body; }
        public function set body(value:Box2DBody):void
        {
            _body = value;
            if (_body && _world) buildJoint();
        }
        
        public function Box2DTargetPointJoint
        (
            dampingRatio:Number = 0.7, 
            frequencyHz:Number = 5, 
            maxForce:Number = -1
        ) 
        {
            _dampingRatio = dampingRatio;
            _frequencyHz = frequencyHz;
            _maxForce = maxForce;
        }
        
        private var _joint:b2MouseJoint;
        
        private var _world:Box2DWorld;
        [Inject]
        public function inject(world:Box2DWorld):void
        {
            _world = world;
            if (_body) buildJoint();
        }
        
        private function buildJoint():void
        {
            //destroyy previous joint
            if (_joint) _world.world.DestroyJoint(_joint);
            
            //quick hack to fix position difference problem
            //move body to target and move it back after the joint creation
            var bodyPos:Vec2D = _body.position;
            _body.position = new Vec2D(_target.x, _target.y);
            
            var jointDef:b2MouseJointDef = new b2MouseJointDef();
            jointDef.bodyA = _world.world.GetGroundBody();
            jointDef.bodyB = _body.body;
            jointDef.frequencyHz = frequencyHz;
            if (_maxForce < 0) _maxForce = 500 * _body.mass;
            jointDef.maxForce = _maxForce;
            jointDef.target = _target;
            
            _joint = b2MouseJoint(_world.world.CreateJoint(jointDef));
            _joint.SetTarget(_target);
            
            //move the body back
            _body.position = bodyPos;
        }
        
        public function dispose():void
        {
            if (_joint) _world.world.DestroyJoint(_joint);
            _world = null;
            _joint = null;
        }
    }
}