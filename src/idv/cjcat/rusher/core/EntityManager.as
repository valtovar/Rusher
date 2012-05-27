package idv.cjcat.rusher.core 
{
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    import org.swiftsuspenders.Injector;
    
    /**
     * Manages entity creation and removal. 
     * Also managers the entity collections to be up-to-date.
     */
    internal final class EntityManager implements IEntityManager
    {
        //(key, value) = (name, component);
        private var _entities:Dictionary = new Dictionary();
        //(key, value) = (node class, needed component array)
        private var _neededComponents:Dictionary = new Dictionary();
        private var _entityCollections:Dictionary = new Dictionary();
        
        private var _injector:Injector;
        public function EntityManager(injector:Injector)
        {
            _injector = injector;
        }
        
        public function hasEntity(name:String):Boolean
        {
            return Boolean(_entities[name]);
        }
        
        public function getEntity(name:String):IEntity
        {
            if (_injector.satisfies(IEntity, name))
            {
                return _injector.getInstance(IEntity, name);
            }
            else
            {
                trace("WARNING: Entity name \"" + name + "\" not found.");
                return null;
            }
        }
        
        private var _nameCounter:uint = 0;
        public function createEntity(name:String = ""):IEntity
        {
            //assign default name
            if (name == "") name = "entity" + (_nameCounter++);
            
            var entity:Entity = _entities[name];
            if (entity)
            {
                trace("WARNING: The entity name \"" + name + "\" is already used.");
                return null;
            }
            
            //create new entity
            entity = new Entity(name, this, _injector.createChildInjector());
            
            //add to entity set
            _entities[name] = entity;
            
            addToAllMatchingCollections(entity);
            
            return entity;
        }
        
        public function removeEntity(name:String):void
        {
            var entity:Entity = _entities[name];
            if (entity)
            {
                delete _entities[name];
                
                removeFromAllMathcingCollections(entity);
                
                entity.dispose();
                
                return;
            }
            trace("WARNING: Entity name \"" + name + "\" not found.");
        }
        
        public function clearEntities():void
        {
            for (var entity:* in _entities)
            {
                removeEntity(entity);
            }
        }
        
        public function dispose():void
        {
            _entities = null;
            _injector = null;
        }
        
        public function getEntityCollection(NodeClass:Class):IEntityCollection
        {
            //check if such colection already exists
            var collection:EntityList = _entityCollections[NodeClass];
            if (collection) return collection;
            
            
            //if no, create new collection
            _entityCollections[NodeClass] = collection = new EntityList(NodeClass);
            
            //cache needed components
            var neededComponents:Array = EntityNode(new NodeClass())._getNeededComponents();
            _neededComponents[NodeClass] = neededComponents;
            
            //populate new collection with existing matching entites
            for (var key:* in _entities)
            {
                var entity:Entity = _entities[key];
                var match:Boolean = true;
                for (var i:int = 0, len:int = neededComponents.length; i < len; ++i)
                {
                    if (!entity.hasComponent(neededComponents[i]))
                    {
                        match = false;
                        break;
                    }
                }
                if (match) collection.add(entity);
            }
            
            return collection;
        }
        
        public function disposeEntityCollection(NodeClass:Class):void
        {
            //check if such colection exists
            var collection:EntityList = _entityCollections[NodeClass];
            if (collection)
            {
                collection.dispose();
                
                //remove dictionaries
                delete _neededComponents[NodeClass];
                delete _entityCollections[NodeClass];
                return;
            }
            
            trace("WARNING: Entity collection for " + NodeClass + " not found.");
        }
        
        internal function addToAllMatchingCollections(entity:Entity):void
        {
            matchCollection(entity, 1);
        }
        
        internal function removeFromAllMathcingCollections(entity:Entity):void
        {
            matchCollection(entity, 0);
        }
        
        internal function matchCollection(entity:IEntity, operation:int):void
        {
            //add to all matching entity collections
            for (var key:* in _entityCollections)
            {
                //var node:EntityNode = new key();
                var neededComponents:Array = _neededComponents[key];
                
                //check for matching component types
                var match:Boolean = true;
                var e:Entity = Entity(entity);
                for (var i:int = 0, len:int = neededComponents.length; i < len; ++i)
                {
                    if (!entity.hasComponent(neededComponents[i]))
                    {
                        match = false;
                        break;
                    }
                }
                
                if (match)
                {
                    if (operation) EntityList(_entityCollections[key]).add(entity);
                    else EntityList(_entityCollections[key]).remove(entity)
                }
            }
        }
    }
}