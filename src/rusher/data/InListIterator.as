package rusher.data 
{
  public class InListIterator 
  {
    
    /** @private */
    internal var node:InListNode = null;
    
    /** @private */
    internal var list:InList = null;
    
    public function InListIterator(list:InList)
    {
      this.list = list;
      node = list.head.next;
    }
    
    public function hasNext():Boolean
    {
      return node.next != list.tail;
    }
    
    public function hasPrev():Boolean
    {
      return node.prev != list.head;
    }
    
    public function first():InListIterator
    {
      node = list.head.next;
      return this;
    }
    
    public function last():InListIterator
    {
      node = list.tail.prev;
      return this;
    }
    
    public function next():void
    {
      node = node.next;
    }
    
    public function prev():void
    {
      node = node.prev;
    }
    
    public function data():*
    {
      if (node != list.head && node != list.tail) return node;
      else return null;
    }
    
    public function remove():void
    {
      var next:InListNode = node.next;
      list.remove(node);
      node = next;
    }
    
    public function clone():InListIterator
    {
      var copy:InListIterator = new InListIterator(list);
      copy.node = node;
      
      return copy;
    }
    
    public function copy(target:InListIterator):InListIterator
    {
      target.list = list;
      target.node = node;
      
      return target;
    }
  }
}