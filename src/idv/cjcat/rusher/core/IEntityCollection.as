package idv.cjcat.rusher.core 
{
    import org.osflash.signals.ISignal;
    
    /**
     * Entity collection interface.
     */
    public interface IEntityCollection
    {
        /**
         * Whether the collection contains an entity.
         * @param    entity
         * @return
         */
        function hasEntity(entity:IEntity):Boolean;
        
        /**
         * Dispatched when a new entity is added to the collection.
         * <br/>
         * Signature: (node:EntityNode)
         */
        function get onAdd():ISignal;
        /**
         * Dispatched when an entity is removed from the collection
         * <br/>
         * Signature: (node:EntityNode)
         */
        function get onRemove():ISignal;
        /**
         * Dispatched when the collection is cleared. 
         * <br/>
         * (All entities are removed)
         * <br/>
         * Signature: (collection:IEntityCollection)
         */
        function get onClear():ISignal;
        
        /**
         * Returns an iterator of this collection, pointing at the first node.
         * @return
         */
        function getIterator():IEntityIterator;
        
        /**
         * The number of nodes in this collection.
         * @return
         */
        function size():int;
    }
}