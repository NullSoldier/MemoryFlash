package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import geom.Polygon;
	
	import helpers.AS3Helper;
	
	public class Hotspot extends Polygon
	{
		/**
		@param clip
		@param name The name to display in the inventory and moused over
		@param args The HO arguments for this hotspot (see @class HO)
		@param activated activated (self:HotSpot, item:GameItem) : void
		@param vertices The vertexes which will make up the hit polygon
		**/
		public function Hotspot (clip:MovieClip, name:String, args:int,
			activated:Function, vertices:Array)
		{
			super (vertices);
			parseArgs (args);
			
			this.clip = clip;
			this.name = name;
			this.activated = activated;
			
			if (clip == null && willDisapear)
				throw new Error ("You must provide a clip if you want the clip to disapear");
		}
		
		public var clip:MovieClip;
		public var name:String;
		public var moveTo:Point;
		public var activated:Function;
		
		public var canMouseOver:Boolean;
		public var isActive:Boolean;
		public var willDisable:Boolean;
		public var willDisapear:Boolean;
		
		public function activate (item:GameItem=null) : void
		{
			if (willDisapear) {
				clip.visible = false;
			}
			if (willDisable) {
				isActive = false;
				canMouseOver = false;
			}
			if (activated != null) {
				activated.apply (null,  [this, item].slice(0, activated.length));
			}
		}
		
		public function enable() : void
		{
			isActive = true;
			canMouseOver = true;
			clip.visible = true;
		}
		
		private function parseArgs (args:int) : void
		{
			canMouseOver	= int (args & HO.CAN_MOUSEOVER) == HO.CAN_MOUSEOVER;
			isActive 		= int (args & HO.IS_ACTIVE)		== HO.IS_ACTIVE;
			willDisable		= int (args & HO.WILL_DISABLE) 	== HO.WILL_DISABLE;
			willDisapear 	= int (args & HO.WILL_DISAPEAR) == HO.WILL_DISAPEAR;
		}
	}
}