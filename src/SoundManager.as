package
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import helpers.AS3Helper;

	public class SoundManager
	{	
		public function get IsMusicMuted() : Boolean { return musicMuted; }
		public function set IsMusicMuted (value:Boolean) : void {
			musicMuted = value;
			invalidateMusicVolume();
			SaveSettings();
		}
		
		public function get IsSoundEffectsMuted() : Boolean { return soundEffectsMuted; }
		public function set IsSoundEffectsMuted (value:Boolean) : void {
			soundEffectsMuted = value;
			SaveSettings();
		}
		
		public function get IsMusicPlaying() : Boolean
		{
			//TODO: make this actually work
			return music != null;
		}
		
		public function LoadSettings() : void
		{
			var sharedObject:SharedObject = SharedObject.getLocal ("soundPreferences");
			
			soundEffectsMuted = Boolean (sharedObject.data.SoundEffectsMuted);
			musicMuted = Boolean (sharedObject.data.MusicMuted);
		}
		
		public function SaveSettings() : void
		{
			var sharedObject:SharedObject = SharedObject.getLocal ("soundPreferences");
			
			sharedObject.data.SoundEffectsMuted = soundEffectsMuted;
			sharedObject.data.MusicMuted = musicMuted;
			sharedObject.flush();
		}
		
		public function AddResource (name:String, sound:Sound) : void
		{
			sounds[name] = sound;
		}
		
		public function PlaySoundEffect (name:String, channel:String="") : SoundChannel
		{
			if (!sounds[name]) {
				trace ("WARNING: Sound effect with name: " + name + " not found");
				return null;
			} else if (soundEffectsMuted) {
				return null;
			}
			if (channels[channel] && channel.length > 0) {
				SoundChannel (channels[channel]).stop();
			}
			return channels[channel] = Sound (sounds[name]).play (0, 1);
		}
		
		public function PlayBackgroundMusic (name:String, volume:Number=1) : void
		{	
			if (!sounds[name]) {
				trace ("WARNING: Sound effect with name: " + name + " not found");
				return;
			}
			
			// If the song is already playing, do nothing
			if (sounds[name] == music)
				return;
			
			StopBackgroundMusic();
			music = Sound (sounds[name]);
			musicChannel = music.play (0, int.MAX_VALUE, new SoundTransform (0));
			invalidateMusicVolume (volume);
		}
		
		public function StopBackgroundMusic () : void
		{
			if (music == null)
				return;
			
			musicChannel.stop();
			musicChannel = null;
			music = null;
		}
		
		public function CreateSoundPool (poolName:String, ... soundNames:Array) : void
		{
			if (soundNames.length == 1)
				throw Error ("Cannot create a sound pool with 1 sound");
			if (soundPools[poolName])
				throw Error ("Sound pool with that name already exists");
			
			soundPools[poolName] = [];
			AS3Helper.ForEach (soundNames, function(item:String):void {
				if (!item)
					throw Error ("Tried to add invalid item to sound pool");
					
				soundPools[poolName].push (item);
			});
		}
		
		public function PlaySoundPool (poolName:String) : void
		{
			if (!soundPools[poolName])
				throw Error ("Pool does not exist with name: " + poolName);
			
			var soundPool:Array = soundPools[poolName] as Array;
			var randomIndex:int = AS3Helper.Random (0, soundPools[poolName].length - 2);
			var soundName:String = String (soundPool[randomIndex]);
			
			soundPool.push (soundPool.splice (randomIndex, 1)[0]);
			PlaySoundEffect (soundName);
		}
		
		/**
		 * Returns the length of a loaded sound in milliseconds
		 */
		public function GetLength (name:String) : Number
		{
			if (!sounds[name]) {
				throw new Error ("Sound not found");
			}
			return Sound (sounds[name]).length;
		}
		
		private var musicMuted:Boolean;
		private var soundEffectsMuted:Boolean;
		
		private var sounds:Object = { };
		private var soundPools:Object = { };
		private var channels:Object = { };
		
		private var music:Sound;
		private var musicChannel:SoundChannel;
		
		private function invalidateMusicVolume (unmutedVolume:Number=1) : void
		{
			if (musicChannel != null) {
				var volume:Number = IsMusicMuted ? 0 : unmutedVolume;
				musicChannel.soundTransform = new SoundTransform (volume);
			}
		}		
	}
}