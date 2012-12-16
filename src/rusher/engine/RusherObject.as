package rusher.engine 
{
  import rusher.data.InListNode;
  import org.swiftsuspenders.Injector;
  
  public class RusherObject extends InListNode implements IInjectorHolder
  {
    private var injector_:Injector;
    public function getInjector():Injector { return injector_; }
    public function setInjector(injector:Injector):void { injector_ = injector; }
    
    public function hasInstance(InstanceClass:Class, name:String = ""):Boolean
    {
      return getInjector().satisfies(InstanceClass, name);
    }
    
    public function getInstance(InstanceClass:Class, name:String = ""):*
    {
      /*
      if (!hasInstance())
      {
        throw new Error("Instance of" + InstanceClass + " named \"" + name + "\" not found.");
      }
      */
      return getInjector().getInstance(InstanceClass, name);
    }
  }
}
