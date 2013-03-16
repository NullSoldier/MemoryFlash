package
{
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	
	import helpers.Check;
	import helpers.MCHelper;

	public class FlashlightControl extends Sprite
	{
		public function FlashlightControl (stage:Stage, player:Player,
			art:ApplicationDomain)
		{
			Check.ArgNull (stage, "stage");
			Check.ArgNull (player, "player");
			Check.ArgNull (art, "art");
			
			this.player = player;
			this.light = MCHelper.FromAppDomain (art, "flashlight");
			this.c1 = initRect();
			this.c2 = initRect();
			this.c3 = initRect();
			this.c4 = initRect();

			addChild (light);
			stage.addEventListener (MouseEvent.MOUSE_DOWN, onTouch);
			stage.addEventListener (MouseEvent.MOUSE_MOVE, onTouch);
			stage.addEventListener (TouchEvent.TOUCH_BEGIN, onTouch);
			stage.addEventListener (TouchEvent.TOUCH_MOVE, onTouch);
		}
		
		public function enable (enable:Boolean) : void
		{
			light.visible = enable;
			c1.visible = enable;
			c2.visible = enable;
			c3.visible = enable;
			c4.visible = enable;
			
			snapToPlayer();
		}
		
		private var player:Player;
		private var light:MovieClip;
		private var c1:Sprite;
		private var c2:Sprite;
		private var c3:Sprite;
		private var c4:Sprite;
		
		private function initRect() : Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill (0)
			s.graphics.drawRect (0, 0, 1, 1);
			s.graphics.endFill();
			addChild (s);
			return s;
		}
		
		private function invalidate (lightPos:Point) : void
		{
			light.x = lightPos.x - (light.width/2);
			light.y = lightPos.y - (light.height/2);
			
			var b:Rectangle = light.getBounds (light.parent);
			var fix:int = 1;
			
			MCHelper.SetBounds (c1, 0, 0, stage.stageWidth, light.y+fix);
			MCHelper.SetBounds (c2, 0, light.y, light.x+fix, stage.stageHeight-light.y+fix);
			MCHelper.SetBounds (c3, b.right-fix, light.y, stage.stageWidth - b.right+fix, stage.stageHeight-light.y);
			MCHelper.SetBounds (c4, light.x, b.bottom-fix, light.width, stage.stageHeight - b.bottom+fix);
		}
		
		private function onTouch (e:*) : void
		{
			invalidate (new Point (e.stageX, e.stageY));
		}
		
		private function snapToPlayer () : void
		{
			var local:Rectangle = player.clip.getBounds (stage);
			invalidate (new Point (local.x, local.y))
		}
	}
}