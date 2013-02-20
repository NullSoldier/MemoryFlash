package assetloader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	
	public class TextAssetParser extends EventDispatcher implements IAssetParser
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
			var asset:Asset = new Asset (name, path, e.target.data, Asset.TEXT);
			dispatchEvent (new AssetParserEvent (AssetParserEvent.COMPLETED, 0, asset));
		}
	}
}