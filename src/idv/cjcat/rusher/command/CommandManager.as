package idv.cjcat.rusher.command 
{
  import idv.cjcat.rusher.data.InList;
  import idv.cjcat.rusher.data.InListIterator;
  import idv.cjcat.rusher.engine.System;
  
  public final class CommandManager extends System
  {
    private var commands_:InList = new InList();
    
    public function CommandManager()
    { }
    
    public function execute(command:Command):void
    {
      //lower completion flag
      command.isComplete = false;
      
      //set up command injector
      command.setInjector(getInjector());
      getInjector().injectInto(command);
      
      //execute command
      command.execute();
      
      //command not complete after execution
      if (!command.isComplete)
      {
        commands_.pushBack(command);
      }
    }
    
    override public function update(dt:Number):void
    {
      var iter:InListIterator = commands_.getIterator();
      var command:Command;
      while (command = iter.data())
      {
        //update command
        command.update(dt);
        
        //command complete, remove
        if (command.isComplete) iter.remove();
        //command not complete, next
        else iter.next();
      }
    }
  }
}