package idv.cjcat.rusher.box2d 
{
    import Box2D.Dynamics.Joints.b2GearJoint;
    import Box2D.Dynamics.Joints.b2GearJointDef;
    import idv.cjcat.rusher.core.IComponent;
    
    public class Box2DGearJoint implements IComponent
    {
        private var _ratio:Number;
        public function get ratio():Number { return _ratio; }
        public function set ratio(value:Number):void
        {
            _ratio = value;
            if (_joint) _joint.SetRatio(_ratio);
        }
        
        /*
        private var _bodyA:Box2DBody;
        public function get bodyA():Box2DBody { return _bodyA; }
        public function set bodyA(value:Box2DBody):void
        {
            _bodyA = value;
            if (_bodyA && _bodyB && _joint1 && _joint2 && _world) buildJoint();
            else destroyJoint();
        }
        
        private var _bodyB:Box2DBody;
        public function get bodyB():Box2DBody { return _bodyB; }
        public function set bodyB(value:Box2DBody):void
        {
            _bodyB = value;
            if (_bodyA && _bodyB && _joint1 && _joint2 && _world) buildJoint();
            if (_joint1 && _joint2 && _world) buildJoint();
            else destroyJoint();
        }
        */
        
        private var _jointA:IBox2DGearJointTarget;
        public function get jointA():IBox2DGearJointTarget { return _jointA; }
        public function set jointA(value:IBox2DGearJointTarget):void
        {
            _jointA = value;
            //if (_bodyA && _bodyB && _joint1 && _joint2 && _world) buildJoint();
            if (_jointA && _jointB && _world) buildJoint();
            else destroyJoint();
        }
        
        private var _jointB:IBox2DGearJointTarget;
        public function get jointB():IBox2DGearJointTarget { return _jointB; }
        public function set jointB(value:IBox2DGearJointTarget):void
        {
            _jointB = value;
            //if (_bodyA && _bodyB && _joint1 && _joint2 && _world) buildJoint();
            if (_jointA && _jointB && _world) buildJoint();
            else destroyJoint();
        }
        
        
        public function Box2DGearJoint(ratio:Number = 1)
        {
            _ratio = ratio;
        }
        
        private var _joint:b2GearJoint;
        
        private var _world:Box2DWorld;
        [Inject]
        public function inject(world:Box2DWorld):void
        {
            _world = world;
            //if (_bodyA && _bodyB && _joint1 && _joint2 && _world) buildJoint();
            if (_jointA && _jointB && _world) buildJoint();
        }
        
        private function buildJoint():void
        {
            //destroyy previous joint
            destroyJoint();
            
            var jointDef:b2GearJointDef = new b2GearJointDef();
            jointDef.joint1 = _jointA["_joint"];
            jointDef.joint2 = _jointB["_joint"];
            jointDef.bodyA = jointDef.joint1.GetBodyA();
            jointDef.bodyB = jointDef.joint2.GetBodyB();
            jointDef.ratio = _ratio;
            
            _joint = b2GearJoint(_world.world.CreateJoint(jointDef));
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