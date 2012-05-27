package idv.cjcat.rusher.core 
{
    import flash.display.Stage;
    import org.swiftsuspenders.Injector;
    
    /**
     * Core engine without any systems added to it.
     */
    public class Engine implements IEngine
    {
        private var _stage:Stage;
        protected function get stage():Stage { return _stage; }
        
        private var _injector:Injector;
        private var _systemManager:SystemManager;
        private var _entityManager:IEntityManager;
        
        public function Engine() 
        {
            
        }
        
        /**
         * @inheritDoc
         */
        public function start(stage:Stage):void
        {
            if (!stage) throw Error("Stage must not be null");
            _stage = stage;
            
            _injector = new Injector();
            _entityManager = new EntityManager(_injector);
            
            //add default rules to the injector
            mapDefaultRules(_injector);
            
            //construct injector rules
            mapInjector(_injector);
            
            //add systems
            addSystems(_systemManager = new SystemManager(_injector));
            
            //self injection
            _injector.injectInto(this);
        }
        
        private function mapDefaultRules(injector:Injector):void 
        {
            injector.map(Injector).toValue(injector);
            injector.map(Stage).toValue(stage);
            injector.map(ISystemManager).toValue(_systemManager);
            injector.map(IEntityManager).toValue(_entityManager);
        }
        
        /**
         * Override this method to map additional dependencies.
         * @param	injector
         */
        protected function mapInjector(injector:Injector):void
        {
            
        }
        
        /**
         * Override this method to add additional systems to the engine. 
         * Note the order of the systems is important if some of them are listening to a clock system. 
         * <p/>
         * Here's a general guide line for in what order systems are to be added:<br/>
         * Clock systems<br/>
         * Input systems<br/>
         * Physics systems<br/>
         * Rendering systems<br/>
         * @param	systemManager
         */
        protected function addSystems(systemManager:ISystemManager):void
        {
            
        }
        
        public function dispose():void
        {
            _stage = null;
            _injector = null;
            
            _systemManager.dispose();
            _systemManager = null;
        }
    }
}