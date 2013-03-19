package
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class BitmapAnimation
	{		
		public function BitmapAnimation (source:BitmapData,
			numFrames:int, bounds:Rectangle) : void
		{
			frames = new Vector.<BitmapData>();
			var sourceRect:Rectangle = bounds.clone();
			
			for (var i:int=0; i<numFrames; i++) {
				var frame:BitmapData = new BitmapData (sourceRect.width, sourceRect.height);
				frame.copyPixels (source, sourceRect, new Point (0, 0));
				frames.push (frame);
				sourceRect.x += bounds.width;
			}
		}
		
		public function get totalFrames() : uint
		{
			return frames.length;
		}
		
		public function getBitmapDataForFrame (frameIndex:int) : BitmapData
		{
			if( frameIndex < 0 || frameIndex >= frames.length ) {
				throw new Error("Frame index out of bounds.");
			}
			return frames[frameIndex];
		}
		
		private var frames:Vector.<BitmapData>;
	}
}