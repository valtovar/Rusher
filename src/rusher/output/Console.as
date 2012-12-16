package rusher.output 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
  import rusher.engine.System;
  import rusher.input.Input;
	
	public class Console extends System
	{
    private var sprite_:Sprite = new Sprite();
    private var textField_:TextField;
    
    private var keyCode_:uint;
    private var backgroundColor_:uint;
    private var backgroundAlpha_:Number;
    private var maxLength_:int;
    
    private var stage_:Stage;
    private var input_:Input;
    
    public function Console
    (
      keyCode:uint, 
      backgroundColor:uint = 0x000000, 
      backgroundAlpha:Number = 0.9, 
      visibleAtStart:Boolean = false, 
      maxLength:int = 10000
    ) 
    {
      keyCode_ = keyCode;
      backgroundColor_ = backgroundColor;
      backgroundAlpha_ = backgroundAlpha;
      maxLength_ = maxLength;
      
      sprite_.visible = visibleAtStart;
    }
    
    public function print(str:String):void
    {
      textField_.appendText(str);
      if (textField_.length > maxLength_)
      {
        textField_.text = textField_.text.slice(0.5 * maxLength_);
      }
      
      textField_.scrollV = textField_.maxScrollV;
    }
    
    public function println(str:String):void
    {
      print(str + "\n");
    }
    
    public function endl():void
    {
      print("\n");
    }
    
    public function clear():Console {
      textField_.text = "";
      return this;
    }
    
    public function show():void {
      sprite_.visible = true;
    }
    
    public function hide():void {
      sprite_.visible = false;
    }
    
    public function toggle():void
    {
      sprite_.visible = !sprite_.visible;
    }
    
    override public function init():void
    {
      stage_ = getInstance(Stage);
      input_ = getInstance(Input);
      
      buildView();
    }
    
    override public function dispose():void
    {
      textField_.text = "";
      textField_ = null;
      
      stage_ = null;
      input_ = null;
    }
    
    override public function update(dt:Number):void
    {
      //always on top
      if (sprite_.visible)
      {
      if (stage_)
      {
        if (stage_.getChildIndex(sprite_) != stage_.numChildren - 1)
        {
          stage_.addChildAt(sprite_, stage_.numChildren - 1);
        }
      }
      else
      {
        stage_.addChild(sprite_);
      }
      }
      else
      {
      if (stage_) stage_.removeChild(sprite_);
      }
      
      //toggle console on/off
      if (input_.isPressed(keyCode_)) toggle();
    }
    
    private function buildView():void
    {
      textField_ = new TextField();
      textField_.textColor = 0xFFFFFF;
      textField_.type = TextFieldType.DYNAMIC;
      textField_.selectable = false;
      textField_.width = stage_.stageWidth;
      textField_.height = stage_.stageHeight;
      
      var format:TextFormat = textField_.getTextFormat();
      format.font = "_typewriter";
      textField_.setTextFormat(format);
      textField_.defaultTextFormat = format;
      
      //draw background
      var g:Graphics = sprite_.graphics;
      g.beginFill(backgroundColor_, backgroundAlpha_);
      g.drawRect(0, 0, stage_.stageWidth, stage_.stageHeight);
      
      sprite_.addChild(textField_);
    }
	}
}