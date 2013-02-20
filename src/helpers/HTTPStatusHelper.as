package helpers 
{
	public class HTTPStatusHelper 
	{
		public static function IsSuccess (code:int) : Boolean
		{
			return (code >= 200 && code < 300);
		}
	}
}