package idv.cjcat.rusher.engine 
{
  
  public interface IComponent extends IInjectorHolder
  {
    function onAdded():void;
    function onRemoved():void;
  }
}