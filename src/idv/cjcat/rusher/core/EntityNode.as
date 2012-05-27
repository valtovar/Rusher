package idv.cjcat.rusher.core 
{
    import flash.utils.Dictionary;
    
    /**
     * Base class for entity collection nodes.
     */
    public class EntityNode implements IDisposable
    {
        /**
         * @private
         */
        internal var _next:EntityNode;
        /**
         * @private
         */
        internal var _prev:EntityNode;
        
        /**
         * @private
         */
        internal var _entity:Entity;
        public function get entity():IEntity { return _entity; }
        
        public function EntityNode() 
        {
            
        }
        
        /**
         * @private
         */
        internal function _getNeededComponents():Array { return getNeededComponents(); }
        
        /**
         * Override this method to return an array of required component classes.
         * @return
         */
        protected function getNeededComponents():Array
        {
            return [];
        }
        
        /**
         * @private
         */
        internal function injectData(entity:Entity):void
        {
            _entity = entity;
            pullComponents(_entity._components);
        }
        
        /**
         * Override this method to obtain component references. 
         * The dictionary key is the component class.
         * @param    components
         */
        protected function pullComponents(components:Dictionary):void
        {
            
        }
        
        public function dispose():void
        {
            _entity = null;
        }
    }
}