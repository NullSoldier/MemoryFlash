package  
{
	import flash.geom.Point;
	import geom.Polygon;
	public class PolyFactory 
	{	
		public static function CreateCircle (x:int, y:int, radius:int) : Polygon
		{				
			var verts:Array = [];
			var pi2:Number = Math.PI * 2;
			var steps:int = 16;
			
			for (var i:int = 0; i < steps; i++) {
				var ptx:Number = x + radius * Math.cos(i / steps * pi2);
				var pty:Number = y + radius * Math.sin(i / steps * pi2);
				verts.push (new Point (ptx, pty));
			}
			return new Polygon (verts);
		}
	}
}