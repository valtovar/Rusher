package idv.cjcat.rusher.box2d 
{
    import Box2D.Collision.Shapes.b2MassData;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import idv.cjcat.rusher.core.IComponent;
    import idv.cjcat.rusher.utils.geom.Vec2D;
    import idv.cjcat.rusher.utils.RusherMath;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
	
    public final class Box2DBody implements IComponent
    {
        private var _onContactBegin:ISignal = new Signal(Box2DBody);
        public function get onContactBegin():ISignal { return _onContactBegin; }
        
        private var _onContactEnd:ISignal = new Signal(Box2DBody);
        public function get onContactEnd():ISignal { return _onContactEnd; }
        
        public var enableContactSignals:Boolean = false;
        
        private var _bodyDef:Box2DBodyDef;
        private var _body:b2Body;
        /**
         * @private
         */
        internal function get body():b2Body { return _body; }
         
        public function get position():Vec2D
        {
            return new Vec2D
            (
                _body.GetPosition().x / Box2DWorld.PIXELS_TO_METERS, 
                _body.GetPosition().y / Box2DWorld.PIXELS_TO_METERS
            );
        }
        public function set position(value:Vec2D):void
        {
            _body.SetPosition
            (
                new b2Vec2
                (
                    value.x * Box2DWorld.PIXELS_TO_METERS, 
                    value.y * Box2DWorld.PIXELS_TO_METERS
                )
            );
        }
        public function get linearVelocity():Vec2D
        {
            return new Vec2D
            (
                _body.GetLinearVelocity().x / Box2DWorld.PIXELS_TO_METERS, 
                _body.GetLinearVelocity().y / Box2DWorld.PIXELS_TO_METERS
            );
        }
        public function set linearVelocity(value:Vec2D):void
        {
            _body.SetLinearVelocity
            (
                new b2Vec2
                (
                    value.x * Box2DWorld.PIXELS_TO_METERS, 
                    value.y * Box2DWorld.PIXELS_TO_METERS
                )
            );
        }
        
        private var _rotation:Number;
        public function get rotation():Number { return (_body)?(_body.GetAngle() * RusherMath.RADIAN_TO_DEGREE):(_rotation); }
        public function set rotation(value:Number):void
        {
            _rotation = value;
            if (_body) _body.SetAngle(_rotation * RusherMath.DEGREE_TO_RADIAN);
        }
        
        private var _angularVelocity:Number;
        public function get angularRotation():Number { return _angularVelocity; }
        public function set angularRotation(value:Number):void
        {
            _angularVelocity = value;
            if (_body) _body.SetAngularVelocity(_angularVelocity * RusherMath.DEGREE_TO_RADIAN);
        }
        
        private var _bullet:Boolean;
        public function get bullet():Boolean { return _bullet; }
        public function set bullet(value:Boolean):void
        {
            _bullet = value;
            if (_body) _body.SetBullet(_bullet);
        }
        
        private var _linearDamping:Number;
        public function get linearDamping():Number { return _linearDamping; }
        public function set linearDamping(value:Number):void
        {
            _linearDamping = value;
            if (_body) _body.SetLinearDamping(_linearDamping);
        }
        
        private var _angularDamping:Number;
        public function get angularDamping():Number { return _angularDamping; }
        public function set angularDamping(value:Number):void
        {
            _angularDamping = value;
            if (_body) _body.SetAngularDamping(_angularDamping);
        }
        
        private var _active:Boolean;
        public function get active():Boolean { return _active; }
        public function set active(value:Boolean):void
        {
            _active = value;
            if (_body) _body.SetActive(_active);
        }
        
        private var _fixedRotation:Boolean;
        public function get fixedRotation():Boolean { return _fixedRotation; }
        public function set fixedRotation(value:Boolean):void
        {
            _fixedRotation = value;
            if (_body) _body.SetActive(_fixedRotation);
        }
        
        private var _type:uint;
        public function get type():uint { return _type; }
        public function set type(value:uint):void
        {
            _type = value;
            if (_body) _body.SetType(_type);
        }
        
        public function get isAwake():Boolean { return (_body)?(_body.IsAwake()):(false); }
        public function wake():void { if (_body) _body.SetAwake(true); }
        public function sleep():void { if (_body) _body.SetAwake(false); }
        
        private var _mass:Number;
        public function get mass():Number { return _mass; }
        public function set mass(value:Number):void
        {
            _mass = value;
            if (_body)
            {
                var md:b2MassData = new b2MassData();
                _body.GetMassData(md);
                md.mass = _mass;
                _body.SetMassData(md);
            }
        }
        
        public function Box2DBody(bodyDef:Box2DBodyDef, enableContactSignals:Boolean = false) 
        {
            _bodyDef = bodyDef;
            this.enableContactSignals = enableContactSignals;
        }
        
        private var _world:Box2DWorld;
        [Inject]
        public function inject(world:Box2DWorld):void
        {
            _world = world;
            
            createBody();
        }
        
        private function createBody():void
        {
            
            _body = _world.world.CreateBody(_bodyDef.getBodyDef());
            _bodyDef.createShapes(new Box2DShapeCreator(_body));
            
            _body.SetUserData(this);
        }
        
        public function applyForce(force:Vec2D, point:Vec2D):void
        {
            _body.ApplyForce
            (
                new b2Vec2
                (
                    force.x * Box2DWorld.PIXELS_TO_METERS, 
                    force.y * Box2DWorld.PIXELS_TO_METERS
                ), 
                new b2Vec2
                (
                    point.x * Box2DWorld.PIXELS_TO_METERS, 
                    point.y * Box2DWorld.PIXELS_TO_METERS
                )
            );
        }
        
        public function applyImpulse(impulse:Vec2D, point:Vec2D):void
        {
            _body.ApplyImpulse
            (
                new b2Vec2
                (
                    impulse.x * Box2DWorld.PIXELS_TO_METERS, 
                    impulse.y * Box2DWorld.PIXELS_TO_METERS
                ), 
                new b2Vec2
                (
                    point.x * Box2DWorld.PIXELS_TO_METERS, 
                    point.y * Box2DWorld.PIXELS_TO_METERS
                )
            );
        }
        
        public function applyTorque(torque:Number):void
        {
            _body.ApplyTorque(torque);
        }
        
        public function dispose():void
        {
            _world.world.DestroyBody(_body);
            _world = null;
            
            _body = null;
        }
    }
}