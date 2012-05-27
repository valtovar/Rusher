package idv.cjcat.rusher.core 
{
    /**
     * This interface requires implementors to have a method for memory clean-up.
     */
    public interface IDisposable 
    {
        function dispose():void;
    }
}