package idv.cjcat.rusher.box2d 
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2PrismaticJoint;
    import Box2D.Dynamics.Joints.b2PrismaticJointDef;
    import idv.cjcat.rusher.core.IComponent;
    import idv.cjcat.rusher.utils.geom.Vec2D;
    import idv.cjcat.rusher.utils.RusherMath;
    
    public class Box2DPrismaticJoint implements IComponent
    {
        private var _enableLimit:Boolean;
        public function get enableLimit():Boolean { return _enableLimit; }
        public function set enableLimit(value:Boolean):void
        {
            _enableLimit = value;
            if (_joint) _joint.EnableLimit(_enableLimit);
        }
        
        private var _lowerTranslation:Number;
        public function get lowerTranslation():Number { return _lowerTranslation; }
        public function set lowerTranslation(value:Number):void
        {
            _lowerTranslation = value;
            if (_joint) _joint.SetLimits(_lowerTranslation * Box2DWorld.PIXELS_TO_METERS, _joint.GetUpperLimit());
        }
        
        private var _upperTranslation:Number;
        public function get upperTranslation():Number { return _upperTranslation; }
        public function set upperTranslation(value:Number):void
        {
            _upperTranslation = value;
            if (_joint) _joint.SetLimits(_joint.GetLowerLimit(), _upperTranslation * Box2DWorld.PIXELS_TO_METERS);
        }
        
        private var _enableMotor:Boolean;
        public function get enableMotor():Boolean { return _enableMotor; }
        public function set enableMotor(value:Boolean):void
        {
            _enableMotor = value;
            if (_joint) _joint.EnableMotor(_enableMotor);
        }
        
        private var _motorSpeed:Number;
        public function get motorSpeed():Number { return _motorSpeed; }
        public function set motorSpeed(value:Number):void
        {
            _motorSpeed = value;
            if (_joint) _joint.SetMotorSpeed(_motorSpeed * RusherMath.DEGREE_TO_RADIAN);
        }
        
        private var _maxMotorForce:Number;
        public function get maxMotorForce():Number { return _maxMotorForce; }
        public function set maxMotorForce(value:Number):void
        {
            _maxMotorForce = value;
            if (_joint) _joint.SetMaxMotorForce(_maxMotorForce);
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
        }
        public function set localAnchorB(value:Vec2D):void
        {
            _localAnchorB.Set
            (
                value.x * Box2DWorld.PIXELS_TO_METERS, 
                value.y * Box2DWorld.PIXELS_TO_METERS
            );
            if (_bodyA && _bodyB && _world) buildJoint();
        }
        
        
        public function Box2DPrismaticJoint
        (
            enableLimit:Boolean = false, 
            lowerTranslation:Number = 0, 
            upperTranslation:Number = 100, 
            enableMotor:Boolean = false, 
            motorSpeed:Number = 0, 
            maxMotorForce:Number = 0, 
            localAnchorA:Vec2D = null, 
            localAnchorB:Vec2D = null
        ) 
        {
            _enableLimit = enableLimit;
            _lowerTranslation = lowerTranslation;
            _upperTranslation = upperTranslation;
            _enableMotor = enableMotor;
            _motorSpeed = motorSpeed;
            _maxMotorForce = maxMotorForce;
            
            if (!localAnchorA) localAnchorA = new Vec2D(0, 0);
            if (!localAnchorB) localAnchorB = new Vec2D(0, 0);
            
            this.localAnchorA = localAnchorA;
            this.localAnchorB = localAnchorB;
        }
        
        /**
         * @private
         */
        internal var _joint:b2PrismaticJoint;
        
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
            
            var jointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
            jointDef.bodyA = _bodyA.body;
            jointDef.bodyB = _bodyB.body;
            
            var posA:b2Vec2 = _bodyA.body.GetPosition();
            var posB:b2Vec2 = _bodyB.body.GetPosition();
            var posDiff:b2Vec2 = new b2Vec2(posB.x - posA.x, posB.y - posA.y)
            posDiff.Normalize();
            jointDef.localAxisA = posDiff;
            
            jointDef.localAnchorA = _localAnchorA;
            jointDef.localAnchorB = _localAnchorB;
            jointDef.enableLimit = _enableLimit;
            jointDef.lowerTranslation = _lowerTranslation * Box2DWorld.PIXELS_TO_METERS;
            
            jointDef.upperTranslation = _upperTranslation * Box2DWorld.PIXELS_TO_METERS;
            jointDef.enableMotor = _enableMotor;
            jointDef.motorSpeed = _motorSpeed * Box2DWorld.PIXELS_TO_METERS;
            jointDef.maxMotorForce = _maxMotorForce;
            jointDef.referenceAngle = _bodyB.body.GetAngle() - _bodyA.body.GetAngle();
            jointDef.collideConnected = true;
            
            _joint = b2PrismaticJoint(_world.world.CreateJoint(jointDef));
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