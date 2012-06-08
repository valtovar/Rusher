package idv.cjcat.rusher.box2d 
{
    import idv.cjcat.rusher.utils.geom.Vec2D;
	
    public interface IBox2DContactPostSolver 
    {
        function postSolve(contact:IBox2DContact, normalImpulse:Vec2D, tangentImpulse:Vec2D):void;
    }
}