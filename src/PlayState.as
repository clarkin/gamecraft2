package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.as3wavsound.*;
	import flash.utils.ByteArray;
 
	public class PlayState extends FlxState
	{
		[Embed(source = "../assets/sky.png")] private var skyPNG:Class;
		[Embed(source = "../assets/sea.png")] private var seaPNG:Class;
		
		[Embed(source = "../assets/splash.wav", mimeType = "application/octet-stream")] private const SplashWAV:Class;
		[Embed(source = "../assets/caw.wav", mimeType = "application/octet-stream")] private const CawWAV:Class;
		[Embed(source = "../assets/chomp.wav", mimeType = "application/octet-stream")] private const ChompWAV:Class;
		[Embed(source = "../assets/sadtrombone.wav", mimeType = "application/octet-stream")] private const TromboneWAV:Class;
		public var splashSound:WavSound;
		public var cawSound:WavSound;
		public var chompSound:WavSound;
		public var tromboneSound:WavSound;
				
		private var bird:Bird;
		private var sky:FlxSprite;
		private var sea:FlxSprite;
		
		private var fishGroup:FlxGroup;
		private var maxFish:int = 200;
		private var bubbleGroup:FlxGroup;
		private var maxBubbles:int = 1000;
		private var popupTextGroup:FlxGroup;
		private var maxPopupText:int = 200;
		
		private var fishTimer:Number = 0;
		private var GUI:FlxGroup;
		private var textScore:FlxText;
		private var score:Number = 0;
		private var paused:Boolean = false;
		private var resetDelay:Number = 10;
		
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
			
			fishGroup = new FlxGroup(maxFish);
			bubbleGroup = new FlxGroup(maxBubbles);
			for (var i:int = 0; i < maxBubbles; i++)
			{
				var bubble:Bubble = new Bubble(0, 0);
				bubble.kill();
				bubbleGroup.add(bubble);
			}
			popupTextGroup = new FlxGroup(maxPopupText);
			for (i = 0; i < maxPopupText; i++)
			{
				var popupText:PopupText = new PopupText(0, 0);
				
				popupText.kill();
				popupTextGroup.add(popupText);
			}
			
			GUI = new FlxGroup();
			textScore = new FlxText(600, 0, 200, "Score: 0", false);
			textScore.setFormat(null, 24, 0xFFFFFFCC, "left", 0xFF000000);
			textScore.scrollFactor.x = textScore.scrollFactor.y = 0;
			GUI.add(textScore);
			
			add(sky);
			add(sea);
			add(fishGroup);
			add(bubbleGroup);
			add(bird);
			add(popupTextGroup);
			add(GUI);
			
			FlxG.camera.follow(bird);
			
			for (i = 0; i < 30; i++) {
				addFish();
			}
			
			splashSound = new WavSound(new SplashWAV() as ByteArray);
			cawSound = new WavSound(new CawWAV() as ByteArray);
			chompSound = new WavSound(new ChompWAV() as ByteArray);
			tromboneSound = new WavSound(new TromboneWAV() as ByteArray);
		}
		
		override public function update():void
		{
			if (!paused) {
				generateFish();
				checkSkySea();
				checkControls();
				FlxG.collide(fishGroup);
				FlxG.collide(fishGroup, bird, birdEatsFish);
				
				super.update();
			} 			
		}
		
		public function addBubble(X:Number = 0, Y:Number = 0):void {
			var newBubble:Bubble = bubbleGroup.recycle(Bubble) as Bubble;
			X += FlxMath.rand( -10, 10);
			Y += FlxMath.rand( -10, 10);
			newBubble.reset(X, Y);
		}
		
		private function generateFish():void {
				fishTimer += FlxG.elapsed;
				if (fishTimer > 5) {
					fishTimer = FlxMath.randFloat(0, 4);
					
					addFish();
				}
				
		}
		
		private function addFish():void {
			var thisRand:int = Math.floor(Math.random() * 10);
			var thisType:String = "redfish";
			if (thisRand >= 9) {
				thisType = "yellowfish";
			} else if (thisRand >= 7) {
				thisType = "bluefish";
			} else if (thisRand >= 4) {
				thisType = "greenfish";
			}
				
			var newFish:Fish = new Fish(this, FlxMath.rand(0, 800), FlxMath.rand(500, 1000), thisType);
			fishGroup.add(newFish);
		}
		
		private function birdEatsFish(fish:Fish, bird:Bird):void {
			if (fish.type == "yellowfish") {
				paused = true;
				tromboneSound.play();
				FlxG.fade(0xFF000000, 5, finishedFade);
			} else if (bird.is_diving) {
				var randbubbles:int = FlxMath.rand(0, 6);
				for (var i:int = 0; i <= randbubbles; i++) {
					addBubble(fish.x, fish.y);
				}
				
				addPopupText(fish.x, fish.y, fish.value.toString());
				fish.kill();
				chompSound.play();
				score += fish.value;
				textScore.text = "Score: " + score;
			} else {
				fish.startMove(0.2);
			}
		}
		
		private function finishedFade():void {
			FlxG.switchState(new MenuState);
		}
		
		private function addPopupText(X:Number, Y:Number, newtext:String):void {
			var newPopupText:PopupText = popupTextGroup.recycle(PopupText) as PopupText;
			newPopupText.text = newtext;
			newPopupText.reset(X, Y);
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
					splashSound.play();
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