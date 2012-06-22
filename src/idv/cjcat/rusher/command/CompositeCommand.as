package idv.cjcat.rusher.command 
{
  import idv.cjcat.rusher.data.InList;
  import org.swiftsuspenders.Injector;
  
  internal class CompositeCommand extends Command
  {
    protected var subcommands:InList = new InList();
    
    public function CompositeCommand(subcommands:Array) 
    {
      for (var i:int = 0, len:int = subcommands.length; i < len; ++i)
      {
        this.subcommands.pushBack(subcommands[i]);
      }
    }
    
    public function append(command:Command):void
    {
      subcommands.pushBack(command);
    }
  }
}