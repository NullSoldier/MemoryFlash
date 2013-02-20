package geom 
{
	import flash.geom.*;
	
	public class PolyLink
	{
		public function PolyLink (x:int, y:int)
		{
			this.loc = new Point (x, y);
		}
		
		public var parent:PolyNode;
		public var target:PolyLink;
		public var loc:Point;
		
		public static function AttachLinks (x:int, y:int, n1:PolyNode, n2:PolyNode) : void
		{
			var a:* = new PolyLink (x, y);
			var b:* = new PolyLink (x, y);
			a.Target = b;
			b.Target = a;
			n1.AddLink (a);
			n2.AddLink (b);			
		}
	}
}