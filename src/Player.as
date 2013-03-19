package  
{
	import caurina.transitions.TweenTask;
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.setInterval;
	import helpers.*;
	
	public class Player 
	{
		public function Player (art:ApplicationDomain)
		{
			moveQueue = new Vector.<Point>();
			items = new Vector.<GameItem>();
			
			bitmap = new Bitmap();
			loadAnimations (AnimationData.playerAnimationsData, art);
			
			clip = new MovieClip();
			clip.scaleX = clip.scaleY = 0.5;
			clip.addChild (bitmap);
			
			flash.utils.setInterval (playLookAnim, 3000);
		}
		
		public var clip:MovieClip;
		public var bitmap:Bitmap;
		public var items:Vector.<GameItem>;
		public var moveQueue:Vector.<Point>;
		public var isWalking:Boolean;
		public var target:Hotspot;
		public var targetItem:GameItem;
		public var itemAdded:Function;
		public var itemRemoved:Function;
		public var anims:AnimationSet;
		
		public function get pos() : Point { return new Point (clip.x, clip.y); }
		public function set pos (v:Point) : void { clip.x = v.x; clip.y = v.y; }
		
		public function hasItem (name:String) : Boolean
		{
			for each (var i:GameItem in items) {
				if (i.name == name)
					return true;
			}
			return false;
		}
		
		public function addItem (item:GameItem) : void
		{
			items.push (item);
			if (itemAdded != null)
				itemAdded (item);
		}
		
		public function removeItem (item:GameItem) : void
		{
			items.splice (items.indexOf (item), 1);
			if (itemRemoved != null)
				itemRemoved (item);
		}
		
		public function moveTo (dest:Point, target:*, item:GameItem=null) : void
		{
			if (isBusy)
				return;
			
			trace ("Moving to " + dest.toString());
			clearMoveQueue();
			this.target = target;
			this.targetItem = item;

			var path:Vector.<Point> = PathFinder.CalculatePath (pos, dest, Main.currentLevel.NavMesh);
			for each (var p:Point in path) {
				moveQueue.push (p);
			}
		}
				
		public function update() : void
		{
			if (moveQueue.length == 0)
				return;
			
			if (!isMoving)
				moveToNext();
		}
		
		public function playAnim (name:String) : void
		{
			anims.playLoop (name, isMirrored);
		}
		
		public function waitForAnim (name:String,
			callback:Function=null) : void
		{
			isBusy = true;
			anims.play (name, isMirrored, played);
			
			function played() : void {
				isBusy = false;
				if (callback)
					callback();
			}
		}
		
		private var tween:TweenTask;
		private var isMoving:Boolean;
		private var isMirrored:Boolean;
		private var isBusy:Boolean; 
		private const MOVE_SPEED:int = 280; //PIXEL/SEC
		
		private function clearMoveQueue() : void
		{
			target = null;
			isMoving = false;
			moveQueue.length = 0;
			if (tween != null)
				tween.Cancel();
		}
		
		private function moveToNext() : void
		{
			var to:Point = moveQueue.shift();
			var totalMoveTime:Number = Point.distance (to, new Point (clip.x, clip.y)) / MOVE_SPEED;
			
			isMoving = true;
			isBusy = true;
			isMirrored = to.x < clip.x;
			playAnim ("walk")
			
			Tweener.addTween (clip, {
				x: to.x,
				y: to.y,
				time: totalMoveTime,
				transition:TweenHelper.LINEAR,
				onComplete: onFinishedMove
			});
		}
		
		private function onFinishedMove() : void
		{
			isMoving = false;
			isBusy = false;
			if (moveQueue.length == 0 && target) {
				if (target.activateAnim) {
					anims.play (target.activateAnim, isMirrored, animDone);
				} else {
					animDone();
				}
				function animDone () : void {
					playAnim ("idle")
					target.activate (targetItem);
					target = null;
					targetItem = null;	
				}
			}
			else if (moveQueue.length == 0 && !target) {
				playAnim ("idle")
			}
		}
		
		private function loadAnimations (data:Array, art:ApplicationDomain) : void
		{
			anims = new AnimationSet (bitmap);
			var sheetClass:Class = Class (art.getDefinition ("character"));
			var sheet:BitmapData = BitmapData (new sheetClass());
			
			for each (var a:* in data) {
				var b:Rectangle = new Rectangle (
					a.bounds.x,
					a.bounds.y,
					a.bounds.width,
					a.bounds.height);
				anims.add (a.name, new BitmapAnimation (sheet, a.length, b));
			}
		}
		
		private function playLookAnim() : void
		{
			if (isBusy)
				return;
				
			anims.play ("look", isMirrored, function():void {
				playAnim ("idle");
			});
		}
	}
}