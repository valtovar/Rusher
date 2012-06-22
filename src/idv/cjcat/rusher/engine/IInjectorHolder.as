package idv.cjcat.rusher.engine 
{
  import org.swiftsuspenders.Injector;
  
  public interface IInjectorHolder 
  {
    function getInjector():Injector;
    function setInjector(injector:Injector):void;
    function hasInstance(InstanceClass:Class, name:String = ""):Boolean;
    function getInstance(InstanceClass:Class, name:String = ""):*;
  }
}