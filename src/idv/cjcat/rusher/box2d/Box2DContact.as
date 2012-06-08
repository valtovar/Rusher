package idv.cjcat.rusher.box2d 
{
    import Box2D.Dynamics.Contacts.b2Contact;
    
    internal class Box2DContact implements IBox2DContact
    {
        
        public var contact:b2Contact;
        
        public function get bodyA():Box2DBody
        {
            return Box2DBody(contact.GetFixtureA().GetBody().GetUserData());
        }
        
        public function get bodyB():Box2DBody
        {
            return Box2DBody(contact.GetFixtureB().GetBody().GetUserData());
        }
        
        public function enable():void
        {
            contact.SetEnabled(true);
        }
        
        public function disable():void
        {
            contact.SetEnabled(false);
        }
    }
}