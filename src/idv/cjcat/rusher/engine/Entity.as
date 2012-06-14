package idv.cjcat.rusher.engine 
{
  import flash.utils.Dictionary;
  import idv.cjcat.rusher.utils.construct;
  import org.osflash.signals.ISignal;
  import org.osflash.signals.Signal;
  import org.swiftsuspenders.Injector;
	
  public class Entity extends RusherObject
  {
    private var name_:String;
    public function getName():String { return name_; }
    
    private var onMountedOnto_:ISignal = new Signal(Entity);
    public function get onMountedOnto():ISignal { return onMountedOnto_; }
    
    private var onChildMounted_:ISignal = new Signal(Entity);
    public function get onChildMounted():ISignal { return onChildMounted_; }
    
    private var onUnmountedFrom_:ISignal = new Signal(Entity);
    public function get onUnmountedFrom():ISignal { return onUnmountedFrom_; }
    
    private var onChildUnmounted_:ISignal = new Signal(Entity);
    public function get onChildUnmounted():ISignal { return onChildUnmounted_; }
    
    
    private var parent_:Entity = null;
    public function getParent():Entity { return parent_; }
    
    private var components_:Dictionary = new Dictionary();
    private var children_:Dictionary = new Dictionary();
    
    public function getComponent(ComponentClass:Class):*
    {
      return IComponent(getInstance(ComponentClass));
    }
    
    public function Entity(name:String)
    {
      name_ = name;
    }
    
    public function addComponent(ComponentClass:Class, ...params):*
    {
      var injector:Injector = getInjector();
      
      //check component existence
      if (injector.satisfies(ComponentClass)) throw new Error("Component " + ComponentClass + " already added.");
      
      //add component to entity
      var component:IComponent  = construct(ComponentClass, params);
      
      //map to entity's and engine's injectors
      injector.map(ComponentClass).toValue(component);
      injector.parentInjector.map(ComponentClass, getName()).toValue(component);
      
      //intialize component
      component.setInjector(getInjector());
      components_[ComponentClass] = component;
      
      getInjector().injectInto(component);
      component.onAdded();
      
      return component;
    }
    
    public function removeComponent(ComponentClass:Class):void
    {
      var injector:Injector = getInjector();
      
      //check component existence
      if (!injector.satisfies(ComponentClass)) throw new Error("Component " + ComponentClass + " not found.");
      
      var component:IComponent = getComponent(ComponentClass);
      
      //remove component from entity
      component.onRemoved();
      component.setInjector(null);
      delete components_[ComponentClass];
    }
    
    public function getChild(name:Entity):Entity
    {
      if (!children_[name]) throw new Error("Child entity named \"" + name + "\" not found.");
      return children_[name];
    }
    
    public function mount(child:Entity):Entity
    {
      if (children_[child.name_]) throw new Error("Entity named \"" + child.name_ + "\" already mounted.");
      if (child.parent_) throw new Error("Entity named \"" + child.name_ + "\" already mounted onto parent named \"" + child.parent_.name_ + "\"");
      
      //establish parent-child relation
      children_[child.name_] = child;
      child.parent_ = this;
      
      //inform parent
      onChildMounted.dispatch(child);
      
      //inform child
      child.onMountedOnto.dispatch(this);
      
      return child;
    }
    
    public function unmount(child:Entity):Entity
    {
      if (!children_[child.name_]) throw new Error("Child entity named \"" + child.name_ + "\" not found.");
      
      //inform child
      child.onUnmountedFrom.dispatch(this);
      
      //inform parent
      onChildUnmounted.dispatch(child);
      
      //remove parent-child relation
      delete children_[child.name_];
      child.parent_ = null;
      
      return child;
    }
    
    public function destroy():void
    {
      //destroy all children first
      for (var key:* in children_)
      {
        getEngine().destroyEntity(key);
        delete children_[key];
      }
      
      //and then destroy this entity itself
      getEngine().destroyEntity(getName());
    }
    
    /** @private */
    internal function dispose():void
    {
      for (var ComponentClass:* in components_)
      {
        removeComponent(ComponentClass);
      }
    }
  }
}
