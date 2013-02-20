package  
{
	import geom.*;
	import flash.geom.Point;
	
	public class CollisionChecker
    {		
		public static function PointToPoly (point:Point, poly:Polygon) : Boolean
		{
			var inside:Boolean = false;
			var i:int = 0;
				
			for (var j:int = poly.vertices.length - 1; i < poly.vertices.length; j = i++)
			{
				var xi:int = poly.vertices[i].x;
				var xj:int = poly.vertices[j].x;
				var yi:int = poly.vertices[i].y;
				var yj:int = poly.vertices[j].y;

				if ((yi > point.y) != (yj > point.y)
					&& (point.x < (xj - xi)*(point.y - yi)/(yj - yi) + xi))
				{
					inside = !inside;
				}
			}
			return inside;
		}
    }
}