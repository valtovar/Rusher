package idv.cjcat.rusher.box2d 
{
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.Joints.b2PrismaticJoint;
    import Box2D.Dynamics.Joints.b2PrismaticJointDef;
    import Box2D.Dynamics.Joints.b2PulleyJoint;
    import Box2D.Dynamics.Joints.b2PulleyJointDef;
    import flash.geom.Vector3D;
    import idv.cjcat.rusher.core.IComponent;
    import idv.cjcat.rusher.utils.geom.Vec2D;
    import idv.cjcat.rusher.utils.RusherMath;
    
    public class Box2DPulleyJoint implements IComponent
    {
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
        
        private var _groundAnchorA:b2Vec2 = new b2Vec2(0, 0);
        public function get groundAnchorA():Vec2D
        {
            return new Vec2D
            (
                _groundAnchorA.x * Box2DWorld.METERS_TO_PIXELS, 
                _groundAnchorA.y * Box2DWorld.METERS_TO_PIXELS
            );
        }
        public function set groundAnchorA(value:Vec2D):void
        {
            _groundAnchorA.Set
            (
                value.x * Box2DWorld.PIXELS_TO_METERS, 
                value.y * Box2DWorld.PIXELS_TO_METERS
            );
            if (_bodyA && _bodyB && _world) buildJoint();
        }
        
        private var _groundAnchorB:b2Vec2 = new b2Vec2(0, 0);
        public function get groundAnchorB():Vec2D
        {
            return new Vec2D
            (
                _groundAnchorB.x * Box2DWorld.METERS_TO_PIXELS, 
                _groundAnchorB.y * Box2DWorld.METERS_TO_PIXELS
            );
        }
        public function set groundAnchorB(value:Vec2D):void
        {
            _groundAnchorB.Set
            (
                value.x * Box2DWorld.PIXELS_TO_METERS, 
                value.y * Box2DWorld.PIXELS_TO_METERS
            );
            if (_bodyA && _bodyB && _world) buildJoint();
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
        
        private var _ratio:Number;
        public function get ratio():Number { return _ratio; }
        public function set ratio(value:Number):void
        {
            _ratio = value;
            if (_bodyA && _bodyB && _world) buildJoint();
        }
        
        private var _maxLengthA:Number;
        public function get maxLengthA():Number { return _maxLengthA; }
        public function set maxLengthA(value:Number):void
        {
            _maxLengthA = value;
            if (_bodyA && _bodyB && _world) buildJoint();
        }
        
        private var _maxLengthB:Number;
        public function get maxLengthB():Number { return _maxLengthB; }
        public function set maxLengthB(value:Number):void
        {
            _maxLengthB = value;
            if (_bodyA && _bodyB && _world) buildJoint();
        }
        
        public function get lengthA():Number
        {
            if (_joint) return _joint.GetLength1();
            else return 0;
        }
        
        public function get lengthB():Number
        {
            if (_joint) return _joint.GetLength2();
            else return 0;
        }
        
        public function Box2DPulleyJoint
        (
            groundAnchorA:Vec2D = null, 
            groundAnchorB:Vec2D = null, 
            ratio:Number = 1, 
            localAnchorA:Vec2D = null, 
            localAnchorB:Vec2D = null, 
            maxLengthA:Number = -1, 
            maxLengthB:Number = -1
        ) 
        {
            if (!groundAnchorA) groundAnchorA = new Vec2D(0, 0);
            if (!groundAnchorB) groundAnchorB = new Vec2D(0, 0);
            if (!localAnchorA) localAnchorA = new Vec2D(0, 0);
            if (!localAnchorB) localAnchorB = new Vec2D(0, 0);
            
            this.groundAnchorA = groundAnchorA;
            this.groundAnchorB = groundAnchorB;
            this.localAnchorA = localAnchorA;
            this.localAnchorB = localAnchorB;
            
            _ratio = ratio;
        }
        
        /**
         * @private
         */
        internal var _joint:b2PulleyJoint;
        
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
            
            var jointDef:b2PulleyJointDef = new b2PulleyJointDef();
            jointDef.bodyA = _bodyA.body;
            jointDef.bodyB = _bodyB.body;
            
            var anchorA:b2Vec2 = jointDef.bodyA.GetPosition().Copy();
            var anchorB:b2Vec2 = jointDef.bodyB.GetPosition().Copy();
            anchorA.Add(_localAnchorA);
            anchorB.Add(_localAnchorB);
            jointDef.Initialize
            (
                jointDef.bodyA, 
                jointDef.bodyB, 
                _groundAnchorA, 
                _groundAnchorB, 
                anchorA, 
                anchorB, 
                _ratio
            );
            jointDef.collideConnected = true;
            _joint = b2PulleyJoint(_world.world.CreateJoint(jointDef));
            return;
            
            
            /*
            //destroyy previous joint
            destroyJoint();
            
            var jointDef:b2PulleyJointDef = new b2PulleyJointDef();
            jointDef.bodyA = _bodyA.body;
            jointDef.bodyB = _bodyB.body;
            
            jointDef.groundAnchorA = _groundAnchorA;
            jointDef.groundAnchorB = _groundAnchorB;
            jointDef.localAnchorA = _localAnchorA;
            jointDef.localAnchorB = _localAnchorB;
            
            var posA:b2Vec2 = jointDef.bodyA.GetPosition();
            var posB:b2Vec2 = jointDef.bodyB.GetPosition();
            jointDef.lengthA = new b2Vec2
                (
                    posA.x + _localAnchorA.x - _groundAnchorA.x, 
                    posA.y + _localAnchorA.y - _groundAnchorA.y
                ).Length();
            jointDef.lengthB = new b2Vec2
                (
                    posB.x + _localAnchorB.x - _groundAnchorB.x, 
                    posB.y + _localAnchorB.y - _groundAnchorB.y
                ).Length();
            
            //var maxLengthA:Number = _maxLengthA;
            if (maxLengthA < 0) maxLengthA = 1;
            //var maxLengthB:Number = _maxLengthB;
            if (maxLengthB < 0) maxLengthB = 1;
            //jointDef.maxLengthA = _maxLengthA;
            //jointDef.maxLengthB = _maxLengthB;
            
            jointDef.ratio = _ratio;
            
            jointDef.collideConnected = true;
            
            _joint = b2PulleyJoint(_world.world.CreateJoint(jointDef));
            */
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