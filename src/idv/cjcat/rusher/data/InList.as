package idv.cjcat.rusher.data 
{
  import flash.errors.IllegalOperationError;
  
  public class InList 
  {
    /** @private */
    internal var head:InListNode = new InListNode();
    
    /** @private */
    internal var tail:InListNode = new InListNode();
    
    private var size_:int = 0;
    public function size():int { return size_; }
    
    public function InList()
    {
      head.next = tail;
      tail.prev = head;
    }
    
    public function add(node:InListNode):void
    {
      if (node.next || node.prev) throw new IllegalOperationError("Node already belongs to a list.");
      
      tail.prev.next = node;
      node.prev = tail.prev;
      
      tail.prev = node;
      node.next = tail;
      
      node.list = this;
      
      ++size_;
    }
    
    public function remove(node:InListNode):void
    {
      if (node.list != this) throw new IllegalOperationError("Node does not belong to this list.");
      
      node.prev.next = node.next;
      node.next.prev = node.prev;
      
      node.list = null;
      
      --size_;
    }
    
    public function getIterator():InListIterator
    {
      return new InListIterator(this);
    }
  }
}