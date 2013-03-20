package levels
{
	import caurina.transitions.Tweener;
	import flash.display.MovieClip;
	import flash.display.Scene;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import geom.*;
	import helpers.*;
	
	public class ForestLevel extends Level
	{		
		public function ForestLevel (art:ApplicationDomain)
		{
			var p1:* = new Polygon([
				new Point (111, 233),
				new Point (339, 304),
				new Point (316, 367),
				new Point (71, 259)]);
			
			var p2:* = new Polygon([
				new Point (316, 367),
				new Point (240, 449),
				new Point (160, 414),
				new Point (242, 336)]);
			
			var p3:* = new Polygon([
				new Point (293, 390),
				new Point (241, 446),
				new Point (492, 555),
				new Point (515, 490)]);
			
			var p4:* = new Polygon([
				new Point (515, 490),
				new Point (770, 488),
				new Point (715, 558),
				new Point (492, 555)]);
			
			var p5:* = new Polygon ([
				new Point (714, 560),
				new Point (770, 488),
				new Point (929, 542),
				new Point (866, 653)]);
			
			var p6:* = new Polygon ([
				new Point (928, 541),
				new Point  (2032, 502),
				new Point  (2026, 702),
				new Point  (866, 653)]);
			
			var p1n:* = new PolyNode (p1);
			var p2n:* = new PolyNode (p2);
			var p3n:* = new PolyNode (p3);
			var p4n:* = new PolyNode (p4);
			var p5n:* = new PolyNode (p5);
			var p6n:* = new PolyNode (p6);
			
			PolyLink.AttachLinks (277, 350, p1n, p2n);
			PolyLink.AttachLinks (268, 414, p2n, p3n);
			PolyLink.AttachLinks (505, 521, p3n, p4n);
			PolyLink.AttachLinks (744, 514, p4n, p5n);
			PolyLink.AttachLinks (891, 581, p5n, p6n);
			
			NavMesh = new <PolyNode> [
				p1n,
				p2n,
				p3n,
				p4n,
				p5n,
				p6n
			];
			
			Content = MCHelper.FromAppDomain (art, "ForestScene");
			
			this.art = art;
			LayerHolder = Content.holder;
			LayerHolder.visible = false;
			
			exit = CreateHotspot (null, "Camp Entrance",
				HO.IS_ACTIVE,
				new Polygon ([
					new Point (4, 271),
					new Point (3, 4),
					new Point (330, 114),
					new Point (205, 258)]),
				onExitTouched);
			
			bushes = CreateHotspot (null, "Thorny Bushes",
				HO.IS_ACTIVE,
				new Polygon([
					new Point (1200, 615),
					new Point (1403, 336),
					new Point (1926, 388),
					new Point (1919, 646)]),
				onBushesTouched);
			
			shoe = CreateHotspot (Content.shoe, "Sarah's Shoe",
				HO.IS_ACTIVE | HO.IS_CONSUMED,
				PolyFactory.CreateCircle (353, 505, 35),
				onShoeTouched);
			
			branch = CreateHotspot (Content.branch, "Bloody Branch",
				HO.IS_ACTIVE | HO.IS_CONSUMED,
				PolyFactory.CreateCircle (834, 448, 60),
				onBranchTouched);
			
			owl = CreateHotspot (null, "Mr Hoot",
				HO.IS_ACTIVE,
				PolyFactory.CreateCircle (1104, 118, 60),
				onOwlTouched);
			
			shoe.moveTo = new Point (360, 490);
			branch.moveTo = new Point (800, 522);
			exit.moveTo = new Point (150, 274);
			owl.moveTo = new Point (-1, -1);
			shoe.activateAnim = "pickup";
		}
		
		public override function OnEnter() : void
		{
			switch (Main.lastScreen) {
				case null:
				case Main.camp:
					Main.player.clip.x = 150;
					Main.player.clip.y = 274;
					break;
				default:
					throw new Error ("Invalid entrance");
			}
			playIntro();
		}
		
		private var art:ApplicationDomain;
		private var branch:Hotspot;
		private var owl:Hotspot;
		private var shoe:Hotspot;
		private var bushes:Hotspot;
		private var body:Hotspot;
		private var exit:Hotspot;
		private var playedIntro:Boolean;
		
		private function onShoeTouched() : void
		{
			Main.player.addItem (new GameItem ("Sarah's Shoe",
				"This shoe belongs to Sarah's right foot",
				art.getDefinition ("shoeIcon") as Class));
		}
		
		private function onBranchTouched() : void
		{
			Main.dialog.play ("bloodybranch");
			Main.player.addItem (new GameItem ("Bloody Branch",
				"A snapped branch covered in blood",
				art.getDefinition ("branchIcon") as Class));
		}
		
		private function onExitTouched (h:Hotspot) : void
		{
			Main.inst.GotoScreen (Main.camp);
		}
		
		private function onBushesTouched (h:Hotspot, item:GameItem) : void
		{
			if (item == null || item.name != "Machete")
				return;
			
			h.disable();
			Content.bushes.visible = false;
			//TODO: add end of game
		}
		
		private function playIntro() : void
		{
			if (Main.player.hasItem ("Machete")) {
				Main.soundManager.PlayBackgroundMusic ("fast");
			}
			if (playedIntro) {
				return;
			}
			Main.dialog.play ("enterwoods");
			Main.soundManager.PlayBackgroundMusic ("medium");
			playedIntro = true;
		}
		
		private function onOwlTouched (ho:Hotspot, item:GameItem) : void
		{
			if (!item || item.name != "Empty Wine Bottles")
				return;
			
			Main.player.removeItem (item);
			var bottle:MovieClip = MCHelper.FromAppDomain (art, "bottle");
			bottle.x = Main.player.clip.x;
			bottle.y = Main.player.clip.y - (Main.player.clip.height/2);
			Content.addChild (bottle);
			Tweener.addTween (bottle, {
				x: 1105,
				y: 108,
				rotation: 720,
				time: 0.8,
				transition: "LINEAR",
				onComplete: function():void {
					ho.disable();
					Content.owl.visible = false;
					Content.removeChild (bottle);
					bottle.visible = false;	
				}
			});
		}
	}
}