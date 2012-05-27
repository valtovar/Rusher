package idv.cjcat.rusher.core 
{
    import flash.display.Stage;
    
    /**
     * Core engine interface.
     */
    public interface IEngine extends IDisposable
    {
        /**
         * Start the engine.
         * @param    stage Required for render and UI systems.
         */
        function start(stage:Stage):void;
    }
}