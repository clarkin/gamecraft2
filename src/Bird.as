package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Bird extends FlxSprite
	{
		[Embed(source = "../assets/birds32x32_flipped.png")] private var birdPNG:Class;
		
		public static const FLAP_X:Number = 50;
		public static const FLAP_Y:Number = 200;
		public static const ELASTICITY:Number = 0.2;
		public static const AIR_GRAVITY:Number = 300;
		public static const WATER_BUOYANCY:Number = -1400;
		
		public var in_sky:Boolean = false;
		public var in_sea:Boolean = false;
		public var is_diving:Boolean = false;
		
		private var diveTimer:Number = 0;
		public var depthModifier:Number = 1;
		
		private var _playstate:PlayState;
		
		public function Bird(playstate:PlayState, X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			
			_playstate = playstate;
			
			width = 32;
			height = 32;
			elasticity = 0.2;
			maxVelocity.y = 800;
			maxVelocity.x = 200;
			loadGraphic(birdPNG, true, true, 32, 32);
			addAnimation("stop", [5]);
			addAnimation("flap", [5, 4, 1], 20, false);
			addAnimation("diving", [6]);
			antialiasing = true;
			this.acceleration.y = AIR_GRAVITY;
			
			in_sky = true;
		}
		
		
		override public function update():void
		{
			
			checkDepth();
			
			checkFlap();
			checkBounds();
			
			super.update();
		}
		
		public function nowInSky():void {
			in_sky = true;
			in_sea = false;
			this.acceleration.y = AIR_GRAVITY;
			maxVelocity.y = 800;
		}
		public function nowInSea():void {
			in_sky = false;
			in_sea = true;
			this.acceleration.y = WATER_BUOYANCY;// * depthModifier;
		}
		
		private function checkDepth():void {
			if (in_sea) {
				depthModifier = 0.3 + (this.y - 500) * (this.y - 500) / 250000;
				if (velocity.y > 0) {
					this.acceleration.y = depthModifier * WATER_BUOYANCY;
				} else {
					maxVelocity.y = 200 * depthModifier;
				}
			} else {
				depthModifier = 0.3 + (this.y) * (this.y) / 250000;
			}
			
			
		}
		
		private function checkFlap():void {
			
			if (FlxG.keys.LEFT) {
				facing = LEFT;
			} else if (FlxG.keys.RIGHT) {
				facing = RIGHT;
			}
			
			
			if (FlxG.keys.SPACE) {
				diveTimer += FlxG.elapsed;
				if (!is_diving && in_sky && diveTimer > 0.5 && velocity.y > -10) {
					is_diving = true;
					diveTimer = 0;
					play("diving");
				}
			}
			
			if (FlxG.keys.justReleased("SPACE"))
			{	
				diveTimer = 0;
				if (is_diving)
				{
					is_diving = false;
					play("stop");
				} else if (in_sky) {
					play("flap", true);
					velocity.y -= FLAP_Y * depthModifier;
					if (facing == LEFT)
						velocity.x -= FLAP_X * depthModifier;
					else
						velocity.x += FLAP_X * depthModifier;
				}
			}
			
			if (is_diving) {
				if (in_sky) {
					velocity.y += 10;
				} else {
					//velocity.y += 10;
					//drag.y -= 10;
					velocity.y += 2;
					
					if (Math.floor(Math.random() * 10) > 4)
						_playstate.addBubble(x, y);
						
					diveTimer += FlxG.elapsed;
					if (diveTimer > 3) {
						is_diving = false;
						play("stop");
					}
				}
			} else {
				
			}
			
		}
		
		private function checkBounds():void {
			if (y < 0) {
				y = 0;
			} else if (y > FlxG.worldBounds.height - this.height) {
				y = FlxG.worldBounds.height - this.height;
			}
				
			if (x < 0) {
				x = 0;
				velocity.x = -velocity.x * ELASTICITY;
				facing = RIGHT;
			} else if (x > FlxG.worldBounds.width - this.width) {
				x = FlxG.worldBounds.width - this.width;
				velocity.x = -velocity.x * ELASTICITY;
				facing = LEFT;
			}
		}
		
	}

}