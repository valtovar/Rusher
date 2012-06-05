package idv.cjcat.rusher.engine 
{
  import org.swiftsuspenders.Injector;
  
	public class Injectible
  {
    private var injector_:Injector;
    
    public function getInjector():Injector { return injector_; }
    public function setInjector(injector:Injector):void { injector_ = injector; }
  }
}