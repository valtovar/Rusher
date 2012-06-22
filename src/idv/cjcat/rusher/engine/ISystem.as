package idv.cjcat.rusher.engine 
{
	
  public interface ISystem extends IInjectible
  {
    function onAdded():void;
    function onRemoved():void;
    function update(dt:Number):void;
  }
}