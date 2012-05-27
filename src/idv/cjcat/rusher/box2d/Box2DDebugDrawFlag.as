package idv.cjcat.rusher.box2d 
{
    import Box2D.Dynamics.b2DebugDraw;
	
    public class Box2DDebugDrawFlag 
    {
        public static const AABB            :uint = b2DebugDraw.e_aabbBit;
        public static const CENTER_OF_MASS  :uint = b2DebugDraw.e_centerOfMassBit;
        public static const CONTROLLER      :uint = b2DebugDraw.e_controllerBit;
        public static const JOINT           :uint = b2DebugDraw.e_jointBit;
        public static const PAIR            :uint = b2DebugDraw.e_pairBit;
        public static const SHAPE           :uint = b2DebugDraw.e_shapeBit;
        
        public static const ALL             :uint = 
                                                b2DebugDraw.e_aabbBit |
                                                b2DebugDraw.e_centerOfMassBit |
                                                b2DebugDraw.e_controllerBit |
                                                b2DebugDraw.e_jointBit |
                                                b2DebugDraw.e_pairBit |
                                                b2DebugDraw.e_shapeBit;
    }
}