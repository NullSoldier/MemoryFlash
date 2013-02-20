package assetloader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	public class GraphicsAssetParser extends EventDispatcher implements IAssetParser
	{
		public function Load (name:String, path:String) : void
		{
			var libraryLoader:Loader = new Loader();
			libraryLoader.contentLoaderInfo.addEventListener (Event.COMPLETE, onArtLoaded);
			libraryLoader.load (new URLRequest (path));
			
			this.path = path;
			this.name = name;
		}
		
		private var bytesTotal:int = -1;
		private var bytesLoaded:int = -1;
		private var name:String;
		private var path:String;
		
		private function onArtLoaded (e:Event) : void
		{
			trace ("Graphics loaded: " + path);
			var asset:Asset = new Asset (name, path, e.target.applicationDomain, Asset.GRAPHICS);
			dispatchEvent (new AssetParserEvent (AssetParserEvent.COMPLETED, 0, asset));
		}
	}
}