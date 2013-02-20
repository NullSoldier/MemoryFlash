package 
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import helpers.MCHelper;
	import flash.display.MovieClip;
	
	public class DarkenButton extends EventDispatcher
	{
		public static const BUTTON_CLICKED:String = "DarkenButton::Clicked";
		
		public var displayObject:MovieClip;
		private var bounds:Rectangle;
		private var _inputPointContained:Boolean;
		private var stage:Stage;
		private var hitArea:DisplayObject;
		private var _enabled:Boolean;
		
		public function DarkenButton(displayObject:MovieClip)
		{
			if (displayObject == null)
				throw new Error ("displayObject arg cannot be null");
				
			this.displayObject = displayObject;
			this.hitArea = displayObject;
			
			this.hitArea.addEventListener(MouseEvent.MOUSE_DOWN, onInputBegin);
			this.hitArea.addEventListener(TouchEvent.TOUCH_BEGIN, onInputBegin);
			
			this._enabled = true;
			
			if (MCHelper.HasNamedFrame (displayObject, "Up") || MCHelper.HasNamedFrame (displayObject, "Down"))
				displayObject.stop();
		}
		
		public function set enable( b : Boolean ) : void {
			
			_enabled = b;
			
			if( b ) {
				if (MCHelper.HasNamedFrame (displayObject, "Up"))
					displayObject.gotoAndStop ("Up");							
			} else {
				if (MCHelper.HasNamedFrame (displayObject, "Down"))
					displayObject.gotoAndStop ("Down");											
			}
		}
		
		public function get inputPointContained():Boolean
		{
			return _inputPointContained;
		}
		
		public function set inputPointContained(value:Boolean):void
		{
			if( _inputPointContained != value ){
				_inputPointContained = value;
				
				if( _enabled ) {
					
					if( _inputPointContained ) {
						if (MCHelper.HasNamedFrame (displayObject, "Down"))
							displayObject.gotoAndStop ("Down");
					} else {
						if (MCHelper.HasNamedFrame (displayObject, "Up"))
							displayObject.gotoAndStop ("Up");	
					}
				}
			}
		}
		
		private function onInputBegin(event:Event):void{
			//event.stopPropagation();
			
			stage = displayObject.stage;
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onInputMove);
			stage.addEventListener( TouchEvent.TOUCH_MOVE, onInputMove);
			stage.addEventListener( MouseEvent.MOUSE_UP, onInputEnd);
			stage.addEventListener( TouchEvent.TOUCH_END, onInputEnd);
			bounds = hitArea.getBounds(stage);
			//bounds.inflate( bounds.width, bounds.height );
			this.inputPointContained = true;
		}
		
		private function onInputEnd(event:Object):void {
			//event.stopPropagation();
			
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onInputMove);
			stage.removeEventListener( TouchEvent.TOUCH_MOVE, onInputMove);
			stage.removeEventListener( MouseEvent.MOUSE_UP, onInputEnd);
			stage.removeEventListener( TouchEvent.TOUCH_END, onInputEnd);
			this.inputPointContained = false;
			
			if( _enabled && bounds.contains( event.stageX, event.stageY ) ){
				this.dispatchEvent(new MouseEvent (BUTTON_CLICKED, true, false, event.localX, event.localY));
			}
		}
		
		private function onInputMove(event:Object):void{
			this.inputPointContained = bounds.contains( event.stageX, event.stageY );
		}
	}
}