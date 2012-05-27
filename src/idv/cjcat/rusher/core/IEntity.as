package idv.cjcat.rusher.core 
{
    /**
     * Entity interface.
     */
    public interface IEntity extends IDisposable
    {
        /**
         * The name of the entity.
         */
        function get name():String;
        
        /**
         * Whether this entity has the component of the component class provided.
         * @param    ComponentClass
         * @return
         */
        function hasComponent(ComponentClass:Class):Boolean;
        
        /**
         * Get the component of the component class provided.
         * @param    ComponentClass
         * @return
         */
        function getComponent(ComponentClass:Class, entityName:String = ""):*;
        
        /**
         * Add a component.
         * @param    ComponentClass
         */
        function addComponent(component:IComponent):Boolean;
        
        /**
         * Remove a component.
         * @param    ComponentClass
         */
        function removeComponent(ComponentClass:Class):Boolean;
        /**
         * Remove all components.
         */
        function clearComponents():void;
        
        /**
         * Destroy this component and remove it from its entity manager.
         */
        function destroy():void;
    }
}