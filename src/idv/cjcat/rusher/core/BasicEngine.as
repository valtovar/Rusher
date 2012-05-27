package idv.cjcat.rusher.core 
{
    import idv.cjcat.rusher.clock.Clock;
    import idv.cjcat.rusher.command.CommandManager;
    import idv.cjcat.rusher.ui.Keyboard;
    import idv.cjcat.rusher.ui.Mouse;
    
    /**
     * Basic engine with clock, UI, and command systems.
     */
    public class BasicEngine extends Engine
    {
        public function BasicEngine() 
        {
            
        }
        
        override protected function addSystems(systemManager:ISystemManager):void 
        {
            systemManager.addSystem(new Clock());
            systemManager.addSystem(new CommandManager());
            
            //UI systems that require the clock system
            systemManager.addSystem(new Keyboard());
            systemManager.addSystem(new Mouse());
        }
    }
}