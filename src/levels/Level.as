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
		
		public function CreateHotspot (clip:MovieClip, name:String, isActive:Boolean,
			canMouseOver:Boolean, poly:Polygon, activated:Function) : Hotspot
		{
			var spot:Hotspot = new Hotspot (clip, name, isActive, canMouseOver, activated, poly.vertices);
			Spots.push (spot);
			return spot;
		}
		
		public function FindPoly (p:Point) : Polygon
		{
			var result:PolyNode = FindNavPoly (NavMesh, p);
			return result ? result.poly : null;
		}
		
		public static function FindNavPoly (n:Vector.<PolyNode>, p:Point) : PolyNode
		{
			for each (var node:PolyNode in n) {
				if (CollisionChecker.PointToPoly (p, node.poly)) {
					return node;
				}
			}
			return null;			
		}
	}
}