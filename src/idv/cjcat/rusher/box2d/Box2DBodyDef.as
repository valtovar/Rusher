package idv.cjcat.rusher.box2d 
{
    import Box2D.Dynamics.b2BodyDef;
    import idv.cjcat.rusher.utils.geom.Vec2D;
    import idv.cjcat.rusher.utils.RusherMath;
	
    public class Box2DBodyDef
    {
        
        private var _bodyDef:b2BodyDef = new b2BodyDef();
        /**
         * @private
         */
        internal function getBodyDef():b2BodyDef
        {
            _bodyDef.active             = active;
            _bodyDef.allowSleep         = allowSleep;
            _bodyDef.angle              = rotation * RusherMath.DEGREE_TO_RADIAN;
            _bodyDef.angularDamping     = angularDamping;
            _bodyDef.angularVelocity    = angularVelocity * RusherMath.DEGREE_TO_RADIAN;
            _bodyDef.awake              = awake;
            _bodyDef.bullet             = bullet;
            _bodyDef.fixedRotation      = fixedRotation;
            _bodyDef.inertiaScale       = inertiaScale;
            _bodyDef.linearDamping      = linearDamping;
            _bodyDef.linearVelocity.x   = linearVelocity.x * Box2DWorld.PIXELS_TO_METERS;
            _bodyDef.linearVelocity.y   = linearVelocity.y * Box2DWorld.PIXELS_TO_METERS;
            _bodyDef.position.x         = position.x * Box2DWorld.PIXELS_TO_METERS;
            _bodyDef.position.y         = position.y * Box2DWorld.PIXELS_TO_METERS;
            _bodyDef.type               = type;
            
            return _bodyDef;
        }
        
        private var _position:Vec2D = new Vec2D(0, 0);
        public function get position():Vec2D { return _position; }
        
        private var _linearVelocity:Vec2D = new Vec2D(0, 0);
        public function get linearVelocity():Vec2D { return _linearVelocity; }
        
        public var active           :Boolean    = true;
        public var allowSleep       :Boolean    = false;
        public var rotation         :Number     = 0;
        public var angularDamping   :Number     = 0;
        public var angularVelocity  :Number     = 0;
        public var awake            :Boolean    = true;
        public var bullet           :Boolean    = false;
        public var fixedRotation    :Boolean    = false;
        public var inertiaScale     :Number     = 1;
        public var linearDamping    :Number     = 0;
        public var type             :uint       = Box2DBodyType.DYNAMIC;
        
        
        
        public function Box2DBodyDef
        (
            type:uint = 2, 
            bullet:Boolean = false
        ) 
        {
            this.type = type;
            this.bullet = bullet;
        }
        
        public function createShapes(shapeCreator:IBox2DShapeCreator):void
        {
            
        }
    }
}