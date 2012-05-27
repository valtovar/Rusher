package idv.cjcat.rusher.starling 
{
    import starling.display.Sprite;
    
    internal class StarlingCanvas extends Sprite
    {
        private static var _instance:StarlingCanvas;  
        public static function get instance():StarlingCanvas { return _instance; }
        
        public function StarlingCanvas() 
        {
            if (_instance) throw new Error("Only one instance can be created.");
            _instance = this;
        }
    }
}