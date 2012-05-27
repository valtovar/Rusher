package idv.cjcat.rusher.core 
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    
    internal final class SystemManager implements ISystemManager
    {
        private var _injector:Injector;
        private var _systems:Dictionary;
        
        public function SystemManager(injector:Injector) 
        {
            _injector = injector;
            _systems = new Dictionary();
        }
        
        public function addSystem(system:ISystem):void
        {
            var SystemClass:Class = Class(Object(system).constructor);
            var s:ISystem = _systems[SystemClass];
            
            if (s)
            {
                trace("WARNING: System type " + SystemClass + " already added.");
                return;
            }
            
            //add system to system set & injector
            _injector.map(SystemClass).toValue(system);
            _systems[SystemClass] = system;
            
            //dependency injection
            _injector.injectInto(system);
            
            system.onAdd();
        }
        
        public function removeSystem(system:ISystem):void
        {
            removeSystemByClass(Class(Object(system).constructor));
        }
        
        public function removeSystemByClass(SystemClass:Class):void
        {
            var s:ISystem = _systems[SystemClass];
            
            if (s)
            {
                //remove from injector
                _injector.unmap(SystemClass);
                
                //delete system key from system set
                delete _systems[s];
                
                s.dispose();
                
                return;
            }
            trace("WARNING: System " + s + " not found.");
        }
        
        public function clearSystems():void
        {
            //delete all system keys from system set
            for (var systemClass:* in _systems)
            {
                //remove from injector
                _injector.unmap(systemClass);
                
                delete _systems[systemClass];
            }
        }
        
        public function dispose():void
        {
            for (var key:* in _systems)
            {
                var s:ISystem = _systems[key];
                s.dispose();
                delete _systems[key];
            }
            _systems = null;
            
            _injector = null;
        }
    }
}