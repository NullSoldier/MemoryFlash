package caurina.transitions
{
	public class TweenTask
	{
		public function TweenTask (tweenObject:Object, tweenListObj:TweenListObj)
		{
			this.tweenObject = tweenObject;
			this.tweenListObj = tweenListObj;
			this.arrayProperties = ConvertPropertiesToArray (tweenObject, tweenListObj.properties);
		}
		
		public function Pause() : void
		{
			checkCanceled("Pause");
			Tweener.affectTweens (Tweener.pauseTweenByIndex, tweenObject, arrayProperties);
		}
		
		public function Resume() : void
		{
			checkCanceled("Resume");
			Tweener.affectTweens (Tweener.resumeTweenByIndex, tweenObject, arrayProperties)
		}
		
		public function Finish() : void
		{
			checkCanceled ("Finish");
			Tweener.affectTweens (Tweener.finishTweenByIndex, tweenObject, arrayProperties);
		}
		
		public function Cancel() : void
		{
			checkCanceled ("Cancel");
			canceled = true;
			
			Tweener.affectTweens (Tweener.removeTweenByIndex, tweenObject, arrayProperties);
		}
		
		public function get IsCanceled() : Boolean
		{
			return canceled;
		}
		
		public function ContinueWith(callback:Function) : void
		{
			checkCanceled("ContinueWith");
			
			var oldCallback:Function = tweenListObj.onComplete;
			tweenListObj.onComplete = function():void {
				if (oldCallback != null)
					oldCallback();
				callback();
			}
		}
		
		private var tweenObject:Object;
		private var tweenListObj:TweenListObj;
		private var canceled:Boolean = false;
		private var callback:Function;
		private var arrayProperties:Array;
		
		private function checkCanceled (action:String) : void
		{
			if (canceled)
				throw new Error ("Tween has been canceled, cannot " + action);
		}
		
		private function ConvertPropertiesToArray(p_scope:Object, args:Object) : Array
		{
			var properties:Array = new Array();
			var i:uint;
			for (i = 0; i < args.length; i++)
			{
				if (typeof(args[i]) != "string" || properties.indexOf(args[i]) != -1)
					continue;
				
				if (Tweener._specialPropertySplitterList[args[i]])
				{
					//special property, get splitter array first
					var sps:SpecialPropertySplitter = Tweener._specialPropertySplitterList[args[i]];
					var specialProps:Array = sps.splitValues(p_scope, null);
					
					for (var j:uint = 0; j<specialProps.length; j++)
					{
						//trace(specialProps[j].name);
						properties.push(specialProps[j].name);
					}
				} else {
					properties.push(args[i]);
				}
			}
			
			return properties;
		}
	}
}