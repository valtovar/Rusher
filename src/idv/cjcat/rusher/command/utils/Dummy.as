package idv.cjcat.rusher.command.utils 
{
	import idv.cjcat.rusher.command.Command;
	
	public class Dummy extends Command
	{
        public function Dummy() 
        {
            
        }
        
        override public function execute():void 
        {
            complete();
        }
	}
}