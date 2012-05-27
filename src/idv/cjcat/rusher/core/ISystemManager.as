package idv.cjcat.rusher.core 
{
    public interface ISystemManager extends IDisposable
    {
        /**
         * Add a system to the engine.
         * @param    system
         */
        function addSystem(system:ISystem):void;
        /**
         * Remove a system from the engine.
         * @param    system
         */
        function removeSystem(system:ISystem):void;
        /**
         * Remove a system from the engine by class.
         * @param    SystemClass
         */
        function removeSystemByClass(SystemClass:Class):void;
        /**
         * Remove all systems from the engine.
         */
        function clearSystems():void;
    }
}