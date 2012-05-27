package idv.cjcat.rusher.box2d 
{
    import flash.utils.Dictionary;
    import idv.cjcat.rusher.core.EntityNode;
	
    internal class Box2DBodyNode extends EntityNode
    {
        
        override protected function getNeededComponents():Array 
        {
            return [Box2DBody];
        }
        
        public function Box2DBodyNode() 
        {
            
        }
        
        private var _body:Box2DBody;
        public function get body():Box2DBody { return _body; }
        
        override protected function pullComponents(components:Dictionary):void 
        {
            _body = components[Box2DBody];
        }
        
        override public function dispose():void 
        {
            super.dispose();
            _body = null;
        }
    }
}