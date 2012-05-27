package idv.cjcat.rusher.core 
{
    import flash.utils.Dictionary;
    import org.swiftsuspenders.Injector;
    
    internal class Entity implements IEntity
    {
        private var _name:String;
        public function get name():String { return _name; }
        
        private var _injector:Injector;
        private var _manager:EntityManager;
        
        //(key, value) = (class, component)
        internal var _components:Dictionary = new Dictionary();
        
        public function Entity(name:String, manager:EntityManager, injector:Injector) 
        {
            _name = name;
            _manager = manager;
            _injector = injector;
            
            //remap the Injector class to child injector
            _injector.map(Injector).toValue(_injector);
            
            _injector.map(IEntity).toValue(this);
            _injector.parentInjector.map(IEntity, name).toValue(this);
        }
        
        public function hasComponent(ComponentClass:Class):Boolean
        {
            return _injector.satisfies(ComponentClass);
        }
        
        public function getComponent(ComponentClass:Class, entityName:String = ""):*
        {
            if (hasComponent(ComponentClass))
            {
                return _injector.getInstance(ComponentClass, entityName);
            }
            else
            {
                trace("WARNING: Component type [" + ComponentClass + "] not found.");
                return null;
            }
        }
        
        public function addComponent(component:IComponent):Boolean
        {
            var ComponentClass:Class = Class(Object(component).constructor);
            if (_injector.satisfies(ComponentClass))
            {
                trace("WARNING: Component type [" + ComponentClass + "] already added.");
                return false;
            }
            else
            {
                //add component to set
                _components[ComponentClass] = component;
                
                //add component to injector
                _injector.map(ComponentClass).toValue(component);
                
                //add component to parent injector
                _injector.parentInjector.map(ComponentClass, _name).toValue(component);
                
                //populate entity lists
                _manager.addToAllMatchingCollections(this);
                
                //inject into component
                _injector.injectInto(component);
                
                return true;
            }
        }
        
        public function removeComponent(ComponentClass:Class):Boolean
        {
            if (hasComponent(ComponentClass))
            {
                //repopulate entity collections
                _manager.removeFromAllMathcingCollections(this);
                
                //remove component from injector
                _injector.unmap(ComponentClass);
                
                //remove component from parent injector
                _injector.parentInjector.unmap(ComponentClass, name);
                
                //remove name from internal name map
                var comp:IComponent = _components[ComponentClass];
                comp.dispose();
                delete _components[ComponentClass];
                
                return true;
            }
            else
            {
                trace("WARNING: Component " + ComponentClass + " not found.");
                return false;
            }
        }
        
        public function clearComponents():void
        {
            for (var ComponentClass:* in _components)
            {
                removeComponent(ComponentClass);
                delete _components[ComponentClass];
            }
        }
        
        public function destroy():void
        {
            _manager.removeEntity(this.name);
        }
        
        public function dispose():void
        {
            clearComponents();
            
            _manager = null;
            _components = null;
            
            _injector.parentInjector.unmap(IEntity, _name);
            
            _injector.unmap(IEntity);
            _injector = null;
        }
    }
}