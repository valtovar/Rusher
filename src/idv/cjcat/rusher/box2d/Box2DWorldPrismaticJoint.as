package idv.cjcat.rusher.box2d 
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.Joints.b2PrismaticJoint;
    import Box2D.Dynamics.Joints.b2PrismaticJointDef;
    import idv.cjcat.rusher.core.IComponent;
    import idv.cjcat.rusher.utils.geom.Vec2D;
    import idv.cjcat.rusher.utils.RusherMath;
    
    public class Box2DWorldPrismaticJoint implements IComponent, IBox2DGearJointTarget
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
        
        private var _worldAnchor:b2Vec2 = new b2Vec2(0, 0);
        public function get worldAnchor():Vec2D
        {
            return new Vec2D
            (
                _worldAnchor.x * Box2DWorld.METERS_TO_PIXELS, 
                _worldAnchor.y * Box2DWorld.METERS_TO_PIXELS
            );
        }
        public function set worldAnchor(value:Vec2D):void
        {
            _worldAnchor.Set
            (
                value.x * Box2DWorld.PIXELS_TO_METERS, 
                value.y * Box2DWorld.PIXELS_TO_METERS
            );
            if (_body && _world) buildJoint();
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
        
        
        public function Box2DWorldPrismaticJoint
        (
            worldAnchor:Vec2D = null, 
            enableLimit:Boolean = false, 
            lowerTranslation:Number = 0, 
            upperTranslation:Number = 100, 
            enableMotor:Boolean = false, 
            motorSpeed:Number = 0, 
            maxMotorForce:Number = 0, 
            localAnchor:Vec2D = null
        ) 
        {
            _enableLimit = enableLimit;
            _lowerTranslation = lowerTranslation;
            _upperTranslation = upperTranslation;
            _enableMotor = enableMotor;
            _motorSpeed = motorSpeed;
            _maxMotorForce = maxMotorForce;
            
            if (!worldAnchor) worldAnchor = new Vec2D(0, 0);
            if (!localAnchor) localAnchor = new Vec2D(0, 0);
            
            this.worldAnchor = worldAnchor;
            this.localAnchor = localAnchor;
        }
        
        /**
         * @private
         */
        internal var _joint:b2PrismaticJoint;
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
            
            var jointDef:b2PrismaticJointDef = new b2PrismaticJointDef();
            jointDef.bodyA = _ground;
            jointDef.bodyB = _body.body;
            _ground.SetPosition(_worldAnchor);
            
            var posA:b2Vec2 = _ground.GetPosition();
            var posB:b2Vec2 = _body.body.GetPosition();
            var posDiff:b2Vec2 = new b2Vec2(posB.x - posA.x, posB.y - posA.y)
            posDiff.Normalize();
            jointDef.localAxisA = posDiff;
            
            jointDef.localAnchorA = new b2Vec2(0, 0);;
            jointDef.localAnchorB = _localAnchor;
            jointDef.enableLimit = _enableLimit;
            jointDef.lowerTranslation = _lowerTranslation * Box2DWorld.PIXELS_TO_METERS;
            
            jointDef.upperTranslation = _upperTranslation * Box2DWorld.PIXELS_TO_METERS;
            jointDef.enableMotor = _enableMotor;
            jointDef.motorSpeed = _motorSpeed * Box2DWorld.PIXELS_TO_METERS;
            jointDef.maxMotorForce = _maxMotorForce;
            jointDef.referenceAngle = _body.body.GetAngle() - _ground.GetAngle();
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