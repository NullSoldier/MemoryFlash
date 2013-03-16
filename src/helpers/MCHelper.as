package helpers
{	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;

	public class MCHelper
	{
		public static function PlayContainer (clip:MovieClip, frameName:String) : void
		{
			clip.gotoAndStop (frameName);
			
			ForEachChild (clip, function(child:*):void {
				if (AS3Helper.FunctionExists (child, "Play"))
					child.Play();
			});
		}
		
		public static function SetClipPos (clip:DisplayObject, position:Point) : void
		{
			clip.x = position.x;
			clip.y = position.y;
		}
		
		public static function SetBounds (clip:DisplayObject,
			 x:int, y:int, w:int, h:int) : void
		{
			clip.x = x;
			clip.y = y;
			clip.width = w;
			clip.height = h;
		}
		
		public static function CenterClip (clip:DisplayObject, forceStageUsage:Boolean = false) : void
		{
			var centerToStage:Boolean = !clip.parent || forceStageUsage;
			
			if (centerToStage && clip.stage == null)
				throw new Error ("Clip has no parent, and isn't on a stage.");
			
			if (centerToStage)
				centerClip (clip, clip.stage.x, clip.stage.y, clip.stage.stageWidth, clip.stage.stageHeight);
			else
				centerClip (clip, clip.parent.x, clip.parent.y, clip.parent.width, clip.parent.height);
		}
		
		public static function CenterClipTo (source:DisplayObject, target:DisplayObject) : void
		{
			centerClip (source, target.x, target.y, target.width, target.height);
		}
		
		public static function GetClipPos (clip:MovieClip) : Point
		{
			return new Point (clip.x, clip.y);
		}
		
		public static function RemoveAllChildren (clip:DisplayObjectContainer) : void
		{
			while (clip.numChildren > 0)
				clip.removeChildAt (0);
		}
		
		public static function CopyChildren (source:DisplayObjectContainer, dest:DisplayObjectContainer) : void
		{
			AS3Helper.ForEachChild (source, function(item:DisplayObject):void {
				dest.addChild (item);
			});
		}
		
		public static function FromAppDomain (appDomain:ApplicationDomain, name:String, visible:Boolean=true) : MovieClip
		{
			var clipDef:Class = appDomain.getDefinition (name) as Class;
			var clip:MovieClip = new clipDef as MovieClip;
			clip.visible = visible;
			clip.stop();
				
			return clip;
		}
		
		public static function HasNamedFrame (clip:MovieClip, name:String) : Boolean
		{
			return AS3Helper.Some (clip.currentLabels, function (label:FrameLabel) : Boolean {
				return label.name == name });
		}
		
		public static function ForEachChild (clip:DisplayObjectContainer, func:Function, recurse:Boolean=true) :void
		{
			for (var i:int=0; i<clip.numChildren; i++)
			{
				var child:* = clip.getChildAt (i);
				func (child);
				
				if (recurse && child is DisplayObjectContainer && child.numChildren > 0)
					MCHelper.ForEachChild (child, func);
			}
		}
		
		public static function StopAllChildren (clip:MovieClip) : void
		{
			MCHelper.ForEachChild (clip, function(item:*) : void
			{
				if (item is MovieClip)
					item.stop();
			});
		}
		
		public static function SetEqualBound (source:DisplayObject, target:DisplayObject) : void
		{
			source.x = target.x;
			source.y = target.y;
			source.width = target.width;
			source.height = target.height;
		}
		
		public static function SetEqualPos (source:DisplayObject, target:DisplayObject) : void
		{
			source.x = target.x;
			source.y = target.y;
		}
		
		public static function AboveTargetIndex (source:DisplayObject, target:DisplayObject) : void
		{
			Check.ArgNull (source.parent);
			Check.ArgNull (target.parent);
			Check.IsNotEqual (source.parent, target.parent);
			
			var sourceIndex:int = target.parent.getChildIndex (target) + 1;
			sourceIndex = AS3Helper.Clamp (sourceIndex, 0, target.parent.numChildren);
			
			target.parent.setChildIndex (source, sourceIndex);			
		}
		
		public static function PlayRandomFrame (source:MovieClip) : void
		{
			var randomFrame:int = int (AS3Helper.Lerp (Math.random(), 1, source.totalFrames - 1));
			source.gotoAndPlay (randomFrame);
		}
		
		//TODO: NotSupported
		/*public static function DrawOutline (target:DisplayObjectContainer, color:int = Colors.RED) : void
		{
			var bounds:Rectangle = target.getBounds(target.parent);
			DrawRectangleIn (target, color, bounds.x, bounds.y, bounds.width, bounds.height);
		}
		
		public static function DrawBounds (target:DisplayObjectContainer, color:int = Colors.RED) : void
		{
			var bounds:Rectangle = target.getBounds(target.parent);			
			DrawRectangleIn (target.parent, color, bounds.left, bounds.top, bounds.right, bounds.bottom);
		}

		public static function DrawRectangleIn (target:DisplayObjectContainer, color:int,
			left:int, top:int, right:int, bottom:int) : void
		{
			var myBorder:Sprite = new Sprite();
			myBorder.graphics.lineStyle (5, color);
			myBorder.graphics.moveTo (left, top);
			myBorder.graphics.lineTo (right, top);
			myBorder.graphics.lineTo (right, bottom);
			myBorder.graphics.lineTo (left, bottom);
			myBorder.graphics.lineTo (left, top);
			
			target.addChild (myBorder);
		}*/
		
		private static function centerClip (source:DisplayObject, x:int, y:int, width:int, height:int) : void
		{			
			source.x = (width / 2) - (source.width / 2);
			source.y = (width / 2) - (source.height / 2);
		}
		
		public static function BringToFront (clip:DisplayObject) : void
		{
			if (clip.parent != null)
				clip.parent.setChildIndex (clip, clip.parent.numChildren-1);
		}
	}
}