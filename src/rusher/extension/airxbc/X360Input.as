package rusher.extension.airxbc 
{
  import com.rhuno.Airxbc;
  import com.rhuno.X360Gamepad;
  import flash.utils.Dictionary;
  import org.osflash.signals.ISignal;
  import org.osflash.signals.Signal;
  import rusher.engine.System;
  
  public class X360Input extends System
  {
    //signals
    //-------------------------------------------------------------------------
    
    public var onControllerConnected   :ISignal = new Signal(uint);
    public var onControllerDisconnected:ISignal = new Signal(uint);
    
    //-------------------------------------------------------------------------
    //end of signals
    
    public static const A          :uint =  0;
    public static const B          :uint =  1;
    public static const X          :uint =  2;
    public static const Y          :uint =  3;
    public static const LB         :uint =  4; //left  bumper/shouder
    public static const RB         :uint =  5; //right bumper/shoulder
    public static const LS         :uint =  6; //left  stick button
    public static const RS         :uint =  7; //right stick button
    public static const BACK       :uint =  8;
    public static const START      :uint =  9;
    public static const D_PAD_UP   :uint = 11;
    public static const D_PAD_DOWN :uint = 12;
    public static const D_PAD_LEFT :uint = 13;
    public static const D_PAD_RIGHT:uint = 14;
    
    private static function getAirXbcString(inputCode:uint):String
    {
      switch (inputCode)
      {
        case A          : return X360Gamepad.GAMEPAD_A;
        case B          : return X360Gamepad.GAMEPAD_B;
        case X          : return X360Gamepad.GAMEPAD_X;
        case Y          : return X360Gamepad.GAMEPAD_Y;
        case LB         : return X360Gamepad.GAMEPAD_LEFT_SHOULDER;
        case RB         : return X360Gamepad.GAMEPAD_RIGHT_SHOULDER;
        case LS         : return X360Gamepad.GAMEPAD_STICK_LEFT;
        case RS         : return X360Gamepad.GAMEPAD_STICK_RIGHT;
        case BACK       : return X360Gamepad.GAMEPAD_BACK;
        case START      : return X360Gamepad.GAMEPAD_START;
        case D_PAD_UP   : return X360Gamepad.GAMEPAD_DPAD_UP;
        case D_PAD_DOWN : return X360Gamepad.GAMEPAD_DPAD_DOWN;
        case D_PAD_LEFT : return X360Gamepad.GAMEPAD_DPAD_LEFT
        case D_PAD_RIGHT: return X360Gamepad.GAMEPAD_DPAD_RIGHT;
      }
      return "";
    }
    
    private static const MAX_GAME_PADS:uint    = 4;
    private static const STICK_MIN_INV:Number  = 1.0 / 32768.0;
    private static const STICK_MAX_INV:Number  = 1.0 / 32767.0;
    
    private var airxbc_:Airxbc = null;
    private var gpads_ :Vector.<X360Gamepad> = null;
    
    private var allKeyCodes_   :Dictionary          = null;
    private var prevDownStatus_:Vector.<Dictionary> = null;
    private var downStatus_    :Vector.<Dictionary> = null;
    private var pressStatus_   :Vector.<Dictionary> = null;
    private var releaseStatus_ :Vector.<Dictionary> = null;
    
    private var connected_ :Vector.<Boolean> = null;
    
    public function getNumControllers():uint
    {
      try
      {
        return airxbc_.getNumControllers();
      }
      catch (e:Error)
      { }
      return 0;
    }
    
    public function isConnected(controllerID:uint = 0):Boolean
    {
      return connected_[controllerID];
    }
    
    public function leftTrigger(controllerID:uint = 0):Number
    {
      if (!isConnected(controllerID)) return 0.0; //not connected, return zero
      return gpads_[controllerID].leftTriggerAsPercent;
    }
    
    public function rightTrigger(controllerID:uint = 0):Number
    {
      if (!isConnected(controllerID)) return 0.0; //not connected, return zero
      return gpads_[controllerID].rightTriggerAsPercent;
    }
    
    public function leftStickX(controllerID:uint = 0):Number
    {
      if (!isConnected(controllerID)) return 0.0; //not connected, return zero
      var result:Number = Number(gpads_[controllerID].leftStickX);
      if (result >= 0.0) result *= STICK_MAX_INV;
      else               result *= STICK_MIN_INV;
      return result;
    }
    
    public function isDown(button:uint, controllerID:uint = 0):Boolean
    {
      if (!isConnected(controllerID)) return false; //not connected, return false
      return downStatus_[controllerID][button];
    }
    
    public function isPressed(button:uint, controllerID:uint = 0):Boolean
    {
      if (!isConnected(controllerID)) return false; //not connected, return false
      return pressStatus_[controllerID][button];
    }
    
    public function isReleased(controllerID:uint, button:uint):Boolean
    {
      if (!isConnected(controllerID)) return false; //not connected, return false
      return releaseStatus_[controllerID][button];
    }
    
    private var firstUpdate_:Boolean = true;
    override public function update(dt:Number):void 
    {
      //delay all updates and signals till second update 
      //before client has a chance to listen to the connection/disconnection signals
      if (firstUpdate_)
      {
        firstUpdate_ = false;
        return;
      }
      
      for (var i:uint = 0; i < MAX_GAME_PADS; ++i)
      {
        try
        {
          gpads_[i] = airxbc_.pollGamePad(i);
        }
        catch (e:Error)
        {
          gpads_[i] = null;
        }
        
        var wasConnected:Boolean = connected_[i];
        
        var gpad:X360Gamepad = gpads_[i];
        if (!gpad) //continue if controller is not available
        {
          connected_[i] = false;
          
          //dispatch disconnection signal
          if (wasConnected) onControllerDisconnected.dispatch(i);
          continue;
        }
        else
        {
          connected_[i] = true;
          //(the connection signal is dispatched at the end of this function)
        }
        
        //update key status
        for (var key:* in allKeyCodes_)
        {
          var keyCode:uint = key;
          
          downStatus_[i][keyCode] = gpads_[i].isButtonDown(getAirXbcString(keyCode));
          
          //fill in press and release status
          pressStatus_  [i][keyCode] =  Boolean(downStatus_[i][keyCode]) && !Boolean(prevDownStatus_[i][keyCode]);
          releaseStatus_[i][keyCode] = !Boolean(downStatus_[i][keyCode]) &&  Boolean(prevDownStatus_[i][keyCode]);
          
          //copy current status to previous
          prevDownStatus_[i][keyCode] = downStatus_[i][keyCode];
        }
        
        //dispatch connection signal (after all status has been updated so the client can pull data right away)
        if (!wasConnected) onControllerConnected.dispatch(i);
      }
    }
    
    override public function init():void 
    {
      airxbc_ = new Airxbc();
      gpads_  = new Vector.<X360Gamepad>(MAX_GAME_PADS, true);
      
      allKeyCodes_ = new Dictionary();
      allKeyCodes_[A          ] = A          ;
      allKeyCodes_[B          ] = B          ;
      allKeyCodes_[X          ] = X          ;
      allKeyCodes_[Y          ] = Y          ;
      allKeyCodes_[LB         ] = LB         ;
      allKeyCodes_[RB         ] = RB         ;
      allKeyCodes_[LS         ] = LS         ;
      allKeyCodes_[RS         ] = RS         ;
      allKeyCodes_[BACK       ] = BACK       ;
      allKeyCodes_[START      ] = START      ;
      allKeyCodes_[D_PAD_UP   ] = D_PAD_UP   ;
      allKeyCodes_[D_PAD_DOWN ] = D_PAD_DOWN ;
      allKeyCodes_[D_PAD_LEFT ] = D_PAD_LEFT ;
      allKeyCodes_[D_PAD_RIGHT] = D_PAD_RIGHT;
      
      prevDownStatus_ = new Vector.<Dictionary>(MAX_GAME_PADS, true);
      downStatus_     = new Vector.<Dictionary>(MAX_GAME_PADS, true);
      pressStatus_    = new Vector.<Dictionary>(MAX_GAME_PADS, true);
      releaseStatus_  = new Vector.<Dictionary>(MAX_GAME_PADS, true);
      connected_      = new Vector.<Boolean>(MAX_GAME_PADS, true);
      for (var i:uint = 0; i < MAX_GAME_PADS; ++i)
      {
        prevDownStatus_[i] = new Dictionary();
        downStatus_    [i] = new Dictionary();
        pressStatus_   [i] = new Dictionary();
        releaseStatus_ [i] = new Dictionary();
        connected_     [i] = false;
      }
    }
    
    override public function dispose():void 
    {
      try
      {
        airxbc_.dispose();
      }
      catch (e:Error) { }
      gpads_ = null;
      
      allKeyCodes_    = null;
      prevDownStatus_ = null;
      downStatus_     = null;
      pressStatus_    = null;
      releaseStatus_  = null;
      
      connected_ = null;
    }
  }
}