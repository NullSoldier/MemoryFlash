package
{
	import helpers.Check;

	public class RecipeBox
	{
		public static function tryMix (item1:GameItem, item2:GameItem) : Boolean
		{
			for each (var r:Object in recipes) {
				var isA:Boolean = r.item1 == item1.name && r.item2 == item2.name;
				var isB:Boolean = r.item1 == item2.name && r.item2 == item1.name;
				
				if (isA || isB) {
					r.onMix (item1, item2);
					return true;
				}
			}
			return false;
		}
		
		// onMix onMix (item1:GameItem, item2:GameItem) : void
		public static function addRecipe (item1Name:String,
			item2Name:String, onMix:Function) : void
		{
			Check.IsEmptyOrNull (item1Name);
			Check.IsEmptyOrNull (item2Name);
			Check.ArgNull (onMix, "onMix");
			
			recipes.push ({
				'item1': item1Name,
				'item2': item2Name,
				'onMix': onMix
			});
		}
		
		private static const recipes:Array = [];
	}
}