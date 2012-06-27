package idv.cjcat.rusher.engine 
{
	
  public interface ISystem extends IInjectorHolder
  {
    function init():void;
    function dispose():void;
    function update(dt:Number):void;
  }
}