package idv.cjcat.rusher.engine 
{
  import idv.cjcat.rusher.data.InListNode;
  import org.swiftsuspenders.Injector;
  
  public class RusherObject extends InListNode implements IInjectible
  {
    private var injector_:Injector;
    public function getInjector():Injector { return injector_; }
    public function setInjector(injector:Injector):void { injector_ = injector; }
    
    public function getInstance(InstanceClass:Class, name:String = ""):*
    {
      if (!getInjector().satisfies(InstanceClass, name))
      {
        throw new Error("Instance of" + InstanceClass + " named \"" + name + "\" not found.");
      }
      return getInjector().getInstance(InstanceClass, name);
    }
    
    public function getEngine():Engine
    {
      return getInstance(Engine);
    }
    
    public function getEntity(name:String):Entity
    {
      return getInstance(Entity, name);
    }
    
    public function getSystem(SystemClass:Class):*
    {
      return ISystem(getInstance(SystemClass));
    }
  }
}
