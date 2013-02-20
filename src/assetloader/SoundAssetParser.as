package assetloader
{
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	public class SoundAssetParser extends EventDispatcher implements IAssetParser
	{
		public function Load (name:String, path:String) : void
		{
			trace ("Loading sound " + path);
			
			var sound:Sound = new Sound();
			sound.addEventListener (Event.COMPLETE, onSoundLoaded);
			//sound.addEventListener (ProgressEvent.PROGRESS, onBytesReceived);
			sound.addEventListener (IOErrorEvent.IO_ERROR, onErrorLoading);
			sound.load (new URLRequest (path));
			
			this.name = name;
			this.path = path;
		}
		
		private var bytesTotal:int = -1;
		private var bytesLoaded:int = -1;
		private var name:String;
		private var path:String;
		
		private function onErrorLoading (e:IOErrorEvent) : void
		{
			throw Error ("Failed to load sound " + path);			
		}
		
		private function onSoundLoaded (e:Event) : void
		{
			trace ("Sound loaded: " + path);
			var asset:Asset = new Asset (name, path, e.target, Asset.SOUND);
			dispatchEvent (new AssetParserEvent (AssetParserEvent.COMPLETED, 0, asset));
		}
	}
}