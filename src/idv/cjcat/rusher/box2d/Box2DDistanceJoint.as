package idv.cjcat.rusher.box2d 
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2DistanceJoint;
    import Box2D.Dynamics.Joints.b2DistanceJointDef;
    import Box2D.Dynamics.Joints.b2MouseJoint;
    import Box2D.Dynamics.Joints.b2MouseJointDef;
    import idv.cjcat.rusher.core.IComponent;
    import idv.cjcat.rusher.utils.geom.Vec2D;
    
    public class Box2DDistanceJoint implements IComponent
    {
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
        
        private var _length:Number;
        public function get length():Number { return _length; }
        public function set length(value:Number):void
        {
            _length = value;
            if (_joint) _joint.SetLength(_length);
        }
        
        private var _bodyA:Box2DBody;
        public function get bodyA():Box2DBody { return _bodyA; }
        public function set bodyA(value:Box2DBody):void
        {
            _bodyA = value;
            if (_bodyA && _bodyB && _world) buildJoint();
            else destroyJoint();
        }
        
        private var _bodyB:Box2DBody;
        public function get bodyB():Box2DBody { return _bodyB; }
        public function set bodyB(value:Box2DBody):void
        {
            _bodyB = value;
            if (_bodyA && _bodyB && _world) buildJoint();
            else destroyJoint();
        }
        
        private var _localAnchorA:b2Vec2 = new b2Vec2(0, 0);
        public function get localAnchorA():Vec2D
        {
            return new Vec2D
            (
                _localAnchorA.x * Box2DWorld.METERS_TO_PIXELS, 
                _localAnchorA.y * Box2DWorld.METERS_TO_PIXELS
            );
        }
        public function set localAnchorA(value:Vec2D):void
        {
            _localAnchorA.Set
            (
                value.x * Box2DWorld.PIXELS_TO_METERS, 
                value.y * Box2DWorld.PIXELS_TO_METERS
            );
            if (_bodyA && _bodyB && _world) buildJoint();
        }
        
        private var _localAnchorB:b2Vec2 = new b2Vec2(0, 0);
        public function get localAnchorB():Vec2D
        {
            return new Vec2D
            (
                _localAnchorB.x * Box2DWorld.METERS_TO_PIXELS, 
                _localAnchorB.y * Box2DWorld.METERS_TO_PIXELS
            );
            if (_bodyA && _bodyB && _world) buildJoint();
        }
        
        public function set localAnchorB(value:Vec2D):void
        {
            _localAnchorB.Set
            (
                value.x * Box2DWorld.PIXELS_TO_METERS, 
                value.y * Box2DWorld.PIXELS_TO_METERS
            );
        }
        
        public function Box2DDistanceJoint
        (
            dampingRatio:Number = 0, 
            frequencyHz:Number = 0, 
            length:Number = -1, 
            localAnchorA:Vec2D = null, 
            localAnchorB:Vec2D = null
        ) 
        {
            _dampingRatio = dampingRatio;
            _frequencyHz = frequencyHz;
            _length = length;
            
            if (!localAnchorA) localAnchorA = new Vec2D(0, 0);
            if (!localAnchorB) localAnchorB = new Vec2D(0, 0);
            
            this.localAnchorA = localAnchorA;
            this.localAnchorB = localAnchorB;
        }
        
        private var _joint:b2DistanceJoint;
        
        private var _world:Box2DWorld;
        [Inject]
        public function inject(world:Box2DWorld):void
        {
            _world = world;
            if (_bodyA && _bodyB) buildJoint();
        }
        
        private function buildJoint():void
        {
            //destroyy previous joint
            destroyJoint();
            
            var jointDef:b2DistanceJointDef = new b2DistanceJointDef();
            jointDef.bodyA = _bodyA.body;
            jointDef.bodyB = _bodyB.body;
            jointDef.localAnchorA = _localAnchorA;
            jointDef.localAnchorB = _localAnchorB;
            jointDef.frequencyHz = frequencyHz;
            if (_length < 0)
            {
                _length = new Vec2D
                (
                    _bodyA.position.x - bodyB.position.x, 
                    _bodyA.position.y - bodyB.position.y
                ).length;
            }
            jointDef.length = _length * Box2DWorld.PIXELS_TO_METERS;
            jointDef.collideConnected = true;
            
            _joint = b2DistanceJoint(_world.world.CreateJoint(jointDef));
        }
        
        private function destroyJoint():void
        {
            if (_joint)
            {
                _world.world.DestroyJoint(_joint);
                _joint = null;
            }
        }
        
        public function dispose():void
        {
            if (_joint) _world.world.DestroyJoint(_joint);
            _world = null;
            _joint = null;
        }
    }
}