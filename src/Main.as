package 
{
	import assetloader.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.*;
	import flash.system.*;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import geom.Polygon;
	
	import helpers.*;
	
	import levels.*;
	
	[SWF(width = "960", height = "640")]
	public class Main extends Sprite
	{
		public static var tent:TentLevel;
		public static var camp:CampLevel;
		public static var forest:ForestLevel;
		
		public static var inst:Main;
		public static var player:Player;
		public static var current:Level;
		public static var lastScreen:Level;
		public static var soundManager:SoundManager;
		
		public function Main():void
		{
			inst = this;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 60;
			stage.color = 0x000000;
			
			var assets:Object = {
				"art": { URI: "content.swf", AssetType: Asset.GRAPHICS }
			};
			
			var loader:AssetLoader = new AssetLoader();
			loader.addEventListener (AssetLoaderEvent.COMPLETED, onAssetsLoaded);
			loader.Start (assets);
		}
		
		private function onAssetsLoaded (e:AssetLoaderEvent) : void
		{
			trace ("All assets loaded!");
			var art:ApplicationDomain = e.AssetLoaded["art"].Value;
			addChild (container);
			
			player = new Player (art);
			tent = new TentLevel (art);
			camp = new CampLevel (art);
			//forest = new ForestLevel (art);
			GotoScreen (tent);
			ScreenDebugger.DrawDebug (tent);
			//ScreenDebugger.DrawDebug (camp);
			//ScreenDebugger.DrawDebug (forest);
			
			var ui:MovieClip = MCHelper.FromAppDomain (art, "interface");
			stage.addChild (ui);
			inventory = new InventoryControl (ui, player, art);
			inventory.itemDraggedTo = itemDraggedTo;
			
			addChild (inputHint = ui.mouseHint);
			inputHint.visible = false;
			
			addEventListener (Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener (MouseEvent.CLICK, onInputTouch);
			stage.addEventListener (MouseEvent.MOUSE_MOVE, onInputMove);
			stage.addEventListener (TouchEvent.TOUCH_MOVE, onInputMove);
			stage.addEventListener (TouchEvent.TOUCH_END, function(e:*):void {
				onInputMove (e);
				onInputTouch (e);
			});
			stage.addEventListener (Event.RESIZE, onResize);
			
			onResize (null);
		}
		
		public function GotoScreen (level:Level) : void
		{
			Check.ArgNull (level, "level");
			trace ("Going to screen: " + flash.utils.getQualifiedClassName(level));
			
			if (current != null) {
				container.removeChild (current.Content);
			}
			current = level;
			container.addChild (current.Content);
			var index:int = current.Content.getChildIndex (current.LayerHolder);
			current.Content.addChildAt (player.clip, index);
			current.OnEnter();
			current = level;
		}
		
		private var ui:MovieClip;
		private var container:Sprite = new Sprite();
		private var inputTarget:*;
		private var inputHint:TextField;
		private var inventory:InventoryControl;
		
		private function onResize (e:Event) : void
		{
			trace ("Resizing to " + this.stage.stageWidth + "x" + this.stage.stageHeight);
			this.scaleX = this.scaleY = this.stage.stageWidth / 1280;
			this.y = (stage.stageHeight / 2) - (this.height / 2);
			
			inputHint.x = 10;
			inputHint.y = 720 - inputHint.height - 20;
		}
		
		private function onEnterFrame (e:Event) : void
		{
			if (current == null) return;
			player.update();
		}
		
		private function onInputTouch (e:*) : void
		{
			var srcPoly:Polygon = PolyCheck.PointInLevelPoly (player.pos, current);
			var stageLoc:Point = new Point (e.stageX, e.stageY);
			var local:Point = current.Content.globalToLocal (stageLoc);
			resolveInputTarget (stageLoc);
			
			if (inputTarget is GameItem) {
				trace ("Clicked on " + GameItem (inputTarget).name);
			} else if (inputTarget is Hotspot) {
				var to:Point = inputTarget.moveTo ? inputTarget.moveTo : local;
				player.moveTo (to, inputTarget);
			} else if (inputTarget is Polygon) {
				player.moveTo (local, null);
			}
		}
		
		private function onInputMove (e:*) : void
		{
			resolveInputTarget (new Point (e.stageX, e.stageY));	
		}
		
		private function resolveInputTarget (stageLoc:Point) : void
		{
			var target:* = InputHelper.getTargetAtInput (
				stageLoc, inventory, current);
			
			if (target is GameItem) {
				inputHint.text = target.name;
				inputHint.visible = true;
				inputTarget = target;
			} else if (target is Hotspot) {
				inputHint.text = target.name;
				inputHint.visible = true;
				inputTarget = target;
			} else if (target is Polygon) {
				inputTarget = target;
				inputHint.visible = false;
			} else { // Was dragged to nothing
				inputTarget = null;
				inputHint.visible = false;
			}
		}
		
		private function itemDraggedTo (item:GameItem, stageLoc:Point) : void
		{
			var local:Point = current.Content.globalToLocal (stageLoc);

			resolveInputTarget (stageLoc);
			if (inputTarget is GameItem) {
				RecipeBox.tryMix (item, inputTarget);
			} else if (inputTarget is Hotspot) {
				var to:Point = inputTarget.moveTo ? inputTarget.moveTo : local;
				player.moveTo (to, inputTarget, item);
			}
		}
	}
}