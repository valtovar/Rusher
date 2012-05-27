package idv.cjcat.rusher.core 
{
    /**
     * Entity manager interface.
     */
    public interface IEntityManager extends IDisposable
    {
        /**
         * Whether an entity with the name provided has been created.
         * @param    name
         * @return
         */
        function hasEntity(name:String):Boolean;
        /**
         * Get entity reference by name.
         * @param    name
         * @return
         */
        function getEntity(name:String):IEntity;
        /**
         * Create an entity.
         * @param    name
         * @return
         */
        function createEntity(name:String = ""):IEntity;
        /**
         * Remove an entity.
         * @param    name
         */
        function removeEntity(name:String):void;
        /**
         * Remove all entities.
         */
        function clearEntities():void;
        
        /**
         * Get the collection of entities with component types specified in the node class.
         * @param    NodeClass
         * @return
         */
        function getEntityCollection(NodeClass:Class):IEntityCollection;
        
        /**
         * Dispose the collection of the specified node class.
         * @param	NodeClass
         */
        function disposeEntityCollection(NodeClass:Class):void;
    }
}