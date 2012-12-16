package rusher.engine 
{
  import flash.display.Stage;
  import flash.utils.Dictionary;
  import rusher.utils.construct;
  import org.swiftsuspenders.Injector;
  
  public class Engine
  {
    private var systems_  :Vector.<ISystem> = new Vector.<ISystem>();
    private var injector_ :Injector         = new Injector();
    private var entitiesToDestroy_:Vector.<Entity> = new Vector.<Entity>();
    
    public function Engine(stage:Stage)
    {
      injector_.map(Stage).toValue(stage);
      injector_.map(Engine).toValue(this);
    }
    
    public function getInjector():Injector { return injector_; }
    
    public function update(dt:Number):void
    {
      var i:int, len:int;
      for (i = 0, len = systems_.length; i < len; ++i)
      {
        if (systems_[i].active) systems_[i].update(dt);
      }
      
      //remove entities marked for destruction from engine
      for (i = 0, len = entitiesToDestroy_.length; i < len; ++i)
      {
        var entity:Entity = entitiesToDestroy_[i];
        
        //destroy components
        entity.dispose();
        
        //unroll dependency
        injector_.unmap(Entity, entity.name());
        entity.setInjector(null);
      }
      entitiesToDestroy_.length = 0;
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
    
    private var entityCounter_:uint = 0;
    public function createEntity(name:String = null):Entity
    {
      //check duplicate entity name
      if (injector_.satisfies(Entity, name)) throw new Error("Entity named\"" + name + "\" already exists.");
      
      if (!name) name = "__entity" + entityCounter_++;
      
      //add entity to engine
      var entity:Entity = new Entity(name);
      injector_.map(Entity, name).toValue(entity);
      
      //inject child injector
      var childInjector:Injector = injector_.createChildInjector();
      childInjector.map(Entity).toValue(entity);
      entity.setInjector(childInjector);
      
      return entity;
    }
    
    public function destroyEntity(name:String):void
    {
      //check entity name existence
      if (!injector_.satisfies(Entity, name)) throw new Error("Entity named\"" + name + "\" does not exist.");
      
      entitiesToDestroy_.push(getEntity(name));
    }
    
    public function getEntity(name:String):Entity
    {
      return injector_.getInstance(Entity, name);
    }
  }
}
