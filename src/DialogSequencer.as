package
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;	
	import helpers.Check;

	public class DialogSequencer
	{
		public function DialogSequencer (textField:TextField,
			sound:SoundManager, dialog:Array)
		{
			Check.ArgNull (textField);
			Check.ArgNull (sound);
			Check.ArgNull (dialog);
			
			this.field = textField;
			this.sound = sound;
			this.sequences = parse (dialog);
			field.visible = false;
			field.addEventListener (Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function play (soundName:String) : void
		{
			if (!sequences[soundName]) {
				throw new Error ("Sound not found");
			}
			if (isPlaying) {
				channel.stop();
			}
			current = sequences[soundName];
			channel = sound.PlaySoundEffect (current.soundName, "vo");
			startTime = getTimer();
			field.text = "";
			field.visible = true;
			seqIndex = -1;
			isPlaying = true;
		}
			
		public function stop() : void
		{
			field.visible = false;			
			channel.stop();	
			isPlaying = false;
		}
		
		private var field:TextField;
		private var sound:SoundManager;
		private var sequences:Dictionary;
		
		private var isPlaying:Boolean;
		private var startTime:Number;
		private var seqIndex:int;
		private var current:Dialog;
		private var channel:SoundChannel;
		
		private function parse (data:Array) : Dictionary
		{
			var seqs:Dictionary = new Dictionary();
			for each (var seq:Object in data) {
				seqs[seq.sound] = new Dialog (seq.sound,
					seq.dialog, sound.GetLength (seq.sound));
			}
			return seqs;
		}
		
		private function onEnterFrame (e:Event) : void
		{
			if (!isPlaying) {
				return;
			}			
			var isLast:Boolean = seqIndex == current.dialog.length-1;
			if (!isLast) {
				var nextStart:Number = current.dialog[seqIndex+1].startTime;
				if (getTimer()-startTime >= nextStart) {
					trace ("Playing next statement: " + (getTimer()/1000));
					seqIndex++;
					field.text = current.dialog[seqIndex].text;
				} 
			} else {
				stop();
			}
		}
	}
}

class Dialog
{
	public function Dialog (soundName:String,
		items:Object, length:int)
	{
		this.soundName = soundName;
		this.dialog = new Vector.<DialogEntry>();
		for (var i:* in items) {
			dialog.push (new DialogEntry (i*1000, items[i]));
		}
		dialog.sort (DialogEntry.Compare);

		// Add empty sequence at end 
		var last:DialogEntry = dialog[dialog.length-1];
		var end:Number = last.startTime+(length-last.startTime)+endPadding;
		dialog.push (new DialogEntry (end, ""));
	}
	public var soundName:String;
	public var dialog:Vector.<DialogEntry>;
	private const endPadding:Number = 700;
}

class DialogEntry
{
	public function DialogEntry (start:Number, text:String)
	{
		this.startTime = start;
		this.text = text;
	}
	public var startTime:Number;
	public var text:String;
	
	public static function Compare (a:DialogEntry, b:DialogEntry) : int
	{
		if (a.startTime == b.startTime) {
			return 0;
		}
		return a.startTime < b.startTime
			? -1 : 1;
	}
}