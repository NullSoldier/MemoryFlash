package assetloader
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	
	public class AssetParserEvent extends Event
	{
		public function AssetParserEvent (type:String, byteCount:int, asset:Asset=null)
		{
			this.AssetLoaded = asset;
			this.ByteCount = byteCount;
			
			super (type);
		}		
		
		public var AssetLoaded:Asset;
		public var ByteCount:int;
		
		public static const BYTES_RECEIVED:String = "bytesReceived";
		public static const STARTED:String = "started";
		public static const COMPLETED:String = "complete";
	}
}