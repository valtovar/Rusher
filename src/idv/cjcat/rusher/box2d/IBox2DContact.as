package idv.cjcat.rusher.box2d 
{
	
    public interface IBox2DContact 
    {
        function get bodyA():Box2DBody;
        function get bodyB():Box2DBody;
        function enable():void;
        function disable():void;
    }
}