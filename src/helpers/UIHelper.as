package helpers
{
	/* Custom properties used */
	// MovieClip.clickedCallback
	// Movieclip.toggleCallback
	// MovieClip.toggleState
	// MovieClip.ignoreDisable
	// MovieClip.dragClass;
	// MovieClip.dragCallback;
	// MovieClip.original
	
	import adobe.utils.CustomActions;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.*;
	
	public class UIHelper
	{		
		public static function MakeButton (clip:MovieClip, callback:Function) : DarkenButton
		{
			Check.ArgNull (clip, "clip");
			Check.ArgNull (callback, "callback");
			
			var button:DarkenButton = new DarkenButton(clip);
			button.addEventListener (DarkenButton.BUTTON_CLICKED, function(e:Event):void {
				AS3Helper.Apply (callback, e);
			});
			clip.stop();
			return button;
		}
		
		// Helper class with state? Terrible. Make a dragging provider that's given to the UIHelper
		// and the UI helper uses that drag provider
		public static function RegisterStage (stage:Stage) : void
		{
			registeredStage = stage;
			registeredStage.addEventListener (MouseEvent.MOUSE_MOVE, onMouseMoveOnStage);
			registeredStage.addEventListener (TouchEvent.TOUCH_MOVE, onTouchMoveOnStage);
			trace ("Stage registered with UI Helper");
		}
		
		public static function MakeToggleButton (clip:MovieClip, callback:Function) : void
		{			
			clip.toggleCallback = callback;
			clip.toggleState = false;
			
			if (MCHelper.HasNamedFrame (clip, "Up"))
				clip.gotoAndStop ("Up");
			
			clip.addEventListener (MouseEvent.CLICK, onToggled);
			clip.addEventListener (TouchEvent.TOUCH_END, onToggled);
			
		}
		
		public static function MakeRadioButton (clip:MovieClip, callback:Function) : void
		{
			clip.ignoreDisable = true;
			clip.toggleCallback = callback;
			clip.toggleState = false;
			
			if (MCHelper.HasNamedFrame (clip, "Up"))
				clip.gotoAndStop ("Up");
			
			clip.addEventListener (MouseEvent.CLICK, onToggled);
			clip.addEventListener (TouchEvent.TOUCH_END, onToggled);
		}
		
		public static function MakeDraggableItem (clip:MovieClip, dragClass:Class, callback:Function, onStartCallback:Function = null) : void
		{
			clip.dragClass = dragClass;
			clip.dragCallback = callback;
			clip.dragStartCallback = onStartCallback;
			
			//clip.mouseEnabled = true;
			//clip.mouseChildren = false;
			
			clip.addEventListener (MouseEvent.MOUSE_DOWN, onDragStart);
			clip.addEventListener (TouchEvent.TOUCH_BEGIN, onDragStart);
		}
		
		public static function ClickRadio (clip:MovieClip) : void
		{
			// Not a radio button
			if (!clip.ignoreDisable)
				return;
			
			clip.dispatchEvent (new MouseEvent (MouseEvent.CLICK, false));
		}
		
		public static function UnclickRadio (clip:MovieClip) : void
		{
			// Not a radio button
			if (!clip.ignoreDisable)
				return;
			
			clip.toggleState = false;
			
			if (MCHelper.HasNamedFrame (clip, "Up"))
				clip.gotoAndStop ("Up");
		}
		
		private static var registeredStage:Stage;
		private static var draggingClip:MovieClip;
		private static var dragTouchID:int = -1;
		
		/* HELPER METHODS BELOW, API ABOVE */
		private static function onInputDown (e:Event) : void
		{	
			e.stopPropagation();
			var clip:MovieClip = e.currentTarget as MovieClip;
			
			if (MCHelper.HasNamedFrame (clip, "Down"))
				clip.gotoAndStop ("Down");
		}
		
		private static function onInputOut (e:Event) : void
		{
			e.stopPropagation();
			var clip:MovieClip = e.currentTarget as MovieClip;
			
			if (MCHelper.HasNamedFrame (clip, "Up"))
				clip.gotoAndStop ("Up");
		}
		
		private static function onToggled (e:Event) : void
		{
			var clip:MovieClip = e.currentTarget as MovieClip;
			
			// Used for radio buttons
			if (clip.ignoreDisable && clip.toggleState)
				return;
				
			clip.toggleState = !clip.toggleState;
			clip.toggleCallback (clip, clip.toggleState);
			
			var upOrDown:String = BoolToUpDown (clip.toggleState);
			if (MCHelper.HasNamedFrame (clip, upOrDown))
				clip.gotoAndStop (upOrDown);
		}
		
		private static function BoolToUpDown (bool:Boolean) : String
		{
			return bool ? "Down" : "Up";
		}
		
		private static function onDragStart (e:*) : void
		{
			var clip:MovieClip = e.currentTarget as MovieClip;
			var dragClass:Class = clip.dragClass as Class;
			
			var dragClip:MovieClip = dragClass != null
				? (new dragClass()) as MovieClip : clip;
			
			dragClip.original = clip;
			dragClip.x = e.stageX;
			dragClip.y = e.stageY;
			clip.stage.addChild (dragClip);
			
			if (e is TouchEvent)
				startDrag (dragClip, e.touchPointID);
			else
				startDrag (dragClip);
			
			// Tell the end user we started dragging
			if (clip.dragStartCallback != null)
				AS3Helper.Apply (clip.dragStartCallback, dragClip);
			
			// SUBSCRIBE ON END DRAG
			var onDragEnd:Function = function(e:*):void {
				endDrag();
				var originalTarget:MovieClip = dragClip.original;
							
				clip.stage.removeEventListener (MouseEvent.MOUSE_UP, onDragEnd);
				clip.stage.removeEventListener (TouchEvent.TOUCH_END, onDragEnd);
				
				dragClip.stage.removeChild (dragClip);
				originalTarget.dragCallback(e);
			};
			
			clip.stage.addEventListener (MouseEvent.MOUSE_UP, onDragEnd);
			clip.stage.addEventListener (TouchEvent.TOUCH_END, onDragEnd);
		}
		
		private static function startDrag (clip:MovieClip, touchID:int = -1 ) : void
		{
			draggingClip = clip;
			dragTouchID = touchID;
			trace ("Start dragging");
		}
		
		private static function endDrag() : void
		{
			draggingClip = null;
			dragTouchID = -1;
			trace ("End dragging");
		}
		
		private static function onMouseMoveOnStage (e:MouseEvent) : void
		{
			if (!registeredStage || !draggingClip)
				return;
				
			draggingClip.x = e.stageX;
			draggingClip.y = e.stageY;
		}
		
		private static function onTouchMoveOnStage (e:TouchEvent) : void
		{
			if (!registeredStage || !draggingClip || dragTouchID == -1)
				return;
				
			draggingClip.x = e.stageX;
			draggingClip.y = e.stageY;
		}
	}
}