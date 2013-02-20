package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import geom.Polygon;
	
	public class Hotspot extends Polygon
	{	
		public function Hotspot (clip:MovieClip, name:String, isActive:Boolean,
			canMouseOver:Boolean, activated:Function, vertices:Array)
		{
			super (vertices);
			
			this.clip = clip;
			this.name = name;
			this.isActive = isActive;
			this.canMouseOver = canMouseOver;
			this.activated = activated;
		}
		
		public var clip:MovieClip;
		public var name:String;
		public var isActive:Boolean;
		public var canMouseOver:Boolean;
		public var moveTo:Point;
		public var activated:Function;
	}
}