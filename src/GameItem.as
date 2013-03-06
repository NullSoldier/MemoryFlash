package  
{
	import flash.display.MovieClip;

	public class GameItem 
	{
		public function GameItem (name:String, desc:String, inventoryClass:Class)
		{
			this.name = name;
			this.desc = desc;
			this.inventoryClass = inventoryClass;
		}
		
		public var name:String;
		public var desc:String;
		
		public function SpawnInventory() : MovieClip
		{
			if (inventoryClass == null){
				throw new Error ("No inventory class to instantiate");
			}
			return new inventoryClass as MovieClip;
		}
		
		private var inventoryClass:Class;
	}
}