package screens
{
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.system.ApplicationDomain;
	import helpers.*;
	import geom.*;
	import flash.geom.Point;
	
	public class TentScene extends Screen
	{		
		public function TentScene (art:ApplicationDomain)
		{
			var p:* = new Polygon ([
				new Point (106, 469),
				new Point (152, 442),
				new Point (420, 433),
				new Point (777, 429),
				new Point (1000, 443),
				new Point (997, 480),
				new Point (896, 594),
				new Point (627, 646),
				new Point (345, 644),
				new Point (159, 605)]);

			var pnode:* = new PolyNode (p);
			NavMesh = new <PolyNode> [pnode];
			
			Content = MCHelper.FromAppDomain (art, "TentScene");
			Content.lantern.gotoAndStop(1);
			Content.blanket.gotoAndStop(1);
			Content.light1.visible = true;
			Content.matches.visible = false;
			
			LayerHolder = Content.holder;
			LayerHolder.visible = false;
			
			bag = CreateHotspot (null,
				"Duffle Bag",
				true, true,
				new Polygon ([
				new Point (757, 443),
				new Point (883, 417),
				new Point (902, 489),
				new Point (776, 507),
				new Point (745, 483)]),
				onBagTouched);
			
			lantern = CreateHotspot (Content.lantern,
				"Lantern OFF",
				true, true,
				PolyFactory.CreateCircle (530, 315, 64),
				onLanternTouched);
				
			CreateHotspot (Content.blanket,
				"Blanket",
				true, true,
				new Polygon ([
				new Point (0+150, 41+506),
				new Point (256+150, -6+506),
				new Point (419+150, 91+506),
				new Point (296 + 150, 153 + 506)]),
				onBlanketTouched);
			
			exit = CreateHotspot (null, "Tent Exit",
				true, true,
				new Polygon ([
				new Point (620 + 90, 250),
				new Point (607 + 90, 373),
				new Point (575 + 90, 459),
				new Point (650 + 90, 468),
				new Point (675 + 90, 374),
				new Point (657 + 90, 299)]),
				onExitTouched);
				
			sweater = CreateHotspot (null, "Sarah's Sweater",
				false, false,
				new Polygon ([
				new Point (426-100, 563),
				new Point (513-100, 551),
				new Point (603-100, 559),
				new Point (619-100, 594),
				new Point (566-100, 645),
				new Point (496-100, 633)]),
				onSweaterTouched);
				
			CreateHotspot (Content.flashlight, "Flashlight",
				true, true,
				new Polygon ([
				new Point (568 - 300, 493 - 0),
				new Point (575 - 300, 427 - 0),
				new Point (630 - 300, 433 - 0),
				new Point (634 - 300, 484 - 0)]),
				onFlashlightTouched);
				
			CreateHotspot (Content.matches, "Matches",
				true, true,
				new Polygon ([
				new Point (830 - 0, 505 - 0),
				new Point (892 - 0, 491 - 0),
				new Point (905 - 0, 516 - 0),
				new Point (844 - 0, 532 - 0)]),
				onMatchesTouched);
				
			lantern.moveTo = new Point (524, 513);
			bag.moveTo = new Point (776, 512);
			exit.moveTo = new Point (702, 469);
		}
		
		public override function OnEnter() : void
		{
			switch (Main.lastScreen)
			{
				case null:
					Main.player.clip.x = 440;
					Main.player.clip.y = 495;
			}
		}
		
		private var lantern:Hotspot;
		private var bag:Hotspot;
		private var exit:Hotspot;
		private var sweater:Hotspot;
		
		private function onBlanketTouched (h:Hotspot) : void
		{
			//Main.soundManager.PlaySoundEffect ("blanket");
			Content.blanket.gotoAndStop (2);
			h.isActive = false;
			h.canMouseOver = false;
			sweater.isActive = true;
			sweater.canMouseOver = true;
		}
		
		private function onLanternTouched (h:Hotspot) : void
		{
			//Main.soundManager.PlaySoundEffect ("lantern");
			Content.light1.visible = !Content.light1.visible;
			h.name = "Lantern " + (Content.light1.visible ? "ON" : "OFF");
		}
		
		private function onBagTouched (h:Hotspot) : void
		{
			Content.matches.visible = true;
			h.isActive = false;
			h.canMouseOver = false;
		}
		
		private function onSweaterTouched (h:Hotspot) : void
		{
			//Main.soundManager.PlaySoundEffect ("sweater");
			Content.sweater.visible = false;
			h.isActive = false;
			h.canMouseOver = false;
		}
		
		private function onFlashlightTouched (h:Hotspot) : void
		{
			Content.flashlight.visible = false;
			h.isActive = false;
			h.canMouseOver = false;
		}
		
		private function onMatchesTouched (h:Hotspot) : void
		{
			Content.matches.visible = false;
			h.isActive = false;
			h.canMouseOver = false;
		}
		
		private function onExitTouched (h:Hotspot) : void
		{
			//Main.soundManager.PlaySoundEffect ("zipper");
		}
	}
}