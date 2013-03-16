package levels
{
	import caurina.transitions.Tweener;
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
				HO.IS_ACTIVE,
				new Polygon ([
					new Point (3, 277),
					new Point (333, 247),
					new Point (83, 107),
					new Point (2, 107)]),
				onTentTouched);
				
			forest = CreateHotspot (null, "Dark Forest Entrance",
				HO.IS_ACTIVE,
				new Polygon([
					new Point (1087, 281),
					new Point (1075, 110),
					new Point (1277, 114),
					new Point (1268, 301)]),
				onForestTouched);
			
			fire = CreateHotspot (null, "Unlit fire",
				HO.IS_ACTIVE,
				new Polygon([
					new Point (50, 465),
					new Point (184, 412),
					new Point (307, 458),
					new Point (290, 503),
					new Point (194, 526),
					new Point (97, 518)]),
				onFireTouched);
			
			backpack = CreateHotspot (Content.backpack, "Backpack",
				HO.IS_ACTIVE | HO.WILL_DISABLE,
				PolyFactory.CreateRectangle (798, 410, 120, 60),
				onBackpackTouched);
			
			letter = CreateHotspot (Content.letter, "Love Letter",
				HO.IS_CONSUMED,
				PolyFactory.CreateRectangle (889, 475, 100, 30),
				onLetterTouched);
			
			batteries = CreateHotspot (Content.batteries, "Batteries",
				HO.IS_CONSUMED,
				PolyFactory.CreateRectangle (836, 480, 60, 37),
				onBatteriesTouched);
			
			machete = CreateHotspot (Content.machete, "Machete",
				HO.IS_CONSUMED,
				PolyFactory.CreateRectangle (560, 420, 150, 60),
				onMacheteTouched);
				
			boulder = CreateHotspot (null, "Pry Boulder Up",
				HO.IS_ACTIVE,
				new Polygon ([
					new Point (485, 388),
					new Point (555, 314),
					new Point (626, 315),
					new Point (676, 384),
					new Point (673, 431),
					new Point (589, 474),
					new Point (484, 441)]),
				onBoulderTouched);
			
			fire.moveTo = new Point (311, 415);
			tent.moveTo = new Point (229, 290);
			boulder.moveTo = new Point (665, 456);
			forest.moveTo = new Point (1169, 330);
		}
		
		public override function OnEnter() : void
		{
			switch (Main.lastScreen) {
				case null:
				case Main.tent:
					Main.player.clip.x = 257;
					Main.player.clip.y = 302;
					break;
				case Main.forest:
					Main.player.clip.x = 1180;
					Main.player.clip.y = 334;
					break;
				default:
					throw new Error ("Invalid entrance");
			}
			playIntro();
		}
		
		private var art:ApplicationDomain;
		private var fire:Hotspot;
		private var batteries:Hotspot;
		private var letter:Hotspot;
		private var tent:Hotspot;
		private var forest:Hotspot;
		private var backpack:Hotspot;
		private var boulder:Hotspot;
		private var machete:Hotspot;
		private var playedIntro:Boolean;
		
		private function onFireTouched (h:Hotspot, item:GameItem) : void
		{
			if (!item || item.name != "Matches")
				return;
			
			Content.firelight.visible = false;
			Content.fire.visible = true;
			h.name = "Crackling fire";
			Main.player.removeItem (item);
			Main.soundManager.PlaySoundEffect ("match", "sfx");
		}
		
		private function onBoulderTouched (h:Hotspot, item:GameItem) : void
		{
			if (!item || item.name != "Bloody Branch") {
				Main.soundManager.PlaySoundEffect ("rock", "vo");
				return;
			}
			
			Tweener.addTween (Content.boulder, {
				x: Content.boulder.x - 50,
				time: 0.15,
				onComplete: function():void {
					h.disable();
					machete.enable();
					Main.player.removeItem (item);
				}
			});
		}
		
		private function onBatteriesTouched() : void
		{
			Main.soundManager.PlaySoundEffect ("batteries", "vo");
			Main.player.addItem (new GameItem ("Batteries",
				"Your tongue hurts - they are supprisingly strong",
				art.getDefinition ("batteryIcon") as Class));
		}
		
		private function onLetterTouched() : void
		{
			Main.soundManager.PlaySoundEffect ("paper", "sfx");
			Main.soundManager.PlaySoundEffect ("letter", "vo");
			Main.player.addItem (new GameItem ("Love Letter",
				"A love letter form Sarah's old boyfriend.",
				art.getDefinition ("letterIcon") as Class));
		}
		
		private function onTentTouched() : void
		{
			Main.soundManager.PlaySoundEffect ("blanket", "sfx");
			Main.inst.GotoScreen (Main.tent);
		}
		
		private function onForestTouched() : void
		{
			if (Main.player.hasItem ("Powered Flashlight")) {
				Main.inst.GotoScreen (Main.forest);
			} else {
				Main.soundManager.PlaySoundEffect ("toodark", "vo");
			}
		}
		
		private function onBackpackTouched() : void
		{
			batteries.enable();
			letter.enable();
		}
		
		private function onMacheteTouched() : void
		{
			Main.player.addItem (new GameItem ("Machete",
				"A sharp blade used for cutting shrubbery and thickets down",
				art.getDefinition ("macheteIcon") as Class));
		}
		
		private function playIntro() : void
		{
			if (playedIntro)
				return;
			Main.soundManager.PlaySoundEffect ("nothere", "vo");
			playedIntro = true;
		}
	}
}