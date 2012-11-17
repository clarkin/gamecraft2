package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class MenuState extends FlxState
	{
		private var startButton:FlxButton;

		public function MenuState()
		{
		}

		override public function create():void
		{
			FlxG.mouse.show();
			var playback:FlxButtonPlus = new FlxButtonPlus(32, 32, startGame, null, "Start Game");
			add(playback);
			startGame();
		}

		private function startGame():void
		{
			FlxG.mouse.hide();
			FlxG.switchState(new PlayState);
		}
	}
}