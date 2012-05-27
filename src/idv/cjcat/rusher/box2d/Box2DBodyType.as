package idv.cjcat.rusher.box2d 
{
    import Box2D.Dynamics.b2Body;
	
    public class Box2DBodyType 
    {
        public static const DYNAMIC    :uint = b2Body.b2_dynamicBody;
        public static const KINEMATIC  :uint = b2Body.b2_kinematicBody;
        public static const STATIC     :uint = b2Body.b2_staticBody;
    }
}