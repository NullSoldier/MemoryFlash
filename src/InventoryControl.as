package
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	import geom.PolyNode;
	
	import helpers.*;
	
	public class InventoryControl
	{
		public function InventoryControl (clip:MovieClip, p:Player, art:ApplicationDomain) : void
		{
			Check.ArgNull (clip, "clip");
			Check.ArgNull (p, "p");
			Check.ArgNull (art, "art");
			
			this.clip = clip;
			this.player = p;
			this.slots = new Dictionary();
			this.slotSpots = new Vector.<PolyNode>();
			this.art = art;
			
			p.itemAdded = itemAdded;
			clip.addEventListener (Event.ENTER_FRAME, onEnterFrame);
			slotWidth = MCHelper.FromAppDomain (art, "itemSlot").width;
		}
		
		public var slotSpots:Vector.<PolyNode>;
		public var clip:MovieClip;
		
		public function getItemAt (stageLoc:Point) : GameItem
		{
			var local:Point = clip.globalToLocal (stageLoc);
			for each (var s:Object in slots) {
				if (PolyCheck.PointInPoly (local, s.poly))
					return s.item;
			}
			return null;
		}
		
		private var art:ApplicationDomain;
		private var player:Player;
		private var slots:Dictionary;
		private var nextSlotIndex:int;
		private var mousedOver:GameItem;
		private var slotWidth:int;
		private var draggedClip:MovieClip;
		
		private function itemAdded (item:GameItem) : void
		{
			var slot:Object = findOrCreateSlot();
			slot.item = item;
			slot.clip = item.SpawnInventory();
			slot.container.tag = slot;
			slot.container.addChild (slot.clip);
		}
		
		private function findOrCreateSlot() : Object
		{
			for (var i:* in slots) {
				if (slots[i] != null && slots[i].item == null)
					return slots[i];
			}
			var slot:Object = createAddSlot (nextSlotIndex);
			return slots[nextSlotIndex++] = slot;
		}
		
		private function createAddSlot (index:int)
		{
			var slot:Object = {
				"index": index,
				"item": null,
				"clip": null,
				"container": MCHelper.FromAppDomain (art, "itemSlot")
			}
			slot.container.x = index * slotWidth;
			slot.poly = PolyFactory.CreateRectangle (
				slot.container.x,
				slot.container.y,
				slot.container.width,
				slot.container.height);
			
			drawSlot (slot);
			clip.addChild (slot.container);
		}

		private function drawSlot (slot:Object) : void
		{
			var s:Sprite = new Sprite();
			ScreenDebugger.DrawPolygon (s.graphics, slot.poly, 0x52D017);
			clip.addChild (s);
		}
		
		private function onStartDrag (e:*) : void
		{
			var slot:Object = e.currentTarget.tag;
			draggedClip = slot.item.SpawnInventory();
		}
		
		private function onDragMove (e:*) : void
		{
			draggedClip.x = e.localX;
			draggedClip.y = e.localY;
		}
		
		private function onEndDrag (e:*) : void
		{
			
		}
	}
}