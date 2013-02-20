package helpers
{
	import caurina.transitions.TweenTask;
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class TweenHelper
	{
		public static const LINEAR:String = "linear";
		public static const EASE_IN_SINE:String = "easeInSine";
		public static const EASE_OUT_BOUNCE:String = "easeOutBounce";
		public static const EASE_OUT_CUBIC:String = "easeOutCubic";
		public static const EASE_IN_CUBIC:String = "easeInCubic";
		public static const EASE_OUT_QUART:String = "easeOutQuart";
		public static const EASE_IN_QUART:String = "easeInQuart";
		public static const EASE_OUT_QUAD:String = "easeOutQuad";
		public static const EASE_IN_QUAD:String = "easeInQuad";
		public static const EASE_IN_EXPO:String = "easeInExpo";
		public static const EASE_OUT_EXPO:String = "easeOutExpo";
		
		public static function FadeIn (source:DisplayObject, duration:Number,
			type:String=LINEAR, callback:Function=null) : TweenTask
		{
			return fade (1, source, duration, type, callback);
		}
		
		public static function FadeOut (source:DisplayObject, duration:Number,
			type:String=LINEAR, callback:Function=null) : TweenTask
		{
			return fade (0, source, duration, type, callback);
		}
		
		private static function fade (alphaTo:int, source:DisplayObject, duration:Number,
			type:String=LINEAR, callback:Function=null) : TweenTask
		{			
			return Tweener.addTween (source, {
				alpha: alphaTo,
				time: duration,
				transition: type,
				onComplete: callback
			});
		}
	}
}