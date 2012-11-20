package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Fish extends FlxSprite
	{
		[Embed(source = "../assets/redfish_15x15.png")] private var redfishPNG:Class;
		[Embed(source = "../assets/greenfish_23x23.png")] private var greenfishPNG:Class;
		[Embed(source = "../assets/bluefish_31x31.png")] private var bluefishPNG:Class;
		[Embed(source = "../assets/yellowfish_39x39.png")] private var yellowfishPNG:Class;
		
		public static const FLAP_X:Number = 80;
		public static const FLAP_Y:Number = 40;
		public static const DRAG:Number = 200;
		
		private var appearing:Boolean = true;
		private var moveTimer:Number = 0;
		private var blinkTimer:Number = 0;
		public var value:int = 1;
		
		private var _playstate:PlayState;
		
		public function Fish(playstate:PlayState, X:Number = 0, Y:Number = 0, type:String = "bluefish") 
		{
			super(X, Y);
			
			_playstate = playstate;
			
			switch (type) {
				case "redfish":
				loadGraphic(redfishPNG, true, true, 15, 15);
				addAnimation("stop", [0]);
				addAnimation("appear", [0], 20, false);
				addAnimation("blink", [0], 20, false);
				break;
				
				case "greenfish":
				loadGraphic(greenfishPNG, true, true, 23, 23);
				addAnimation("stop", [0]);
				addAnimation("appear", [0], 20, false);
				addAnimation("blink", [0, 1, 2, 3, 0], 20, false);
				break;
				
				case "bluefish":
				loadGraphic(bluefishPNG, true, true, 31, 31);
				addAnimation("stop", [0]);
				addAnimation("appear", [4, 5, 6, 7], 20, false);
				addAnimation("blink", [0, 1, 2, 3, 0], 20, false);
				break;
				
				case "yellowfish":
				loadGraphic(yellowfishPNG, true, true, 39, 39);
				addAnimation("stop", [0]);
				addAnimation("appear", [4, 5, 0], 20, false);
				addAnimation("blink", [0, 1, 2, 3, 0], 20, false);
				value = 10;
				break;
			}
			
			elasticity = 0.6;
			
			var randnum:int = Math.floor(Math.random() * 4) - 4;
			moveTimer = blinkTimer = randnum;
			
			if (FlxMath.rand(1, 3) == 1)
				facing = LEFT;
			else 
				facing = RIGHT;
			
			play("appear");
		}
		
		
		override public function update():void
		{
			if (this.finished && appearing) {
				play("stop");
				appearing = false;
			}
			
			if (appearing) {
				//play("appear"); 
			} else {
				checkMove();
			}
			
			checkBounds();
			
			super.update();
		}
		
		
		
		private function checkMove():void {
			moveTimer += FlxG.elapsed;
			blinkTimer += FlxG.elapsed;
			
			if (moveTimer > 5) {
				moveTimer = FlxMath.randFloat(-5, 4);
				startMove();
			} else if (blinkTimer > 10) {
				blinkTimer = FlxMath.randFloat( -10, 8);
				if (Math.floor(Math.random()*2) == 1) {
					play("blink");
				} else {
					_playstate.addBubble(x, y);
				}
			}
			
		}
		
		public function startMove(intensity:Number = 1.0):void {
			var down:int = intensity;
			if (Math.floor(Math.random() * 2) == 1)
				down = -down;
			var right:int = intensity;
			facing = RIGHT;
			if (Math.floor(Math.random() * 2) == 1) {
				right = -right;
				facing = LEFT;
			}	
			
			this.velocity.x += right * (Math.floor(Math.random() * FLAP_X) + DRAG);
			this.velocity.y += down * (Math.floor(Math.random() * FLAP_Y) + DRAG);
			this.drag.x = DRAG;
				this.drag.y = DRAG;
		}
		
		private function checkBounds():void {
			if (y < 500) {
				y = 500;
			} else if (y > FlxG.worldBounds.height - this.height) {
				y = FlxG.worldBounds.height - this.height;
			}
				
			if (x < 0) {
				x = 0;
				velocity.x = -velocity.x * elasticity;
				facing = RIGHT;
			} else if (x > FlxG.worldBounds.width - this.width) {
				x = FlxG.worldBounds.width - this.width;
				velocity.x = -velocity.x * elasticity;
				facing = LEFT;
			}
		}
		
	}

}