package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.as3wavsound.*;
	import flash.utils.ByteArray;
 
	public class PlayState extends FlxState
	{
		[Embed(source = "../assets/Venue_on_the_Beach.ttf", fontFamily = "Venue", embedAsCFF = "false")] public	var	FontVenue:String;
		[Embed(source = "../assets/sky.png")] private var skyPNG:Class;
		[Embed(source = "../assets/sea.png")] private var seaPNG:Class;
		
		[Embed(source = "../assets/splash.wav", mimeType = "application/octet-stream")] private const SplashWAV:Class;
				
		private var bird:Bird;
		private var sky:FlxSprite;
		private var sea:FlxSprite;
		private var fishGroup:FlxGroup;
		private var bubbleGroup:FlxGroup;
		
		private var fishTimer:Number = 0;
		private var GUI:FlxGroup;
		private var textScore:FlxText;
		private var score:Number = 0;
		
		private var splashSound:WavSound;
		
		override public function create():void
		{
			//FlxG.visualDebug = true;
			FlxG.camera.setBounds(0, 0, 800, 1000);
			FlxG.worldBounds = new FlxRect(0, 0, 800, 1000);
			if (FlxG.getPlugin(FlxControl) == null)
			{
				FlxG.addPlugin(new FlxControl);
			}
			
			sky = new FlxSprite(0, 0, skyPNG);
			sky.width = 800;
			sky.height = 500;
			//sky.scrollFactor.x = sky.scrollFactor.y = 0;
			
			sea = new FlxSprite(0, 500, seaPNG);
			sea.width = 800;
			sea.height = 500;
			//sea.scrollFactor.x = sea.scrollFactor.y = 0;
			
			bird = new Bird(this, 20, 480);
			bird.play("stop");
			
			FlxG.watch(bird, "y", "bird.y");
			FlxG.watch(bird.acceleration, "y", "bird.acceleration.y");
			FlxG.watch(bird.velocity, "y", "bird.velocity.y");
			FlxG.watch(bird, "depthModifier", "bird.depthModifier");
			FlxG.watch(bird.maxVelocity, "y", "bird.maxVelocity.y");
			FlxG.watch(bird, "is_diving", "bird.is_diving");
			FlxG.watch(bird, "in_sky", "bird.in_sky");
			FlxG.watch(bird, "in_sea", "bird.in_sea");
			
			fishGroup = new FlxGroup(100);
			bubbleGroup = new FlxGroup(500);
			
			GUI = new FlxGroup();
			textScore = new FlxText(600, 0, 200, "Score: 0", false);
			textScore.setFormat(null, 24, 0xFFCCCCFF, "left", 0xFF000000);
			textScore.scrollFactor.x = textScore.scrollFactor.y = 0;
			GUI.add(textScore);
			
			add(sky);
			add(sea);
			add(fishGroup);
			add(bubbleGroup);
			add(bird);
			add(GUI);
			
			FlxG.camera.follow(bird);
			
			for (var i:int = 0; i < 10; i++) {
				addFish();
			}
			
			splashSound = new WavSound(new SplashWAV() as ByteArray);
		}
		
		override public function update():void
		{
			
			generateFish();
			checkSkySea();
			checkControls();
			FlxG.collide(fishGroup);
			FlxG.collide(fishGroup, bird, birdEatsFish);
			
			super.update();
		}
		
		public function addBubble(X:Number = 0, Y:Number = 0):void {
			
			bubbleGroup.add(new Bubble(X, Y));
		}
		
		private function generateFish():void {
				fishTimer += FlxG.elapsed;
				if (fishTimer > 5) {
					fishTimer = FlxMath.randFloat(0, 4);
					
					addFish();
				}
				
		}
		
		private function addFish():void {
			
			var thisType:String = "bluefish";
			if (Math.floor(Math.random()*10) >= 8) {
				thisType = "yellowfish";
			}
				
			var newFish:Fish = new Fish(this, FlxMath.rand(0, 800), FlxMath.rand(500, 1000), thisType);
			fishGroup.add(newFish);
			
			//addBubble(newFish.x, newFish.y);
		}
		
		private function birdEatsFish(fish:Fish, bird:Bird):void {
			if (bird.is_diving) {
				var randbubbles:int = FlxMath.rand(0, 6);
				for (var i:int = 0; i <= randbubbles; i++) {
					addBubble(fish.x, fish.y);
				}
				score += fish.value;
				fish.kill();
				textScore.text = "Score: " + score;
			} else {
				fish.startMove(0.2);
			}
		}
		
		private function checkSkySea():void {
			if (bird.y >= (sky.height - bird.height*0.75) && bird.velocity.y > 0 ) {
				
				if (bird.in_sky) {
					
					splashSound.play();
					bird.nowInSea();
				}
			}
			else if (bird.y <= (sky.height - bird.height*0.75) && bird.velocity.y <= 0 ) {
				
				if (bird.in_sea) {
					bird.nowInSky();
				}
			}
			
		}
		
		private function checkControls():void {
			
			
			if (FlxG.keys.justReleased("ESCAPE"))
			{
				FlxG.switchState(new MenuState);
			}
		}
		
	}
}