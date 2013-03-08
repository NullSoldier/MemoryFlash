package levels
{
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import geom.*;
	import helpers.*;
	
	public class CampLevel extends Level
	{		
		public function CampLevel (art:ApplicationDomain)
		{
			this.art = art;
			
			var p1:* = new Polygon ([
				new Point(151, 274),
				new Point(331, 257),
				new Point(435, 384),
				new Point(215, 392)]);
			
			var p2:* = new Polygon ([
				new Point(4, 416),
				new Point(215, 395),
				new Point(434, 388),
				new Point(871, 405),
				new Point(904, 714),
				new Point(2, 717)]);
			
			var p3:* = new Polygon ([
				new Point (1090 - 225, 406),
				new Point (1563 - 225, 414),
				new Point (1573 - 225, 533),
				new Point (1300 - 225, 715),
				new Point (1128 - 225, 714)]);
			
			var p4:* = new Polygon ([
				new Point(936, 398),
				new Point(1113, 287),
				new Point(1219, 295),
				new Point(1267, 402)]);
			
			var p1n:* = new PolyNode (p1);
			var p2n:* = new PolyNode (p2);
			var p3n:* = new PolyNode (p3);
			var p4n:* = new PolyNode (p4);
			
			PolyLink.AttachLinks (318, 391, p1n, p2n);
			PolyLink.AttachLinks (887, 555, p2n, p3n);
			PolyLink.AttachLinks (1119, 403, p3n, p4n);
			
			NavMesh = new <PolyNode> [
				p1n,
				p2n,
				p3n,
				p4n,
			];
			
			Content = MCHelper.FromAppDomain (art, "CampScene");
			Content.fire.visible = false;
			Content.firelight.visible = true;
			Content.batteries.visible = false;
			Content.letter.visible = false;
			
			LayerHolder = Content.holder;
			LayerHolder.visible = false;
			
			tent = CreateHotspot (null, "Tent Entrance",
				HO.IS_ENABLED,
				new Polygon ([
					new Point (3, 277),
					new Point (333, 247),
					new Point (83, 107),
					new Point (2, 107)]),
				onTentTouched);
				
			forest = CreateHotspot (null, "Dark Forest Entrance",
				HO.IS_ENABLED,
				new Polygon([
					new Point (1087, 281),
					new Point (1075, 110),
					new Point (1277, 114),
					new Point (1268, 301)]),
				onForestTouched);
			
			fire = CreateHotspot (null, "Unlit fire",
				HO.IS_ENABLED,
				new Polygon([
					new Point (50, 465),
					new Point (184, 412),
					new Point (307, 458),
					new Point (290, 503),
					new Point (194, 526),
					new Point (97, 518)]),
				onFireTouched);
			
			backpack = CreateHotspot (Content.backpack, "Backpack",
				HO.IS_ENABLED | HO.WILL_DISABLE,
				PolyFactory.CreateRectangle (798, 410, 120, 60),
				onBackpackTouched);
			
			letter = CreateHotspot (Content.letter, "Letter",
				HO.IS_CONSUMED,
				PolyFactory.CreateRectangle (889, 475, 100, 30),
				onLetterTouched);
			
			batteries = CreateHotspot (Content.batteries, "Batteries",
				HO.IS_CONSUMED,
				PolyFactory.CreateRectangle (836, 480, 60, 37),
				onBatteriesTouched);
			
			tent.moveTo = new Point (229, 290);
		}
		
		public override function OnEnter() : void
		{
			switch (Main.lastScreen) {
				case null:
				case Main.tent:
					Main.player.clip.x = 257;
					Main.player.clip.y = 302;
			}
		}
		
		private var art:ApplicationDomain;
		private var fire:Hotspot;
		private var batteries:Hotspot;
		private var letter:Hotspot;
		private var tent:Hotspot;
		private var forest:Hotspot;
		private var backpack:Hotspot;
		
		private function onFireTouched (h:Hotspot) : void
		{
			Content.firelight.visible = false;
			Content.fire.visible = true;
			h.name = "Crackling fire";
		}
		
		private function onBatteriesTouched (h:Hotspot) : void
		{
			Main.player.addItem (new GameItem ("Batteries",
				"Your tongue hurts - they are supprisingly strong",
				art.getDefinition ("batteryIcon") as Class));
		}
		
		private function onLetterTouched (h:Hotspot) : void
		{
		}
		
		private function onTentTouched (h:Hotspot) : void
		{
			Main.inst.GotoScreen (Main.tent);
		}
		
		private function onForestTouched (h:Hotspot) : void
		{
			Main.inst.GotoScreen (Main.forest);
		}
		
		private function onBackpackTouched (h:Hotspot) : void
		{
			batteries.enable();
			letter.enable();
		}
	}
}