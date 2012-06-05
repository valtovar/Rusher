package idv.cjcat.rusher.command 
{
  import idv.cjcat.rusher.data.InListIterator;
  
  public class SerialCommand extends CompositeCommand
  {
    
    public function SerialCommand(...subcommands) 
    {
      super(subcommands);
    }
    
    override public function execute():void
    {
      if (subcommands.size())
      {
        //continuously execute subcommands until one doesn't immediately 
        //complete or every subcommands are immediately completed
        var iter:InListIterator = subcommands.getIterator();
        var subcommand:Command;
        while (1)
        {
          subcommand = iter.data();
          
          subcommand.execute();
          
          //subcommand immediately completed
          if (subcommand.isComplete)
          {
            //the last subcommand, complete
            if (!iter.hasNext())
            {
              complete();
              return;
            }
            //not the last subcommand, move on
            else
            {
              iter.remove();
            }
          }
          //subcommand not immediately completed, break
          else
          {
            break;
          }
        }
      }
      //no subcommands, complete
      else
      {
        complete();
      }
    }
    
    override public function update(dt:Number):void 
    {
      //continuously update subcommands until one doesn't complete or
      //the last subcommand is completed
      var iter:InListIterator = subcommands.getIterator();
      var subcommand:Command;
      while (1)
      {
        subcommand = iter.data();
        
        subcommand.update(dt);
        
        //subcommand completed
        if (subcommand.isComplete)
        {
          //the last subcommand, complete
          if (!iter.hasNext())
          {
            complete();
            return;
          }
          //not the last subcommand, move on
          else
          {
            iter.remove();
          }
        }
        //subcommand not completed, break
        else
        {
          break;
        }
      }
    }
  }
}