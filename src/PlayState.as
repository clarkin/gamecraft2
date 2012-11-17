package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
 
	public class PlayState extends FlxState
	{
		[Embed(source = "../assets/Venue_on_the_Beach.ttf", fontFamily = "Venue", embedAsCFF = "false")] public	var	FontVenue:String;
		[Embed(source = "../assets/sky.png")] private var skyPNG:Class;
		[Embed(source = "../assets/sea.png")] private var seaPNG:Class;
		
		
		private var bird:Bird;
		private var sky:FlxSprite;
		private var sea:FlxSprite;
		private var fishGroup:FlxGroup;
		private var fishTimer:Number = 0;
		private var GUI:FlxGroup;
		private var textScore:FlxText;
		
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
			
			fishGroup = new FlxGroup(100);
			
			GUI = new FlxGroup();
			textScore = new FlxText(600, 0, 200, "Score: 0", false);
			textScore.setFormat("Venue", 24, 0xFFCCCCFF, "left", 0x33666666);
			textScore.scrollFactor.x = textScore.scrollFactor.y = 0;
			GUI.add(textScore);
			
			add(sky);
			add(sea);
			add(bird);
			add(fishGroup);
			add(GUI);
		}
		
		override public function update():void
		{
			
			generateFish();
			checkSkySea();
			FlxG.collide(fishGroup);
			FlxG.overlap(fishGroup, bird, birdEatsFish);
			
			super.update();
		}
		
		private function generateFish():void {
				fishTimer += FlxG.elapsed;
				if (fishTimer > 5) {
					fishTimer = FlxMath.randFloat(0, 4);
					
					addFish();
				}
				
		}
		
		private function addFish():void {
			var newFish:Fish = new Fish(FlxMath.rand(0, 800), FlxMath.rand(240, 600), "bluefish");
			
			//newFish.play("appear");
			fishGroup.add(newFish);
		}
		
		private function birdEatsFish(fish:Fish, bird:Bird):void {
			fish.kill();
		}
		
		private function checkSkySea():void {
			if (bird.y >= (sky.height + bird.height / 2) && bird.in_sky)
				bird.nowInSea();
			else if (bird.y <= (sky.height - bird.height / 2) && bird.in_sea)
				bird.nowInSky();
			
			if (FlxG.keys.justReleased("ESCAPE"))
			{
				FlxG.switchState(new MenuState);
			}
		}
		
	}
}