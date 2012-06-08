package idv.cjcat.rusher.box2d 
{
    import Box2D.Collision.b2Manifold;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2ContactImpulse;
    import Box2D.Dynamics.b2ContactListener;
    import Box2D.Dynamics.Contacts.b2Contact;
    import idv.cjcat.rusher.utils.geom.Vec2D;
    import idv.cjcat.rusher.utils.ObjectPool;
	
    internal class Box2DContactListener extends b2ContactListener
    {
        
        public var preSolver:IBox2DContactPreSolver;
        public var postSolver:IBox2DContactPostSolver;
        
        private var _contactPool:ObjectPool = new ObjectPool(Box2DContact);
        
        override public function BeginContact(contact:b2Contact):void 
        {
            var bodyA:Box2DBody = contact.GetFixtureA().GetBody().GetUserData();
            var bodyB:Box2DBody = contact.GetFixtureB().GetBody().GetUserData();
            if (bodyA.enableContactSignals) bodyA.onContactBegin.dispatch(bodyB);
            if (bodyB.enableContactSignals) bodyB.onContactBegin.dispatch(bodyA);
        }
        
        override public function EndContact(contact:b2Contact):void 
        {
            var bodyA:Box2DBody = contact.GetFixtureA().GetBody().GetUserData();
            var bodyB:Box2DBody = contact.GetFixtureB().GetBody().GetUserData();
            if (bodyA.enableContactSignals) bodyA.onContactEnd.dispatch(bodyB);
            if (bodyB.enableContactSignals) bodyB.onContactEnd.dispatch(bodyA);
        }
        
        override public function PreSolve(contact:b2Contact, oldManifold:b2Manifold):void 
        {
            if (preSolver)
            {
                var c:Box2DContact = _contactPool.get();
                c.contact = contact;
                preSolver.preSolve(c);
                _contactPool.recycle(c);
            }
        }
        
        override public function PostSolve(contact:b2Contact, impulse:b2ContactImpulse):void 
        {
            if (postSolver)
            {
                var c:Box2DContact = _contactPool.get();
                c.contact = contact;
                postSolver.postSolve
                (
                    c, 
                    new Vec2D(impulse.normalImpulses[0], impulse.normalImpulses[1]), 
                    new Vec2D(impulse.tangentImpulses[0], impulse.tangentImpulses[1])
                );
                _contactPool.recycle(c);
            }
        }
    }
}