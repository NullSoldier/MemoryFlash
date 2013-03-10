package helpers
{
	import flash.system.ApplicationDomain;
	import helpers.MCHelper;
	
	public class Check
	{
		public static function ArgNull (t:*, name:String = null) : void
		{
			if (t == null)
				throw new Error ("Check: Argument " + name + " cannot be null.");
		}
		
		public static function PropertyDefined (t:Object, name:String)  : void
		{
			if (t[name] == undefined)
				throw new Error ("Check: " + name + " property on " + t + " is undefined");
		}
		
		public static function IsEqual (item1:*, item2:*) : void
		{
			if (item1 == item2)
				throw new Error ("Check: Arguments cannot be equal");
		}
		
		public static function IsNotEqual (item1:*, item2:*) : void
		{
			if (item1 != item2)
				throw new Error ("Check: Arguments must be equal");
		}
		
		public static function HasDefinition (appDomain:ApplicationDomain, name:String) : void
		{
			if (!appDomain.hasDefinition (name))
				throw new Error ("Check: AppDomain does not have definition " + name);
		}
		
		public static function BetweenRange (value:int, min:int, max:int) : void
		{
			if (value < min || value > max)
				throw new Error ("Check: Value " + value + " must be less than " + min + " and greater than " + max);
		}
		
		public static function IsNullOrUndefined (value:*) : void
		{
			if (value == null)
				throw new Error ("Check: Value cannot be undefined");
		}
		
		public static function AllNull (... params:Array) : void
		{
			for (var i:int=0; i<params.length; i++) {
				if (params[i])
					return;
			}

			throw new Error ("Check: At least one item must not be null");
		}
		
		public static function IsEmptyOrNull (value:String) : void
		{
			if (value == null || value.length == 0 || AS3Helper.IsStringEmpty (value))
				throw new Error ("Check: String cannot be empty or null");
		}
		
		public static function HasItems (value:Array ) : void
		{
			if (value.length == 0)
				throw new Error ("Check: Array cannot be empty");
		}
	}
}