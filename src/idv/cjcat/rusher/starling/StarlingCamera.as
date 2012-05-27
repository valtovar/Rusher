package idv.cjcat.rusher.starling 
{
    import idv.cjcat.rusher.core.IComponent;
    
    public class StarlingCamera implements IComponent
    {
        public var x:Number;
        public var y:Number;
        public var z:Number;
        public var rotation:Number;
        public var focalLength:Number;
        
        public function StarlingCamera
        (
            focalLength:Number = 200, 
            zoom:Number = 1
        )
        {
            x = y = rotation = 0;
            this.z = z;
            
            this.focalLength = focalLength;
        }
        
        public function dispose():void
        {
            
        }
    }
}