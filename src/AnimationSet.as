package
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class AnimationSet
	{	
		public function AnimationSet (container:Bitmap)
		{
			this.container = container;
			this.container.addEventListener (Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function add (name:String, anim:BitmapAnimation) : void
		{
			anims[name] = anim;
		}
		
		public function playLoop (name:String, mirror:Boolean=false) : void
		{
			play (name, mirror, null);
			isLooping = true;
		}
		
		// @param finished finished (void) : void
		public function play (name:String, mirror:Boolean=false,
			finished:Function=null) : void
		{
			if (!anims[name])
				throw new Error ("Anim does not exist");
			
			trace ("Playing animation " + name);
			currentAnim = anims[name];
			currentFrame = -1;
			finishedCallback = finished;
			isLooping = false;
			
			if ((mirror && container.scaleX > 0) ||
				(!mirror && container.scaleX < 0)) {
				container.scaleX *= -1
				centerFrame();
			}
			
			moveOneFrame();
			
		}
		
		public function stop() : void
		{
			currentAnim = null;
			currentFrame = 0;
		}
		
		private var container:Bitmap;
		private var anims:Dictionary = new Dictionary();
		private var currentAnim:BitmapAnimation;
		private var currentFrame:int;
		private var finishedCallback:Function;
		private var isLooping:Boolean;
		
		private var lastUpdate:Number = 0;
		private const playbackRate:Number = 10; // frames/sec
		
		private function onEnterFrame (e:Event) : void
		{
			if (!currentAnim) {
				return;
			}
			if (getTimer() - lastUpdate > 1000/playbackRate) {
				lastUpdate = getTimer();
				moveOneFrame();
			}
		}
		
		private function moveOneFrame() : void
		{
			currentFrame = (currentFrame+1) % currentAnim.totalFrames;
			container.bitmapData = currentAnim.getBitmapDataForFrame (currentFrame);
			centerFrame();
			
			if (currentFrame == currentAnim.totalFrames-1) {
				if (isLooping) {
					currentFrame = 0;
				} else {
					stop();
				}
				if (finishedCallback != null) {
					finishedCallback();
				}
			}
		}
		
		private function centerFrame() : void
		{
			container.x = -container.width/2;
			container.y = -container.height;
			if (container.scaleX < 0)
				container.x *= -1;	
		}
	}
}