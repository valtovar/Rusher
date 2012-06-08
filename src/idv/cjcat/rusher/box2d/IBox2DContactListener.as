package idv.cjcat.rusher.box2d 
{
	
    public interface IBox2DContactListener 
    {
        function beginContact(contact:IBox2DContactListener):void;
        function endCContact(contact:IBox2DContactListener):void;
    }
}