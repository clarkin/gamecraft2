package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Bird extends FlxSprite
	{
		[Embed(source = "../assets/birds32x32_flipped.png")] private var birdPNG:Class;
		
		public static const FLAP_X:Number = 30;
		public static const FLAP_Y:Number = 100;
		public static const ELASTICITY:Number = 0.2;
		public static const AIR_GRAVITY:Number = 200;
		public static const WATER_BUOYANCY:Number = -400;
		
		public var in_sky:Boolean = false;
		public var in_sea:Boolean = false;
		
		public function Bird(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			
			width = 32;
			height = 32;
			elasticity = 0.2;
			maxVelocity.y = 400;
			maxVelocity.x = 200;
			loadGraphic(birdPNG, true, true, 32, 32);
			addAnimation("stop", [5], 10, true);
			addAnimation("flap", [5, 4, 1], 20, false);
			
			in_sky = true;
		}
		
		
		override public function update():void
		{
			
			checkFlap();
			checkBounds();
			
			super.update();
		}
		
		public function nowInSky():void {
			in_sky = true;
			in_sea = false;
			FlxControl.player1.setGravity(0, AIR_GRAVITY);
			velocity.y *= (ELASTICITY * 2);
		}
		public function nowInSea():void {
			in_sky = false;
			in_sea = true;
			FlxControl.player1.setGravity(0, WATER_BUOYANCY);
		}
		
		private function checkFlap():void {
			if (FlxG.keys.justReleased("SPACE"))
			{				
				play("flap", true);
				velocity.y -= FLAP_Y;
				if (facing == LEFT)
					velocity.x -= FLAP_X;
				else
					velocity.x += FLAP_X;
			}
		}
		
		private function checkBounds():void {
			if (y < 0) {
				y = 0;
			} else if (y > FlxG.height - this.height) {
				y = FlxG.height - this.height;
			}
				
			if (x < 0) {
				x = 0;
				velocity.x = -velocity.x * ELASTICITY;
				facing = RIGHT;
			} else if (x > FlxG.width - this.width) {
				x = FlxG.width - this.width;
				velocity.x = -velocity.x * ELASTICITY;
				facing = LEFT;
			}
		}
		
	}

}