package 
{
	import assetloader.Asset;
	import assetloader.AssetLoader;
	import assetloader.AssetLoaderEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.*;
	import flash.system.*;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import geom.Polygon;
	
	import helpers.*;
	
	import screens.Screen;
	import screens.TentScene;
	
	[SWF(width = "960", height = "640")]
	public class Main extends Sprite
	{
		public static var inst:Main;
		public static var player:Player;
		public static var tent:TentScene;
		public static var current:Screen;
		public static var lastScreen:Screen;
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
			tent = new TentScene (art);
			GotoScreen (tent);
			//ScreenDebugger.DrawDebug (tent);
			
			var ui:MovieClip = MCHelper.FromAppDomain (art, "interface");
			addChild (mouseHint = ui.mouseHint);
			mouseHint.visible = false;
			
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
		
		public function GotoScreen (s:Screen) : void
		{
			trace ("Going to screen: " + flash.utils.getQualifiedClassName(s));
			Check.ArgNull (s, "screen");
			
			if (current != null) {
				container.removeChild (current.Content);
			}
			current = s;
			container.addChild (s.Content);
			s.Content.addChildAt (player.clip, s.Content.getChildIndex (s.LayerHolder));
			s.OnEnter();
		}
		
		private var ui:MovieClip;
		private var container:Sprite = new Sprite();
		private var mousedHotspot:Hotspot;
		private var mouseHint:TextField;
		
		private function onResize (e:Event) : void
		{
			trace ("Resizing to " + this.stage.stageWidth + "x" + this.stage.stageHeight);
			this.scaleX = this.scaleY = this.stage.stageWidth / 1280;
			this.y = (stage.stageHeight / 2) - (this.height / 2);
			
			mouseHint.x = 10;
			mouseHint.y = 720 - mouseHint.height - 20;
		}
		
		private function onEnterFrame (e:Event) : void
		{
			if (current == null)
				return;
				
			player.update();
		}
		
		private function onInputTouch (e:*) : void
		{
			var stageLoc:Point = new Point (e.stageX, e.stageY);
			var local:Point = current.Content.globalToLocal (stageLoc);
			trace ("Clicked " + local.toString());
			
			var srcPoly:Polygon = current.FindPoly (player.pos);
			var clickedPoly:Polygon = current.FindPoly (local);
			
			// Clicked a hotspot?
			if (mousedHotspot && mousedHotspot.isActive) {
				var to:Point = mousedHotspot.moveTo ? mousedHotspot.moveTo : local;
				player.moveTo (to, mousedHotspot);
				return;
			}
			
			// Clicked the ground?
			if (clickedPoly != null) {
				player.moveTo (local, null);
			}
		}
		
		private function onInputMove (e:*) : void
		{
			var stageLoc:Point = new Point (e.stageX, e.stageY);
			var local:Point = current.Content.globalToLocal (stageLoc);
			
			for each (var h:Hotspot in current.Spots) {
				if (CollisionChecker.PointToPoly (local, h) && h.canMouseOver) {
					mousedHotspot = h;
					mouseHint.visible = true;
					mouseHint.text = h.name;
					return;
				}
			}
			mousedHotspot = null;
			mouseHint.visible = false;
		}
	}
}