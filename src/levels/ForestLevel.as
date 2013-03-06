package levels
{
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.system.ApplicationDomain;
	import helpers.*;
	import geom.*;
	import flash.geom.Point;
	
	public class ForestLevel extends Level
	{		
		public function ForestLevel (art:ApplicationDomain)
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
			
			
			LayerHolder = Content.holder;
			LayerHolder.visible = false;
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
			Main.inst.GotoScreen (Main.camp);
			//Main.soundManager.PlaySoundEffect ("zipper");
		}
	}
}