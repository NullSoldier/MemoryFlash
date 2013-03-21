package  
{
	import levels.Level;
	import flash.geom.Point;
	import geom.*;	
	
	public class PolyCheck
    {
		public static function PointInLevelPoly (p:Point, level:Level) : Polygon
		{
			var result:PolyNode = PointInNavMesh (p, level.NavMesh);
			return result ? result.poly : null;
		}
		
		public static function PointInNavMesh (p:Point, n:Vector.<PolyNode>) : PolyNode
		{
			for each (var node:PolyNode in n) {
				if (node.enabled && PolyCheck.PointInPoly (p, node.poly)) {
					return node;
				}
			}
			return null;			
		}
		
		public static function PointInPoly (p:Point, poly:Polygon) : Boolean
		{
			var inside:Boolean = false;
			var i:int = 0;
				
			for (var j:int = poly.vertices.length - 1; i < poly.vertices.length; j = i++)
			{
				var xi:int = poly.vertices[i].x;
				var yi:int = poly.vertices[i].y;
				var xj:int = poly.vertices[j].x;
				var yj:int = poly.vertices[j].y;

				if ((yi > p.y) != (yj > p.y)
					&& (p.x < (xj - xi)*(p.y - yi)/(yj - yi) + xi))
				{
					inside = !inside;
				}
			}
			return inside;
		}
    }
}