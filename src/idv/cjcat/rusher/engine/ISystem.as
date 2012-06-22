package idv.cjcat.rusher.engine 
{
	
  public interface ISystem extends IInjectorHolder
  {
    function onAdded():void;
    function onRemoved():void;
    function update(dt:Number):void;
  }
}