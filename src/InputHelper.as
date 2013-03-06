package
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import geom.Polygon;
	import levels.Level;

	public class InputHelper
	{
		public static function getTargetAtInput (stageLoc:Point,
			inv:InventoryControl, current:Level) : Object
		{
			// Inventory item
			var item:GameItem = inv.getItemAt (stageLoc);
			if (item) return item;
			
			// Hotspot
			var local:Point = current.Content.globalToLocal (stageLoc);
			for each (var h:Hotspot in current.Spots) {
				if (PolyCheck.PointInPoly (local, h) && h.canMouseOver) {
					return h;
				}
			}
			
			// Navmesh on level
			return PolyCheck.PointInLevelPoly (local, current);
		}
	}
}