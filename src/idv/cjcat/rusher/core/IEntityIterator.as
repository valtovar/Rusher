package idv.cjcat.rusher.core 
{
    /**
     * Entity collection iterator interface.
     */
    public interface IEntityIterator extends IDisposable
    {
        /**
         * Point to the first node.
         */
        function begin():void;
        /**
         * There's a node next to the current node.
         * @return
         */
        function hasNext():Boolean;
        /**
         * Point to a next node.
         */
        function next():void;
        /**
         * Point to the last node.
         */
        function end():void;
        /**
         * Returns the current node.
         * @return
         */
        function current():*;
    }
}