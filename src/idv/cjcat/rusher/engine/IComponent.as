package idv.cjcat.rusher.engine 
{
  
  public interface IComponent extends IInjectible
  {
    function onAdded():void;
    function onRemoved():void;
  }
}