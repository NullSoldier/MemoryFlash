package levels
{
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import geom.*;
	import helpers.*;
	
	public class TentLevel extends Level
	{		
		public function TentLevel (art:ApplicationDomain)
		{
			this.art = art;
			
			//new Point (966, 470)
			//new Point (177, 468)
			
			var p:* = new Polygon ([
				new Point (177, 468),
				new Point (412, 466),
				new Point (707, 465),
				new Point (962, 482),
				new Point (896, 594),
				new Point (796, 644),
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
				HO.IS_ACTIVE | HO.WILL_DISABLE,
				new Polygon ([
					new Point (757, 443),
					new Point (883, 417),
					new Point (902, 489),
					new Point (776, 507),
					new Point (745, 483)]),
				onBagTouched);
			
			lantern = CreateHotspot (Content.lantern,
				"Turn lantern ON",
				HO.IS_ACTIVE,
				PolyFactory.CreateCircle (530, 315, 64),
				onLanternTouched);
				
			CreateHotspot (Content.blanket,
				"Blanket",
				HO.IS_ACTIVE | HO.WILL_DISABLE,
				new Polygon ([
					new Point (0+150, 41+506),
					new Point (256+150, -6+506),
					new Point (419+150, 91+506),
					new Point (296 + 150, 153 + 506)]),
				onBlanketTouched);
			
			exit = CreateHotspot (null, "Tent Exit",
				HO.IS_ACTIVE,
				new Polygon ([
					new Point (620 + 90, 250),
					new Point (607 + 90, 373),
					new Point (575 + 90, 459),
					new Point (650 + 90, 468),
					new Point (675 + 90, 374),
					new Point (657 + 90, 299)]),
				onExitTouched);
				
			sweater = CreateHotspot (Content.sweater, "Sarah's Sweater",
				HO.IS_ACTIVE | HO.IS_CONSUMED,
				new Polygon ([
					new Point (426-100, 563),
					new Point (513-100, 551),
					new Point (603-100, 559),
					new Point (619-100, 594),
					new Point (566-100, 645),
					new Point (496-100, 633)]),
				onSweaterTouched);
				
			flashlight = CreateHotspot (Content.flashlight, "Flashlight",
				HO.IS_ACTIVE | HO.IS_CONSUMED,
				new Polygon ([
					new Point (568 - 300, 493 - 0),
					new Point (575 - 300, 427 - 0),
					new Point (630 - 300, 433 - 0),
					new Point (634 - 300, 484 - 0)]),
				onFlashlightTouched);
				
			matches = CreateHotspot (Content.matches, "Matches",
				HO.IS_CONSUMED,
				new Polygon ([
					new Point (830 - 0, 505 - 0),
					new Point (892 - 0, 491 - 0),
					new Point (905 - 0, 516 - 0),
					new Point (844 - 0, 532 - 0)]),
				onMatchesTouched);
				
			lantern.moveTo = new Point (524, 513);
			bag.moveTo = new Point (776, 512);
			exit.moveTo = new Point (702, 469);
			
			bag.activateAnim = "kick";
			matches.activateAnim = "pickup";
			sweater.activateAnim = "pickup";
			flashlight.activateAnim = "pickup";
			
			RecipeBox.addRecipe ("Flashlight", "Batteries",
				function(i1:GameItem, i2:GameItem):void {
					Main.player.removeItem (i1);
					Main.player.removeItem (i2);
					Main.player.addItem (new GameItem ("Powered Flashlight",
						"A flashlight, it's batteries are fully charged",
						art.getDefinition ("flashlightOnIcon") as Class));
				});
		}
		
		public override function OnEnter() : void
		{
			switch (Main.lastScreen) {
				case null:
					Main.player.clip.visible = false;
				case Main.camp:
					Main.player.clip.x = 690;
					Main.player.clip.y = 485;
					break;
				default:
					throw new Error ("Invalid entrance");
			}
		}

		private var art:ApplicationDomain;
		private var lantern:Hotspot;
		private var bag:Hotspot;
		private var flashlight:Hotspot;
		private var exit:Hotspot;
		private var sweater:Hotspot;
		private var matches:Hotspot;
		private var playedIntro:Boolean;
		
		private function onLanternTouched (h:Hotspot) : void
		{
			playIntro();
			Main.soundManager.PlaySoundEffect ("lantern", "sfx");
			Content.light1.visible = !Content.light1.visible;
			h.name = "Turn lantern " + (Content.light1.visible ? "ON" : "OFF");
			Main.inst.invalidateHint();
		}
		
		private function onBlanketTouched() : void
		{
			Main.soundManager.PlaySoundEffect ("blanket", "sfx");
			Content.blanket.gotoAndStop (2);
			sweater.enable();
		}
		
		private function onSweaterTouched() : void
		{
			Main.soundManager.PlaySoundEffect ("sweater", "sfx");
			Main.player.addItem (new GameItem ("Sarah's Sweater",
				"Sarah's favorite sweater",
				art.getDefinition ("sweaterIcon") as Class));
		}
		
		private function onBagTouched() : void
		{
			matches.enable();
		}
		
		private function onFlashlightTouched() : void
		{
			Main.dialog.play ("flashlight");
			Main.player.addItem (new GameItem ("Flashlight",
				"A dead flashlight, it's missing batteries",
				art.getDefinition ("flashlightOffIcon") as Class));
		}
		
		private function onMatchesTouched() : void
		{
			Main.dialog.play ("matches");
			Main.player.addItem (new GameItem ("Matches",
				"A set of easy-strike matches",
				art.getDefinition ("matchesIcon") as Class));
		}
		
		private function onExitTouched() : void
		{
			if (Main.player.hasItem ("Sarah's Sweater")) {
				Main.soundManager.PlaySoundEffect ("zipper", "sfx");
				Main.inst.GotoScreen (Main.camp);
			} else {
				Main.dialog.play ("coldanddark");
			}
		}
		
		private function playIntro() : void
		{
			if (playedIntro)
				return;
			
			Main.dialog.play ("intro");
			Main.soundManager.PlayBackgroundMusic ("slow");
			Main.player.clip.visible = true;
			Main.player.waitForAnim ("wakeup", function():void {
				Main.player.playAnim ("idle");
				playedIntro = true;
			});
		}
	}
}