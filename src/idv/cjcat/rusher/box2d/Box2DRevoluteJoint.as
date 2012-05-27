package idv.cjcat.rusher.box2d 
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2RevoluteJoint;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import idv.cjcat.rusher.core.IComponent;
    import idv.cjcat.rusher.utils.geom.Vec2D;
    import idv.cjcat.rusher.utils.RusherMath;
    
    public class Box2DRevoluteJoint implements IComponent
    {
        private var _enableLimit:Boolean;
        public function get enableLimit():Boolean { return _enableLimit; }
        public function set enableLimit(value:Boolean):void
        {
            _enableLimit = value;
            if (_joint) _joint.EnableLimit(_enableLimit);
        }
        
        private var _lowerAngle:Number;
        public function get lowerAngle():Number { return _lowerAngle; }
        public function set lowerAngle(value:Number):void
        {
            _lowerAngle = value;
            if (_joint) _joint.SetLimits(_lowerAngle * RusherMath.DEGREE_TO_RADIAN, _joint.GetUpperLimit());
        }
        
        private var _upperAngle:Number;
        public function get upperAngle():Number { return _upperAngle; }
        public function set upperAngle(value:Number):void
        {
            _upperAngle = value;
            if (_joint) _joint.SetLimits(_joint.GetLowerLimit(), _upperAngle * RusherMath.DEGREE_TO_RADIAN);
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
        
        private var _maxMotorTorque:Number;
        public function get maxMotorTorque():Number { return _maxMotorTorque; }
        public function set maxMotorTorque(value:Number):void
        {
            _maxMotorTorque = value;
            if (_joint) _joint.SetMaxMotorTorque(_maxMotorTorque);
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
            if (_bodyA && _bodyB) buildJoint();
        }
        public function set localAnchorB(value:Vec2D):void
        {
            _localAnchorB.Set
            (
                value.x * Box2DWorld.PIXELS_TO_METERS, 
                value.y * Box2DWorld.PIXELS_TO_METERS
            );
        }
        
        
        public function Box2DRevoluteJoint
        (
            enableLimit:Boolean = false, 
            lowerAngle:Number = 0, 
            upperAngle:Number = 360, 
            enableMotor:Boolean = false, 
            motorSpeed:Number = 0, 
            maxMotorTorque:Number = 0, 
            localAnchorA:Vec2D = null, 
            localAnchorB:Vec2D = null
        ) 
        {
            _enableLimit = enableLimit;
            _lowerAngle = lowerAngle;
            _upperAngle = upperAngle;
            _enableMotor = enableMotor;
            _motorSpeed = motorSpeed;
            _maxMotorTorque = maxMotorTorque;
            
            if (!localAnchorA) localAnchorA = new Vec2D(0, 0);
            if (!localAnchorB) localAnchorB = new Vec2D(0, 0);
            
            this.localAnchorA = localAnchorA;
            this.localAnchorB = localAnchorB;
        }
        
        /**
         * @private
         */
        internal var _joint:b2RevoluteJoint;
        
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
            
            var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
            jointDef.bodyA = _bodyA.body;
            jointDef.bodyB = _bodyB.body;
            jointDef.localAnchorA = _localAnchorA;
            jointDef.localAnchorB = _localAnchorB;
            jointDef.enableLimit = _enableLimit;
            jointDef.lowerAngle = _lowerAngle * RusherMath.DEGREE_TO_RADIAN;
            jointDef.upperAngle = _upperAngle * RusherMath.DEGREE_TO_RADIAN;
            jointDef.enableMotor = _enableMotor;
            jointDef.motorSpeed = _motorSpeed * RusherMath.DEGREE_TO_RADIAN;
            jointDef.maxMotorTorque = _maxMotorTorque * RusherMath.DEGREE_TO_RADIAN;
            jointDef.referenceAngle = jointDef.bodyB.GetAngle() - jointDef.bodyA.GetAngle();
            
            _joint = b2RevoluteJoint(_world.world.CreateJoint(jointDef));
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