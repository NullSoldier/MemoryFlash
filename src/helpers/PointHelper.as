package helpers
{
	import flash.geom.Point;

	public class PointHelper
	{
		public static function DivSingle (point:Point, value:Number) : Point
		{
			return Div (point, value, value);
		}
		
		public static function Div (point:Point, xDiv:Number, yDiv:Number) : Point
		{
			return new Point (int(point.x / xDiv), int(point.y / yDiv));
		}
		
		public static function MultSingle (point:Point, value:Number) : Point
		{
			return Mult (point, value, value);
		}
		
		public static function Mult (point:Point, xMult:Number, yMult:Number) : Point
		{
			return new Point (int(point.x * xMult), int(point.y * yMult));
		}
		
		public static function Sub (point:Point, xSub:Number, ySub:Number) : Point
		{
			return new Point (point.x - xSub, point.y - ySub);
		}
		
		public static function Difference (point1:Point, point2:Point) : Point
		{
			return new Point (Math.abs (point1.x - point2.x), Math.abs (point1.y - point2.y));
		}
	}
}