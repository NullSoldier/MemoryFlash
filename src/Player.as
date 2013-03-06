package  
{
	import caurina.transitions.TweenTask;
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	
	import helpers.*;
	
	public class Player 
	{
		public function Player (art:ApplicationDomain)
		{
			clip = MCHelper.FromAppDomain (art, "player");
			moveQueue = new Vector.<Point>();
			items = new Vector.<GameItem>();
		}
		
		public var clip:MovieClip;
		public var items:Vector.<GameItem>;
		public var moveQueue:Vector.<Point>;
		public var isWalking:Boolean;
		public var target:Hotspot;
		public var itemAdded:Function;
		public var itemRemoved:Function;
		
		
		public function get pos() : Point { return new Point (clip.x, clip.y); }
		public function set pos (v:Point) : void { clip.x = v.x; clip.y = v.y; }
		
		public function hasItem (name:String) : Boolean
		{
			return items.indexOf (name) != -1;
		}
		
		public function addItem (item:GameItem) : void
		{
			items.push (item);
			if (itemAdded != null)
				itemAdded (item);
		}
		
		public function moveTo (dest:Point, target:*) : void
		{
			trace ("Moving to " + dest.toString());
			clearMoveQueue();
			this.target = target;

			var path:Vector.<Point> = PathFinder.CalculatePath (pos, dest, Main.current.NavMesh);
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
		
		private var tween:TweenTask;
		private var isMoving:Boolean;
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
			isMoving = true;
			var to:Point = moveQueue.shift();
			var totalMoveTime:Number = Point.distance (to, new Point (clip.x, clip.y)) / MOVE_SPEED;
			
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
			trace ("Finished moving");
			isMoving = false;
			
			if (moveQueue.length == 0 && target != null) {
				target.activate();
				target = null;
			}
		}
	}
}