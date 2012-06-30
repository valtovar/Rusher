package idv.cjcat.rusher.engine 
{
  import flash.display.Stage;
  import flash.utils.Dictionary;
  import idv.cjcat.rusher.utils.construct;
  import org.swiftsuspenders.Injector;
  
  public class Engine
  {
    private var systems_  :Vector.<ISystem> = new Vector.<ISystem>();
    private var injector_ :Injector         = new Injector();
    
    public function Engine(stage:Stage)
    {
      injector_.map(Stage).toValue(stage);
      injector_.map(Engine).toValue(this);
    }
    
    public function getInjector():Injector { return injector_; }
    
    public function update(dt:Number):void
    {
      for (var i:int = 0, len:int = systems_.length; i < len; ++i)
      {
        systems_[i].update(dt);
      }
    }
    
    public function addSystem(SystemClass:Class, ...params):*
    {
      //check duplicate system
      if (injector_.satisfies(SystemClass)) throw new Error("System " + SystemClass + " already added.");
      
      //add system to engine
      var system:ISystem = construct(SystemClass, params);
      
      //map injector
      injector_.map(SystemClass).toValue(system);
      
      //initialize system
      systems_.push(system);
      system.setInjector(injector_);
      
      injector_.injectInto(system);
      system.init();
      
      return system;
    }
    
    public function removeSystem(SystemClass:Class):void
    {
      //check system existence
      if (!injector_.satisfies(SystemClass)) throw new Error("System " + SystemClass + " not found.");
      
      var system:ISystem = getInstance(SystemClass);
      
      //dispose system
      system.dispose();
      
      //remove system from engine
      systems_.splice(systems_.indexOf(system), 1);
      system.setInjector(null);
      
      //unmap injector
      injector_.unmap(SystemClass);
    }
    
    public function getInstance(SystemClass:Class):*
    {
      return injector_.getInstance(SystemClass);
    }
    
    private var entityCounter_:int = 0;
    public function createEntity(name:String = null):Entity
    {
      //check duplicate entity name
      if (injector_.satisfies(Entity, name)) throw new Error("Entity named\"" + name + "\" already exists.");
      
      if (!name) name = "entity" + entityCounter_++;
      
      //add entity to engine
      var entity:Entity = new Entity(name);
      injector_.map(Entity, name).toValue(entity);
      
      //inject child injector
      var childInjector:Injector = injector_.createChildInjector();
      childInjector.map(Entity).toValue(entity);
      entity.setInjector(childInjector);
      
      return entity;
    }
    
    //TODO: late removal
    public function destroyEntity(name:String):void
    {
      //check entity name existence
      if (!injector_.satisfies(Entity, name)) throw new Error("Entity named\"" + name + "\" does not exist.");
      
      var entity:Entity = getEntity(name);
      
      //remove entity from system
      entity.dispose();
      injector_.unmap(Entity, name);
      entity.setInjector(null);
    }
    
    public function getEntity(name:String):Entity
    {
      return injector_.getInstance(Entity, name);
    }
  }
}
