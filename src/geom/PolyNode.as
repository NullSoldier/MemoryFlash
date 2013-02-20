package geom 
{
	public class PolyNode 
	{
		public function PolyNode (poly:Polygon) 
		{
			this.poly = poly;
			links = new Vector.<PolyLink>();
		}
		
		public var poly:Polygon;
		public var links:Vector.<PolyLink>;
		
		public function AddLink (link:PolyLink) : void
		{
			link.parent = this;
			links.push (link);
		}
	}
}