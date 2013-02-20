package assetloader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.system.ApplicationDomain;

	public class Asset
	{
		public function Asset (name:String, path:String, asset:Object, assetType:String)
		{
			if (assetType == GRAPHICS && !(asset is ApplicationDomain))
				throw Error ("Asset is not actually graphics");
			else if (assetType == SOUND && !(asset is Sound))
				throw Error ("Asset is not actually sound");
			
			this.Name = name;
			this.Path = path;
			this.Value = asset;
			this.AssetType = assetType;
		}
		
		public var Name:String;
		public var Path:String;
		public var Value:Object;
		public var AssetType:String;
		
		public static const SOUND:String = "sound";
		public static const GRAPHICS:String = "graphics";
		public static const TEXT:String = "text";
		public static const WORLD_LEVELS:String = "worldLevels";
		public static const DELAYED:String = "delayed";
	}
}