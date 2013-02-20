package assetloader
{
	import flash.events.IEventDispatcher;

	public interface IAssetParser extends IEventDispatcher
	{
		function Load (name:String, path:String) : void;
	}
}