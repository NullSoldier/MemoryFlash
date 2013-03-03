package  
{
	import flash.geom.Point;
	import geom.Polygon;
	import geom.PolyLink;
	import geom.PolyNode;
	import levels.Level;
	
	public class PathFinder
	{
		public static function CalculatePath (start:Point, end:Point, n:Vector.<PolyNode>) : Vector.<Point>
		{
			var startPoly:PolyNode = Level.FindNavPoly (n, start);
			var endPoly:PolyNode = Level.FindNavPoly (n, end);

			var currentPoly:PolyNode = startPoly;
			var route:Vector.<Point> = new <Point> [start];

			const MAX_STEPS:int = 10;
			var steps:int = 0;
			while (true)
			{
				currentPoly = StepPath (route, currentPoly, endPoly, end);
				if (currentPoly == null)
					break;

				steps++;
				if (steps >= MAX_STEPS)
					break;
			}

			route.push (end);
			return route;
		}

		private static function StepPath (route:Vector.<Point>,
			current:PolyNode, end:PolyNode, endv:Point) : PolyNode
		{
			if (current == null) {
				return null;
			}
			if (current == end) { 
				return null;
			}

			var shortestLink:PolyLink = null;
			var shortestDistance:int = int.MAX_VALUE;

			for each (var link:PolyLink in current.links)
			{
				var d:int = Point.distance (link.target.loc, endv);
				if (shortestLink == null || d < shortestDistance) {
					shortestDistance = d;
					shortestLink = link.target;
				}
			}

			if (shortestLink != null)
			{
				route.push (shortestLink.loc);
				return shortestLink.parent;
			}
			return null;
		}
	}
}