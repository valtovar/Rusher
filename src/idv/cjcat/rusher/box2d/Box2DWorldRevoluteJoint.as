package idv.cjcat.rusher.box2d 
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.Joints.b2RevoluteJoint;
    import Box2D.Dynamics.Joints.b2RevoluteJointDef;
    import idv.cjcat.rusher.core.IComponent;
    import idv.cjcat.rusher.utils.geom.Vec2D;
    import idv.cjcat.rusher.utils.RusherMath;
    
    public class Box2DWorldRevoluteJoint implements IComponent, IBox2DGearJointTarget
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
        
        private var _body:Box2DBody;
        public function get body():Box2DBody { return _body; }
        public function set body(value:Box2DBody):void
        {
            _body = value;
            if (_body && _world) buildJoint();
            else destroyJoint();
        }
        
        private var _localAnchor:b2Vec2 = new b2Vec2(0, 0);
        public function get localAnchor():Vec2D
        {
            return new Vec2D
            (
                _localAnchor.x * Box2DWorld.METERS_TO_PIXELS, 
                _localAnchor.y * Box2DWorld.METERS_TO_PIXELS
            );
        }
        public function set localAnchor(value:Vec2D):void
        {
            _localAnchor.Set
            (
                value.x * Box2DWorld.PIXELS_TO_METERS, 
                value.y * Box2DWorld.PIXELS_TO_METERS
            );
            if (_body && _world) buildJoint();
        }
        
        
        public function Box2DWorldRevoluteJoint
        (
            localAnchor:Vec2D = null, 
            enableLimit:Boolean = false, 
            lowerAngle:Number = 0, 
            upperAngle:Number = 360, 
            enableMotor:Boolean = false, 
            motorSpeed:Number = 0, 
            maxMotorTorque:Number = 0
        ) 
        {
            _enableLimit = enableLimit;
            _lowerAngle = lowerAngle;
            _upperAngle = upperAngle;
            _enableMotor = enableMotor;
            _motorSpeed = motorSpeed;
            _maxMotorTorque = maxMotorTorque;
            
            if (!localAnchor) localAnchor = new Vec2D(0, 0);
            
            this.localAnchor = localAnchor;
        }
        
        /**
         * @private
         */
        internal var _joint:b2RevoluteJoint;
        private var _ground:b2Body;
        
        private var _world:Box2DWorld;
        [Inject]
        public function inject(world:Box2DWorld):void
        {
            _world = world;
            var groundDef:b2BodyDef = new b2BodyDef();
            groundDef.type = b2Body.b2_staticBody;
            _ground = _world.world.CreateBody(groundDef);
            
            if (_body) buildJoint();
        }
        
        private function buildJoint():void
        {
            //destroyy previous joint
            destroyJoint();
            
            var jointDef:b2RevoluteJointDef = new b2RevoluteJointDef();
            jointDef.bodyA = _ground;
            jointDef.bodyB = _body.body;
            _ground.SetPosition(jointDef.bodyB.GetPosition());
            
            jointDef.localAnchorA = new b2Vec2(0, 0);
            jointDef.localAnchorB = _localAnchor;
            
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