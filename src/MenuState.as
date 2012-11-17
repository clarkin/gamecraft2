package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	public class MenuState extends FlxState
	{
		[Embed(source = "../assets/Venue_on_the_Beach.ttf", fontFamily = "Venue", embedAsCFF = "false")] public	var	FontVenue:String;

		public function MenuState()
		{
		}

		override public function create():void
		{
			FlxG.mouse.show();
			
			var title:FlxText = new FlxText(0, 100, 800, "Seabird Plunge", true);
			title.setFormat("Venue", 100, 0xFF3333CC, "center");
			
			var playback:FlxButtonPlus = new FlxButtonPlus(100, 300, startGame, null, "Start Game");
			playback.screenCenter();
			
			var instructions:FlxText = new FlxText(0, 500, 800, "Hit SPACE to flap your wings. LEFT/RIGHT to turn.", true);
			instructions.setFormat("Venue", 20, 0xFF3333CC, "center");
			
			add(title);
			add(instructions);
			add(playback);
			
			
			/startGame();
		}

		private function startGame():void
		{
			FlxG.mouse.hide();
			FlxG.switchState(new PlayState);
		}
	}
}