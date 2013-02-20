package assetloader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import helpers.AS3Helper;
	
	public class DelayedAssetParser extends EventDispatcher implements IAssetParser
	{
		public function Load (name:String, path:String) : void
		{
			AS3Helper.DelayFunction (2, function():void {
				var asset:Asset = new Asset (name, path, "", Asset.TEXT);
				dispatchEvent (new AssetParserEvent (AssetParserEvent.COMPLETED, 1, asset));
			});
		}
	}
}