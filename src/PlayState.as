package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
 
	public class PlayState extends FlxState
	{
		[Embed(source = "../assets/sky.png")] private var skyPNG:Class;
		[Embed(source = "../assets/sea.png")] private var seaPNG:Class;
		
		
		private var bird:Bird;
		private var sky:FlxSprite;
		private var sea:FlxSprite;
		
		override public function create():void
		{
			//FlxG.visualDebug = true;
			FlxG.camera.setBounds(0, 0, 800, 600);
			FlxG.worldBounds = new FlxRect(0, 0, 800, 600);
			if (FlxG.getPlugin(FlxControl) == null)
			{
				FlxG.addPlugin(new FlxControl);
			}
			
			sky = new FlxSprite(0, 0, skyPNG);
			sky.width = 800;
			sky.height = 208;
			sky.scrollFactor.x = sky.scrollFactor.y = 0;
			
			sea = new FlxSprite(0, 208, seaPNG);
			sea.width = 800;
			sea.height = 392;
			sea.scrollFactor.x = sea.scrollFactor.y = 0;
			
			bird = new Bird(120, 120);
			bird.play("stop");
			
			FlxControl.create(bird, FlxControlHandler.MOVEMENT_ACCELERATES, FlxControlHandler.STOPPING_DECELERATES, 1, true, true);
			//FlxControl.player1.setStandardSpeed(300, true);
			FlxControl.player1.setGravity(0, Bird.AIR_GRAVITY);
			FlxControl.player1.setCursorControl(false, false, true, true);
			
			FlxG.watch(bird, "y", "bird.y");
			FlxG.watch(bird, "in_sky", "bird.in_sky");
			FlxG.watch(bird, "in_sea", "bird.in_sea");
			
			add(sky);
			add(sea);
			add(bird);
		}
		
		override public function update():void
		{
			//FlxG.overlap(sky, bird, birdInSky);
			//FlxG.overlap(sea, bird, birdInSea);
			if (bird.y >= (sky.height + bird.height / 2) && bird.in_sky)
				bird.nowInSea();
			else if (bird.y <= (sky.height - bird.height / 2) && bird.in_sea)
				bird.nowInSky();
			
			if (FlxG.keys.justReleased("ESCAPE"))
			{
				FlxG.switchState(new MenuState);
			}
			
			super.update();
		}
		
		public function birdInSky(sky:FlxSprite, bird:Bird):void {
			if (bird.in_sea)
				bird.nowInSky();
		}
		
		public function birdInSea(sea:FlxSprite, bird:Bird):void {
			if (bird.in_sky)
				bird.nowInSea();
		}
	}
}