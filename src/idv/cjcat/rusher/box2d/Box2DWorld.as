package idv.cjcat.rusher.box2d 
{
  import Box2D.Common.Math.b2Vec2;
  import Box2D.Dynamics.b2ContactListener;
  import Box2D.Dynamics.b2World;
  import idv.cjcat.rusher.component.Transform2D;
  import idv.cjcat.rusher.engine.Component;
  import idv.cjcat.rusher.engine.System;
  import idv.cjcat.rusher.utils.geom.Vec2D;
  import idv.cjcat.utils.crowd.Entity;
  
  public class Box2DWorld extends System
  {
    public static const METERS_TO_PIXELS:Number = 30;
    public static const PIXELS_TO_METERS:Number = 1 / METERS_TO_PIXELS;
    
    private var _contactListener:Box2DContactListener = new Box2DContactListener();
    private var _defaultContactListener:b2ContactListener = new b2ContactListener();
    private var _enableContactListener:Boolean;
    public function get enableContactListener():Boolean { return _enableContactListener; }
    public function set enableContactListener(value:Boolean):void
    {
      _enableContactListener = value;
      if (_enableContactListener)  _world.SetContactListener(_contactListener);
      else _world.SetContactListener(_defaultContactListener);
    }
    
    private var _contactPreSolver:IBox2DContactPreSolver;
    public function get contactPreSolver():IBox2DContactPreSolver { return _contactPreSolver; }
    public function set contactPreSolver(value:IBox2DContactPreSolver):void
    {
      _contactPreSolver = value;
      _contactListener.preSolver = _contactPreSolver;
    }
    
    private var _contactPostSolver:IBox2DContactPostSolver;
    public function get contactPostSolver():IBox2DContactPostSolver { return _contactPostSolver; }
    public function set contactPostSolver(value:IBox2DContactPostSolver):void
    {
      _contactPostSolver = value;
      _contactListener.postSolver = _contactPostSolver;
    }
    
    public var velocityIterations:int = 8;
    public var positionIterations:int = 8;
    
    private var _world:b2World;
    /**
     * @private
     */
    internal function get world():b2World { return _world; }
    
    public function get gravity():Vec2D
    {
      var g:b2Vec2 = _world.GetGravity();
      return new Vec2D(g.x * METERS_TO_PIXELS, g.y * METERS_TO_PIXELS);
    }
    public function set gravity(value:Vec2D):void
    {
      _world.SetGravity(new b2Vec2(value.x * PIXELS_TO_METERS, value.y * PIXELS_TO_METERS));
    }
    
    public function Box2DWorld
    (
      gravity:Vec2D = null, 
      doSleep:Boolean = true, 
      enableContactListener:Boolean = false, 
      velocityIterations:int = 8, 
      positionIterations:int = 8
    ) 
    {
      if (!gravity) gravity = new Vec2D(0, 0);
      _world = new b2World(new b2Vec2(gravity.x * PIXELS_TO_METERS, gravity.y * PIXELS_TO_METERS), doSleep);
      
      this.enableContactListener = enableContactListener;
      this.velocityIterations = velocityIterations;
      this.positionIterations = positionIterations;
    }
    
    //TODO: Ray Cast
    //public function rayCast(from:Vec2D, to:Vec2D, categoryBits:uint = 0xFFFFFFFF):void
    //{
      //_world.RayCast
    //}
    
    //ground body for bodyB for target point joint
    private var _ground:Entity;
    private var _groundBody:Box2DBody;
    /**
     * @private
     */
    internal function getGroundBody():Box2DBody { return _groundBody; }
    
    override public function onAdded():void
    {
      //create ground body
      _ground = getEngine().createEntity();
      var bodyDef:Box2DBodyDef = new Box2DBodyDef();
      bodyDef.type = Box2DBodyType.STATIC;
      _ground.addComponent(_groundBody = new Box2DBody(bodyDef));
    }
    
    override public function onRemoved():void
    {
      _world = null;
      getEngine().destroyEntity(_ground.name);
      _ground = null;
    }
    
    override public function update(dt:Number):void
    {
      _world.Step(dt, velocityIterations, positionIterations);
      updateComponents(dt);
    }
    
    override protected function updateComponent(component:Component, dt:Number):void 
    {
      var body:Box2DBody = Box2DBody(component);
      var pos:Vec2D = body.position;
      var transform:Transform2D = body..getSibling(Transform2D);
      
      //dump position
      transform.position.set(pos.x, pos.y);
    }
  }
}