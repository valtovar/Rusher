package idv.cjcat.rusher.state 
{
    import idv.cjcat.rusher.core.ISystem;
    import idv.cjcat.rusher.state.StateMachine;
    
    public class StateSystem extends StateMachine implements ISystem
    {
        
        public function StateSystem(initState:State = null) 
        {
            super(initState);
        }
        
        public function onAdd():void
        {
            
        }
    }
}