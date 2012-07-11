package idv.cjcat.rusher.engine 
{
	
  public interface ISystem extends IInjectorHolder
  {
    function get active():Boolean;
    function set active(value:Boolean):void;
    
    function init():void;
    function dispose():void;
    function update(dt:Number):void;
  }
}