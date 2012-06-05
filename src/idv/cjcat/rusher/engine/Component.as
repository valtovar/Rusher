package idv.cjcat.rusher.engine 
{
	
  public class Component extends RusherObject implements IComponent
  {
    public function getOwner():Entity
    {
      return getInstance(Entity);
    }
    
    public function getSibling(ComponentClass:Class):*
    {
      return getInstance(ComponentClass);
    }
    
    public function Component()
    { }
    
    public function onAdded():void
    { }
    
    public function onRemoved():void
    { }
  }
}
