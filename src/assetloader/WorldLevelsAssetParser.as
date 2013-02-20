package assetloader
{
	import core.Level;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import gamedata.LevelData;
	
	import helpers.AS3Helper;
	
	public class WorldLevelsAssetParser extends EventDispatcher implements IAssetParser
	{
		public function Load (name:String, path:String) : void
		{
			var libraryLoader:URLLoader = new URLLoader();
			libraryLoader.dataFormat = URLLoaderDataFormat.TEXT;
			libraryLoader.addEventListener (Event.COMPLETE, onTextLoaded);
			libraryLoader.load (new URLRequest (path));
			
			this.path = path;
			this.name = name;
		}
		
		private var bytesTotal:int = -1;
		private var bytesLoaded:int = -1;
		private var name:String;
		private var path:String;
		
		private function onTextLoaded (e:Event) : void
		{
			trace ("Text loaded: " + path);
			var levelDatas:Object = JSON.parse (String (e.target.data));
			var levels:Array = AS3Helper.Select (levelDatas, LevelData.ToLevel);
			
			var asset:Asset = new Asset (name, path, levels, Asset.WORLD_LEVELS);
			dispatchEvent (new AssetParserEvent (AssetParserEvent.COMPLETED, 1, asset));
		}
	}
}