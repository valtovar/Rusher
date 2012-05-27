package idv.cjcat.rusher.state 
{
    import idv.cjcat.rusher.core.IComponent;
	import idv.cjcat.rusher.core.IDisposable;
	import idv.cjcat.rusher.core.ISystem;
	import idv.cjcat.rusher.clock.Clock;
	import idv.cjcat.rusher.command.Command;
	import idv.cjcat.rusher.command.CommandManager;
    import org.swiftsuspenders.Injector;
	
	public class StateMachine implements IComponent, IDisposable
	{
        private var _inTransition:Boolean = false;
        private var _targetState:State;
        private var _currentState:State;
        
        private var _initState:State;
        
        public function StateMachine(initState:State = null)
        {
            _initState = initState;
        }
        
        private var _clock:Clock;
        private var _commandManager:CommandManager;
        private var _injector:Injector;
        [Inject]
        public function inject(clock:Clock, commandManager:CommandManager, injector:Injector):void
        {
            _clock = clock;
            _commandManager = commandManager;
            _injector = injector;
            
            _clock.add(update);
            
            //start init state
            if (_initState) setState(_initState);
        }
        
        public function dispose():void
        {
            _clock.remove(update);
            _clock = null;
            
            _injector.unmap(StateMachine);
            _injector = null;
            
            _commandManager = null;
            _targetState = null;
            _currentState = null;
        }
        
        private function update(dt:Number):void
        {
            if (_currentState && !_inTransition) _currentState.update(dt);
        }
        
        public function input(value:*):void {
            if (_inTransition) {
            trace("State transition in action. Input ignored.")
            return;
            }
            
            if (_currentState) _currentState.input(value);
        }
        
        public function setState(state:State):void {
            if (!state) return;
            
            //ignore new state when transition is in action
            if (_inTransition)
            {
                trace("WARNING: State transition in action. State not chnaged.");
                return;
            }
            
            _inTransition = true;
            _targetState = state;
            
            if (_currentState)
            {
                
                //execute exit command
                var exitCommand:Command = _currentState.getExitCommand();
                exitCommand.onComplete.addOnce(onCurrentStateExit);
                _commandManager.execute(exitCommand);
            }
            else
            {
                //switch to target state
                _targetState.stateMachine = this;
                
                //dependency injection
                _injector.injectInto(_targetState);
                
                //execute enter command
                var enterCommand:Command = _targetState.getEnterCommand();
                enterCommand.onComplete.addOnce(onTargetStateEnter);
                _commandManager.execute(enterCommand);
            }
        }
        
        private function onCurrentStateExit(command:Command):void
        {
            _currentState.dispose();
            _currentState.stateMachine = null;
            _targetState.stateMachine = this;
            
            //dependency injection
            _injector.injectInto(_targetState);
            
            var enterCommand:Command = _targetState.getEnterCommand();
            enterCommand.onComplete.addOnce(onTargetStateEnter);
            _commandManager.execute(enterCommand);
        }
        
        private function onTargetStateEnter(command:Command):void {
            _currentState = _targetState;
            _inTransition = false;
            _targetState = null;
            
            _currentState.onSet();
        }
	}
}