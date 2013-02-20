package helpers
{
	import flash.utils.getDefinitionByName;
	
	public class Javascript
	{		
		public static function Alert (message:Object) : void
		{
			try {
				var externalInterface:Object = Object (getDefinitionByName ("flash.external.ExternalInterface"));
				externalInterface.call ("alert", message.toString());
			}
			catch (e:Error) {
				// Nom nom nom, eat error
			}
		}
	}
}