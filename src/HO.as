package
{
	public class HO
	{
		public static var CAN_MOUSEOVER:int = 1;
		public static var IS_ACTIVE:int = 2;
		public static var WILL_DISABLE:int = 4;
		public static var WILL_DISAPEAR:int = 8
		public static var IS_ENABLED:int = IS_ACTIVE | CAN_MOUSEOVER;
		public static var IS_CONSUMED:int = WILL_DISABLE | WILL_DISAPEAR;
	}
}