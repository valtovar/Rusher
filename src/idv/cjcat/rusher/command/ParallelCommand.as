package idv.cjcat.rusher.command 
{
  import idv.cjcat.rusher.data.InListIterator;
  public class ParallelCommand extends CompositeCommand
  {
    
    public function ParallelCommand(...subcommands) 
    {
      super(subcommands);
    }
    
    override public function execute():void
    {
      if (subcommands.size())
      {
        //executes all subcommands
        var iter:InListIterator = subcommands.getIterator();
        var subcommand:Command;
        while (subcommand = iter.data())
        {
          subcommand.execute();
          
          //subcommand completed, remove
          if (subcommand.isComplete) iter.remove();
          //subcommand not completed, move on
          else iter.next();
        }
        
        //all subcommands completed, complete
        if (subcommands.size() == 0) complete();
      }
      //no subcommands, complete
      else
      {
        complete();
      }
    }
    
    override public function update(dt:Number):void 
    {
      //updates all subcommands
      var iter:InListIterator = subcommands.getIterator();
      var subcommand:Command;
      while (subcommand = iter.data())
      {
        subcommand.update(dt);
        
        //subcommand completed, remove
        if (subcommand.isComplete) iter.remove();
        //subcommand not compelted, move on
        else iter.next();
      }
      
      //all subcommands completed, complete
      if (subcommands.size() == 0) complete();
    }
  }
}