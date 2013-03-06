package levels
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import geom.Polygon;
	import geom.PolyNode;
	import helpers.*;
	
	public class Level 
	{
		public var Content:MovieClip;
		public var LayerHolder:MovieClip;
		public var NavMesh:Vector.<PolyNode>;
		public var Spots:Vector.<Hotspot> = new Vector.<Hotspot>();
		
		public function OnEnter() : void
		{
			throw new Error ("ABSTRACT");
		}
		
		public function CreateHotspot (clip:MovieClip, name:String, args:int,
			poly:Polygon, activated:Function) : Hotspot
		{
			var spot:Hotspot = new Hotspot (clip, name, args, activated, poly.vertices);
			Spots.push (spot);
			return spot;
		}
	}
}