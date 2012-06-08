package idv.cjcat.rusher.box2d 
{
    public interface IBox2DShapeCreator 
    {
        function createCircle
        (
            centerX:Number, 
            centerY:Number, 
            radius:Number, 
            density:Number = 1, 
            restitution:Number = 0.5, 
            isSensor:Boolean = false, 
            categoryBits:uint = 0x0001, 
            maskBits:uint = 0xFFFF, 
            groupIndex:uint = 0
        ):void;
        
        function createBox
        (
            width:Number, 
            height:Number, 
            density:Number = 1, 
            restitution:Number = 0.5, 
            isSensor:Boolean = false, 
            categoryBits:uint = 0x0001, 
            maskBits:uint = 0xFFFF, 
            groupIndex:uint = 0
        ):void;
        
        function createOrientedBox
        (
            centerX:Number, 
            centerY:Number, 
            width:Number, 
            height:Number, 
            angle:Number = 0, 
            density:Number = 1, 
            restitution:Number = 0.5, 
            isSensor:Boolean = false, 
            categoryBits:uint = 0x0001, 
            maskBits:uint = 0xFFFF, 
            groupIndex:uint = 0
        ):void;
        
        function createPolygon
        (
            vertices:Array, 
            density:Number = 1, 
            restitution:Number = 0.5, 
            isSensor:Boolean = false, 
            categoryBits:uint = 0x0001, 
            maskBits:uint = 0xFFFF, 
            groupIndex:uint = 0
        ):void;
        
        function createEdge
        (
            x1:Number, 
            y1:Number, 
            x2:Number, 
            y2:Number, 
            density:Number = 1, 
            restitution:Number = 0.5, 
            isSensor:Boolean = false, 
            categoryBits:uint = 0x0001, 
            maskBits:uint = 0xFFFF, 
            groupIndex:uint = 0
        ):void;
    }
}