package  
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import geom.PolyNode;
	import geom.Polygon;
	
	import levels.Level;
	
	public class ScreenDebugger 
	{
		public static function DrawInventory (inv:InventoryControl) : void
		{
			var s:Sprite = new Sprite();
			for each (var node:PolyNode in inv.slotSpots)
				DrawPolygon (s.graphics, node.poly, 0xFFFFE0);
			inv.clip.addChild (s);
		}
		public static function DrawDebug (level:Level) : void
		{
			var s:Sprite = new Sprite();
			for each (var node:PolyNode in level.NavMesh)
				DrawPolygon (s.graphics, node.poly, node.enabled ? 0x0074B9 : 0x9B30FF);
			for each (var spot:Hotspot in level.Spots)
				DrawPolygon (s.graphics, spot, spot.willDisapear ? 0xFF0000 : 0x00FF00);
			level.Content.addChild (s);
		}
		
		public static function DrawPolygon (g:Graphics, poly:Polygon, color:int) : void
		{
			if (poly.vertices.length == 0)
				return;
			
			g.lineStyle (3, color);
			//g.beginFill (123, 1);
			g.moveTo (poly.vertices[0].x, poly.vertices[0].y);
			for each (var p:Point in poly.vertices) {
				g.lineTo (p.x, p.y);
			}
			g.lineTo (poly.vertices[0].x, poly.vertices[0].y);
			//g.endFill();
		}
	}
}