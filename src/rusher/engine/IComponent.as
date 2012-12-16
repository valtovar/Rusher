package rusher.engine 
{
  
  public interface IComponent extends IInjectorHolder
  {
    function init():void;
    function dispose():void;
  }
}