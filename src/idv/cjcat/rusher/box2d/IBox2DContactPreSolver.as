package idv.cjcat.rusher.box2d 
{
    import idv.cjcat.rusher.utils.geom.Vec2D;
    
    public interface IBox2DContactPreSolver 
    {
        function preSolve(contact:IBox2DContact):void;
    }
}