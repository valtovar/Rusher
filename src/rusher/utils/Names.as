package rusher.utils 
{
  import flash.utils.Dictionary;
  
  public class Names
  {
    public static function get(namePrefix:String):String
    {
      if (counter_[namePrefix] == undefined) counter_[namePrefix] = 0;
      return namePrefix + "_" + (counter_[namePrefix]++);
    }
    
    public static function resetCounter(namePrefix:String):void
    {
      if (counter_[namePrefix] != undefined) delete counter_[namePrefix];
    }
    private static var counter_:Dictionary = new Dictionary();
  }
}
