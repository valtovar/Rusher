package idv.cjcat.rusher.output 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import idv.cjcat.rusher.core.ISystem;
	import idv.cjcat.rusher.clock.Clock;
	import idv.cjcat.rusher.ui.Keyboard;
	
	public class Console extends Sprite implements ISystem
	{
        private var _keycode:uint;
        private var _backgroundColor:uint;
        private var _backgroundAlpha:Number;
        private var _maxLength:int;
        
        private var _textField:TextField;
        
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
            
            visible = visibleAtStart
        }
        
        private var _stage:Stage;
        private var _keyboard:Keyboard;
        private var _clock:Clock;
        [Inject]
        public function inject(stage:Stage, keyboard:Keyboard, clock:Clock):void
        {
            _stage = stage;
            _keyboard = keyboard;
            _clock = clock;
        }
        
        public function onAdd():void
        {
            _clock.add(update);
            buildView();
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
            var g:Graphics = graphics;
            g.beginFill(_backgroundColor, _backgroundAlpha);
            g.drawRect(0, 0, _stage.stageWidth, _stage.stageHeight);
            
            addChild(_textField);
        }
        
        private function update(dt:Number):void
        {
            //always on top
            if (visible)
            {
            if (stage)
            {
                if (_stage.getChildIndex(this) != _stage.numChildren - 1)
                {
                _stage.addChildAt(this, _stage.numChildren - 1);
                }
            }
            else
            {
                _stage.addChild(this);
            }
            }
            else
            {
            if (stage) _stage.removeChild(this);
            }
            
            //toggle console on/off
            if (_keyboard.isPressed(_keycode)) toggle();
        }
        
        public function print(str:String):void
        {
            _textField.appendText(str);
            if (_textField.length > _maxLength) {
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
            visible = true;
        }
        
        public function hide():void {
            visible = false;
        }
        
        public function toggle():void
        {
            visible = !visible;
        }
        
        public function dispose():void
        {
            _textField.text = "";
            _textField = null;
            
            _clock.remove(update);
            
            _clock = null;
            _stage = null;
            _keyboard = null;
        }
	}
}