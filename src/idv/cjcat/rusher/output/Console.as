package idv.cjcat.rusher.output 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
  import idv.cjcat.rusher.engine.System;
  import idv.cjcat.rusher.input.Keyboard;
	
	public class Console extends System
	{
    private var _sprite:Sprite = new Sprite();
    private var _textField:TextField;
    
    private var _keycode:uint;
    private var _backgroundColor:uint;
    private var _backgroundAlpha:Number;
    private var _maxLength:int;
    
    private var _stage:Stage;
    private var _keyboard:Keyboard;
    
    public function Console
    (
      keyCode:uint, 
      backgroundColor:uint = 0x000000, 
      backgroundAlpha:Number = 0.9, 
      visibleAtStart:Boolean = false, 
      maxLength:int = 10000
    ) 
    {
      _keycode = keyCode;
      _backgroundColor = backgroundColor;
      _backgroundAlpha = backgroundAlpha;
      _maxLength = maxLength;
      
      _sprite.visible = visibleAtStart;
    }
    
    public function print(str:String):void
    {
      _textField.appendText(str);
      if (_textField.length > _maxLength)
      {
        _textField.text = _textField.text.slice(0.5 * _maxLength);
      }
      
      _textField.scrollV = _textField.maxScrollV;
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
      _textField.text = "";
      return this;
    }
    
    public function show():void {
      _sprite.visible = true;
    }
    
    public function hide():void {
      _sprite.visible = false;
    }
    
    public function toggle():void
    {
      _sprite.visible = !_sprite.visible;
    }
    
    override public function onAdded():void
    {
      _stage = getInstance(Stage);
      _keyboard = getSystem(Keyboard);
      
      buildView();
    }
    
    override public function onRemoved():void
    {
      _textField.text = "";
      _textField = null;
      
      _stage = null;
      _keyboard = null;
    }
    
    override public function update(dt:Number):void
    {
      //always on top
      if (_sprite.visible)
      {
      if (_stage)
      {
        if (_stage.getChildIndex(_sprite) != _stage.numChildren - 1)
        {
          _stage.addChildAt(_sprite, _stage.numChildren - 1);
        }
      }
      else
      {
        _stage.addChild(_sprite);
      }
      }
      else
      {
      if (_stage) _stage.removeChild(_sprite);
      }
      
      //toggle console on/off
      if (_keyboard.isPressed(_keycode)) toggle();
    }
    
    private function buildView():void
    {
      _textField = new TextField();
      _textField.textColor = 0xFFFFFF;
      _textField.type = TextFieldType.DYNAMIC;
      _textField.selectable = false;
      _textField.width = _stage.stageWidth;
      _textField.height = _stage.stageHeight;
      
      var format:TextFormat = _textField.getTextFormat();
      format.font = "_typewriter";
      _textField.setTextFormat(format);
      _textField.defaultTextFormat = format;
      
      //draw background
      var g:Graphics = _sprite.graphics;
      g.beginFill(_backgroundColor, _backgroundAlpha);
      g.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
      
      _sprite.addChild(_textField);
    }
	}
}