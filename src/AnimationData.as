package
{
	public class AnimationData
	{
		public static var playerAnimationsData:Array = [
			{
				name: "idle",
				length: 1,
				bounds: {x: 0, y: 0, width: 250, height: 500}
			},
			{
				name: "look",
				length: 9,
				bounds: {x: 0, y: 500, width: 250, height: 500}
			},
			{
				name: "walk",
				length: 8,
				bounds: {x: 0, y: 1000, width: 250, height: 500}
			},
			{
				name: "pickup",
				length: 5,
				bounds: {x: 0, y: 1500, width: 250, height: 500}
			},
			{
				name: "standup",
				length: 3,
				bounds: {x: 0, y: 3000, width: 250, height: 500}
			},
			{
				name: "kick",
				length: 5,
				bounds: {x: 0, y: 2000, width: 250, height: 500}
			},
			{
				name: "wakeup",
				length: 8,
				bounds: {x: 0, y: 2500, width: 250, height: 500}
			}
		];
	}
}