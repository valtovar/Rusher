package idv.cjcat.rusher.box2d 
{
    import Box2D.Collision.Shapes.b2CircleShape;
    import Box2D.Collision.Shapes.b2PolygonShape;
    import Box2D.Common.Math.b2Vec2;
    import Box2D.Dynamics.b2Body;
    import Box2D.Dynamics.b2BodyDef;
    import Box2D.Dynamics.b2FixtureDef;
    import idv.cjcat.rusher.utils.RusherMath;
    
    internal class Box2DShapeCreator implements IBox2DShapeCreator
    {
        private var _body:b2Body;
        
        public function Box2DShapeCreator(body:b2Body) 
        {
            _body = body;
        }
        
        public function createCircle
        (
            centerX:Number, 
            centerY:Number, 
            radius:Number, 
            density:Number = 1, 
            restitution:Number = 0.5, 
            isSensor:Boolean = false, 
            categoryBits:uint = 0x0001, 
            maskBits:uint = 0xFFFF, 
            groupIndex:uint = 0
        ):void
        {
            centerX *= Box2DWorld.PIXELS_TO_METERS;
            centerY *= Box2DWorld.PIXELS_TO_METERS;
            radius *= Box2DWorld.PIXELS_TO_METERS;
            
            var shape:b2CircleShape = new b2CircleShape(radius);
            shape.SetLocalPosition(new b2Vec2(centerX, centerY));
            
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density = density;
            fixtureDef.restitution = restitution;
            fixtureDef.isSensor = isSensor;
            fixtureDef.filter.categoryBits = categoryBits;
            fixtureDef.filter.maskBits = maskBits;
            fixtureDef.filter.groupIndex = groupIndex;
            
            fixtureDef.shape = shape;
            
            _body.CreateFixture(fixtureDef);
        }
        
        public function createBox
        (
            width:Number, 
            height:Number, 
            density:Number = 1, 
            restitution:Number = 0.5, 
            isSensor:Boolean = false, 
            categoryBits:uint = 0x0001, 
            maskBits:uint = 0xFFFF, 
            groupIndex:uint = 0
        ):void
        {
            width *= Box2DWorld.PIXELS_TO_METERS;
            height *= Box2DWorld.PIXELS_TO_METERS;
            
            var shape:b2PolygonShape = new b2PolygonShape();
            shape.SetAsBox(0.5 * width, 0.5 * height);
            
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density = density;
            fixtureDef.restitution = restitution;
            fixtureDef.isSensor = isSensor;
            fixtureDef.filter.categoryBits = categoryBits;
            fixtureDef.filter.maskBits = maskBits;
            fixtureDef.filter.groupIndex = groupIndex;
            
            fixtureDef.shape = shape;
            
            _body.CreateFixture(fixtureDef);
        }
        
        public function createOrientedBox
        (
            centerX:Number, 
            centerY:Number, 
            width:Number, 
            height:Number, 
            angle:Number = 0, 
            density:Number = 1, 
            restitution:Number = 0.5, 
            isSensor:Boolean = false, 
            categoryBits:uint = 0x0001, 
            maskBits:uint = 0xFFFF, 
            groupIndex:uint = 0
        ):void
        {
            centerX *= Box2DWorld.PIXELS_TO_METERS;
            centerY *= Box2DWorld.PIXELS_TO_METERS;
            width *= Box2DWorld.PIXELS_TO_METERS;
            height *= Box2DWorld.PIXELS_TO_METERS;
            
            var shape:b2PolygonShape = new b2PolygonShape();
            shape.SetAsOrientedBox(0.5 * width, 0.5 * height, new b2Vec2(centerX, centerY), angle * RusherMath.DEGREE_TO_RADIAN);
            
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density = density;
            fixtureDef.restitution = restitution;
            fixtureDef.isSensor = isSensor;
            fixtureDef.filter.categoryBits = categoryBits;
            fixtureDef.filter.maskBits = maskBits;
            fixtureDef.filter.groupIndex = groupIndex;
            
            fixtureDef.shape = shape;
            
            _body.CreateFixture(fixtureDef);
        }
        
        public function createPolygon
        (
            vertices:Array, 
            density:Number = 1, 
            restitution:Number = 0.5, 
            isSensor:Boolean = false, 
            categoryBits:uint = 0x0001, 
            maskBits:uint = 0xFFFF, 
            groupIndex:uint = 0
        ):void
        {
            for (var i:int = 0, len:int = vertices.length; i < len; ++i)
            {
                vertices[i] *= Box2DWorld.PIXELS_TO_METERS;
            }
            
            var shape:b2PolygonShape = new b2PolygonShape();
            shape.SetAsArray(vertices);
            
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density = density;
            fixtureDef.restitution = restitution;
            fixtureDef.isSensor = isSensor;
            fixtureDef.filter.categoryBits = categoryBits;
            fixtureDef.filter.maskBits = maskBits;
            fixtureDef.filter.groupIndex = groupIndex;
            
            fixtureDef.shape = shape;
            
            _body.CreateFixture(fixtureDef);
        }
        
        public function createEdge
        (
            x1:Number, 
            y1:Number, 
            x2:Number, 
            y2:Number, 
            density:Number = 1, 
            restitution:Number = 0.5, 
            isSensor:Boolean = false, 
            categoryBits:uint = 0x0001, 
            maskBits:uint = 0xFFFF, 
            groupIndex:uint = 0
        ):void
        {
            x1 *= Box2DWorld.PIXELS_TO_METERS;
            y1 *= Box2DWorld.PIXELS_TO_METERS;
            x2 *= Box2DWorld.PIXELS_TO_METERS;
            y2 *= Box2DWorld.PIXELS_TO_METERS;
            
            var shape:b2PolygonShape = new b2PolygonShape();
            shape.SetAsEdge(new b2Vec2(x1, y1), new b2Vec2(x2, y2));
            
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.density = density;
            fixtureDef.restitution = restitution;
            fixtureDef.isSensor = isSensor;
            fixtureDef.filter.categoryBits = categoryBits;
            fixtureDef.filter.maskBits = maskBits;
            fixtureDef.filter.groupIndex = groupIndex;
            
            fixtureDef.shape = shape;
            
            _body.CreateFixture(fixtureDef);
        }
    }
}