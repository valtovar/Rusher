package idv.cjcat.rusher.engine 
{
  import org.swiftsuspenders.Injector;
  
  public interface IInjectible 
  {
    function getInjector():Injector;
    function setInjector(injector:Injector):void;
  }
}