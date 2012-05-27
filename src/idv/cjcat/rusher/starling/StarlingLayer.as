package idv.cjcat.rusher.starling 
{
    import idv.cjcat.rusher.core.IComponent;
    import org.osflash.signals.ISignal;
    import org.osflash.signals.Signal;
    import starling.display.DisplayObject;
    import starling.display.Sprite;
    
    public class StarlingLayer implements IComponent
    {
        /**
         * @private
         */
        internal var onZChange:ISignal = new Signal();
        /**
         * @private
         */
        internal var sprite:Sprite = new Sprite();
        
        
        public var x:Number;
        public var y:Number;
        public var z:Number;
        public var usePerspectiveScale:Boolean;
        
        public function StarlingLayer(z:Number = 0, usePerspectiveScale:Boolean = false) 
        {
            x = y = 0;
            this.z = z;
            
            this.usePerspectiveScale = usePerspectiveScale;
        }
        
        public function addChild(child:DisplayObject):void
        {
            sprite.addChild(child);
        }
        
        public function addChildAt(child:DisplayObject, index:int):void
        {
            sprite.addChildAt(child, index);
        }
        
        public function removeChild(child:DisplayObject):void
        {
            sprite.removeChild(child);
        }
        
        public function removeChildAt(index:int):void
        {
            sprite.removeChildAt(index);
        }
        
        public function getChildAt(index:int):DisplayObject
        {
            return sprite.getChildAt(index);
        }
        
        public function dispose():void
        {
            onZChange.removeAll();
            onZChange = null;
        }
    }
}