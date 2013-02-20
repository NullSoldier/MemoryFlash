package assetloader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import helpers.AS3Helper;

	public class AssetLoader extends EventDispatcher
	{
		public function Start (assets:Object) : void
		{
			InitAssetParsers();
			finishedAssets = {};
			assetCount = AS3Helper.Count (assets);
			
			isStarted = true;
			ProcessAssets (assets);
		}
		
		private var isStarted:Boolean = false;
		private var bytesRecieved:int = 0;
		private var bytesTotal:int = 0;
		private var assetCount:int = 0;
		private var finishedAssets:Object;
		private var finishedCount:int;
		private var assetParsers:Object;
		
		private function InitAssetParsers() : void
		{
			assetParsers = {};
			assetParsers[Asset.GRAPHICS] = GraphicsAssetParser;
			assetParsers[Asset.SOUND] = SoundAssetParser;
			assetParsers[Asset.TEXT] = TextAssetParser;
			assetParsers[Asset.DELAYED] = DelayedAssetParser;
		}
		
		private function ProcessAssets (assets:Object) : void
		{
			for (var index:String in assets) {
				
				var assetType:String = assets[index].AssetType;
				var assetURL:String = assets[index].URI;
				
				if (!assetURL || assetURL.length == 0)
					throw Error ("Invalid path for asset " + index + " with path " + assetURL);
				if (assetParsers[assetType] == null)
					throw Error ("Invalid asset type: " +  assetType);
				
				var parser:* = IAssetParser(new assetParsers[assetType]());
				parser.addEventListener (AssetParserEvent.COMPLETED, onComplete);
				parser.Load (index, assetURL);
			}
		}
		
		private function onComplete (e:AssetParserEvent) : void
		{
			finishedAssets[e.AssetLoaded.Name] = e.AssetLoaded;
			finishedCount++;
			
			dispatchEvent (new AssetLoaderEvent (AssetLoaderEvent.PROGRESS_CHANGED, finishedCount / assetCount));
			if (finishedCount >= assetCount) {
				dispatchEvent (new AssetLoaderEvent (AssetLoaderEvent.COMPLETED, 1, finishedAssets));
			}
				
		}
	}
}