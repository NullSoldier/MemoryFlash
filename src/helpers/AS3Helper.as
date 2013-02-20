package helpers
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
	public class AS3Helper
	{
		public static function FunctionExists (obj:Object, name:String) : Boolean
		{
			return obj.hasOwnProperty (name);
		}
		
		public static function Some (array:Array, func:Function) : Boolean
		{
			return array.some (function (item:*, index:int, values:Array) : Boolean { 
				return func (item) });
		}
		
		public static function Cumulate (points:Vector.<Point>) : Point
		{
			var result:Point = new Point(0, 0);
			
			for each (var point:Point in points)
			result = result.add (point);
			
			return result;
		}
		
		
		public static function First (collection:*) : *
		{
			if (collection.length == 0)
				throw new Error ("Collection contains no items");
			
			return FirstOrNull (collection);
		}
		public static function FirstOrNullPredicate (collection:*, func:Function) : Object
		{
			for (var index:Object in collection) {
				if (Apply (func, collection[index], index))
					return collection[index];
			}
			
			return null;
		}
		
		public static function FirstOrNull (enumerable:*) : *
		{
			for (var index:Object in enumerable)
				return enumerable[index];
			
			return null;
		}
		
		public static function Last (enumerable:*) : *
		{
			if (enumerable.length == 0)
				throw new Error ("No items to return");
			
			if (enumerable is Array || IsVector (enumerable))
				return enumerable[enumerable.length-1];
			
			var i:int=0;
			for (var index:Object in enumerable) {
				if (++i == enumerable.length)
					return enumerable[index];
			}
			
		}
		
		public static function Count (enumerable:*) : *
		{
			var result:int = 0;
			for (var index:Object in enumerable)
				result++;
			
			return result;
		}
		
		public static function Random (low:int, high:int) : int
		{
			return Lerp (Math.random(), low, high);
		}
		
		public static function MakeTextField (defaultValue:String) : TextField
		{
			var field:TextField = new TextField();
			field.text = defaultValue;
			//field.selectable = false; //TODO: NotSupported
			return field;
		}
		
		public static function Clamp (value:Number, min:Number, max:Number) : Number
		{
			if (value < min)
				return min;
			if (value > max)
				return max;
			
			return value;
		}
		
		public static function LowerClamp (value:Number, min:Number) : Number
		{
			if (value < min)
				return min;
			
			return value;
		}
		
		// Take a percent between two values and give the percent between the values
		public static function Lerp (percent:Number, low:Number, high:Number) : Number
		{
			return percent * (high - low) + low;
		}
		
		// Takes a value, the high and low, and returns the percent
		public static function Unlerp (value:Number, low:Number, high:Number) : Number
		{
			return (value - low) / (high - low);
		}
		
		public static function DictToArray (dict:*) : Array
		{
			return Select (dict, function(item:*) : * {
				return item;
			});
		}
		
		public static function Select (collection:*, func:Function) : Array
		{
			var array:Array = new Array (collection);
			var result:Array = [];
			
			for (var index:Object in array[0])
				result.push (Apply (func, array[0][index], index));
			
			return result;
		}
		
		public static function Map (collection:*, keyPredicate:Function) : Object
		{
			var result:Object;
			ForEach (collection, function (item:*):void {
				result [keyPredicate(item)] = item;
			});
			
			return result;
		}
		
		public static function Where (collection:*, func:Function) : Array
		{
			var array:Array = new Array (collection);
			var result:Array = [];
			
			for (var index:Object in array[0]) {
				var item:Object = array[0][index];
				if (Apply (func, item, index))
					result.push (item);
			}
			
			return result;			
		}
		
		public static function ForEachChild (container:DisplayObjectContainer, func:Function) : void
		{
			var children:Array = [];
			var i:int = 0;
			
			for (i=0; i < container.numChildren; i++)
				children.push (container.getChildAt (i));
			
			for (i=0; i < children.length; i++)
				Apply (func, children[i], i);
		}
		
		public static function ForEach (items:Object, func:Function) : void
		{
			for (var index:* in items)
				Apply (func, items[index], index);
		}
		
		public static function Apply (f:Function, ... args:Array) : *
		{
			if (args.length < f.length) {
				throw new Error ("You must pass at least " + f.length + " arguments");
			}
			
			return f.apply (null, args.slice (0, f.length));
		}
		
		public static function DelayFunction (delaySeconds:int, callback:Function) : void
		{
			var delayMilliseconds:int = delaySeconds * 1000;
			setTimeout (callback, delayMilliseconds);
		}
		
		public static function ClampLoopableValue (value:int, min:int, max:int) : int
		{
			if (value < min)
				return ClampLoopableValue (max - (min - value) + 1, min, max);
			else if (value > max)
				return ClampLoopableValue (min + (value - max) - 1, min, max);
			
			return value;
		}
		
		public static function IsVector (obj:Object) : Boolean
		{
			return getQualifiedClassName (obj).indexOf ('__AS3__.vec::Vector') == 0;
		}
		
		//TODO: spaceport doesn't support IEventDispatcher, * should be IEventDispatcher
		public static function addOptionalListener (emitter:*, type:String, listener:Function) : void
		{
			Check.ArgNull (emitter, "emitter");
			Check.ArgNull (type, "type");
			
			if (listener != null)
				emitter.addEventListener (type, listener);
		}
		
		public static function IsStringEmpty (value:String) : Boolean
		{
			Check.ArgNull (value, "value");
			
			if (value.length == 0)
				return true;
				
			for (var i:int = 0; i < value.length; i++) {
				if (value.charAt (i) != "")
					return false;
			}
				
			return true;
		}
		
		public static function CopyObject (source:Object, dest:Object) : void
		{
			for (var index:String in source) {
				dest[index] = source[index];
			}
		}
		
		public static function TrimLeft (value:String) : String
		{
			for (var i:int=0; i<value.length; i++) {
				if (value.charAt(i) != " ")
					return value.slice (i);
			}
			
			return "";
		}
		
		public static function ToArray (iterable:*) : Array
		{
			var r:Array = [];
			for each (var elem:* in iterable) {
				r.push (elem);
			}
			return r;
		}
	}
}