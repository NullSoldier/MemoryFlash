package assetloader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	
	public class AssetLoaderEvent extends Event
	{
		public function AssetLoaderEvent (type:String, progress:Number, asset:Object=null)
		{
			this.AssetLoaded = asset;
			this.Progress = progress;
			
			super (type);
		}		
		
		public var AssetLoaded:Object;
		public var Progress:Number;
		
		public static const PROGRESS_CHANGED:String = "progressChanged";
		public static const COMPLETED:String = "complete";
	}
}