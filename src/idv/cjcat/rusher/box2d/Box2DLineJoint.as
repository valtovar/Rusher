package idv.cjcat.rusher.box2d 
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2LineJoint;
    import Box2D.Dynamics.Joints.b2LineJointDef;
    import Box2D.Dynamics.Joints.b2PrismaticJoint;
    import Box2D.Dynamics.Joints.b2PrismaticJointDef;
    import idv.cjcat.rusher.core.IComponent;
    import idv.cjcat.rusher.utils.geom.Vec2D;
    import idv.cjcat.rusher.utils.RusherMath;
    
    public class Box2DLineJoint implements IComponent
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
        
        private var _axis:b2Vec2 = new b2Vec2(1, 0);
        public function get axis():Vec2D
        {
            return new Vec2D (_axis.x,  _axis.y);
        }
        public function set axis(value:Vec2D):void
        {
            _axis.Set(value.x, value.y);
            _axis.Normalize();
            if (_body && _world) buildJoint();
        }
        
        
        public function Box2DLineJoint
        (
            axis:Vec2D = null, 
            localAnchor:Vec2D = null, 
            enableLimit:Boolean = false, 
            lowerTranslation:Number = 0, 
            upperTranslation:Number = 100, 
            enableMotor:Boolean = false, 
            motorSpeed:Number = 0, 
            maxMotorForce:Number = 0
        ) 
        {
            _enableLimit = enableLimit;
            _lowerTranslation = lowerTranslation;
            _upperTranslation = upperTranslation;
            _enableMotor = enableMotor;
            _motorSpeed = motorSpeed;
            _maxMotorForce = maxMotorForce;
            
            if (!axis) axis = new Vec2D(1, 0);
            if (!localAnchor) localAnchor = new Vec2D(0, 0);
            
            this.localAnchor = localAnchor;
        }
        
        /**
         * @private
         */
        internal var _joint:b2LineJoint;
        
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
            destroyJoint();
            
            var jointDef:b2LineJointDef = new b2LineJointDef();
            jointDef.bodyA = _world.groundBody.body;
            jointDef.bodyB = _body.body;
            
            var pos:b2Vec2 = _body.body.GetPosition();
            var anchor:b2Vec2 = new b2Vec2(pos.x + _localAnchor.x, pos.y + _localAnchor.y);
            jointDef.localAnchorA = anchor;
            jointDef.localAnchorB = _localAnchor;
            jointDef.enableLimit = _enableLimit;
            jointDef.lowerTranslation = _lowerTranslation * Box2DWorld.PIXELS_TO_METERS;
            
            jointDef.upperTranslation = _upperTranslation * Box2DWorld.PIXELS_TO_METERS;
            jointDef.enableMotor = _enableMotor;
            jointDef.motorSpeed = _motorSpeed * Box2DWorld.PIXELS_TO_METERS;
            jointDef.maxMotorForce = _maxMotorForce;
            
            _joint = b2LineJoint(_world.world.CreateJoint(jointDef));
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