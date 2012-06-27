package idv.cjcat.rusher.example
{
  import flash.display.Bitmap;
  import flash.display.DisplayObjectContainer;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.filters.GlowFilter;
  import flash.text.AntiAliasType;
  import flash.text.TextField;
  import flash.text.TextFormat;
	
	[SWF(width="640", height="480", backgroundColor="#000000", frameRate="60")]
	public class RusherExample extends Sprite 
	{
		[Embed(source="assets/Rusher 2 logo.png")]
    private var RusherLogo:Class;
    
    [Embed(source="assets/Arial.ttf", fontFamily="Arial", embedAsCFF="false", unicodeRange="U+0020-007E")]
    private var Arial:Class;
    
    [Embed(source="assets/Berlin Sans Demi.ttf", fontName="Berlin Sans Demi", embedAsCFF="false", unicodeRange="U+0020-007E")]
    public var BerlinSansDemi:Class;
    
    private var backgroundColor_:uint;
    
    private var title_      :TextField = new TextField();
    private var message_    :TextField = new TextField();
    private var blog_       :TextField = new TextField();
    private var link_       :TextField = new TextField();
    
    private var logo_       :Bitmap    = new RusherLogo();
    private var mask_       :Shape     = new Shape();
    private var bars_       :Shape     = new Shape();
    private var canvas_     :Sprite    = new Sprite();
    private var background_ :Shape     = new Shape();
    
    protected function get canvas():DisplayObjectContainer { return canvas_; }
    
		public function RusherExample(title:String = "Rusher Example", backgroundColor:uint = 0xFFFFFF, message:String = "")
		{
      backgroundColor_ = backgroundColor;
      
      //fix stage
      stage.align     = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      
      //set title
      title_.text = ". " + title + " .";
      title_.width = 800;
      title_.antiAliasType = AntiAliasType.ADVANCED;
      title_.embedFonts = true;
      title_.selectable = false;
      title_.setTextFormat(new TextFormat("Berlin Sans Demi", 20, 0xFFFFFF));
      
      //set message
      message_.text = message;
      message_.width = 800;
      message_.antiAliasType = AntiAliasType.ADVANCED;
      message_.embedFonts = true;
      message_.selectable = false;
      message_.setTextFormat(new TextFormat("Arial", 16, 0x0000000));
      message_.filters = [new GlowFilter(0xFFFFFFF, 1, 1.2, 1.2, 100, 2)];
      
      //set blog
      blog_.htmlText= "<a href='http://allenchou.net'>http://allenchou.net</a>";
      blog_.width = 400;
      blog_.antiAliasType = AntiAliasType.ADVANCED;
      blog_.embedFonts = true;
      blog_.selectable = false;
      blog_.setTextFormat(new TextFormat("Arial", 14, 0xFFFFFF, true));
      
      //set link
      link_.htmlText = "<a href='https://code.google.com/p/rusher/'>https://code.google.com/p/rusher</a>";
      link_.width = 400;
      link_.antiAliasType = AntiAliasType.ADVANCED;
      link_.embedFonts = true;
      link_.selectable = false;
      link_.setTextFormat(new TextFormat("Arial", 14, 0xFFFFFF, true));
      
      addChild(background_);
      addChild(canvas_);
      addChild(bars_);
      addChild(message_);
      addChild(title_);
      addChild(blog_);
      addChild(link_);
      addChild(mask_);
      addChild(logo_);
      canvas_.mask = mask_;
      
      onResize();
      stage.addEventListener(Event.RESIZE, onResize);
		}
    
    private function onResize(e:Event = null):void
    {
      //make background
      background_.graphics.clear();
      background_.graphics.beginFill(backgroundColor_);
      background_.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
      
      //draw black bars
      bars_.graphics.clear();
      bars_.graphics.beginFill(0x000000);
      bars_.graphics.drawRect(0, 0, stage.stageWidth, 40);
      bars_.graphics.drawRect(0, stage.stageHeight - 40, stage.stageWidth, 40);
      
      //make mask
      mask_.graphics.clear();
      mask_.graphics.beginFill(0x000000);
      mask_.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
      
      //move logo
      logo_.x = stage.stageWidth  - logo_.width  - 3;
      logo_.y = stage.stageHeight - logo_.height - 3;
      
      //set title
      title_.x = 3, title_.y = 6;
      
      //set message
      message_.x = 5, message_.y = 50;
      
      //set blog
      blog_.x = 2, blog_.y = stage.stageHeight - 38;
      
      //set link
      link_.x = 2, link_.y = stage.stageHeight - 21;
      
      //move canvas to the center
      canvas.x = 0.5 * stage.stageWidth;
      canvas.y = 0.5 * stage.stageHeight;
    }
	}
}