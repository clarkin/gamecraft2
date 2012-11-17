package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class Bubble extends FlxSprite
	{
		[Embed(source = "../assets/bubbles15x15.png")] private var bubblesPNG:Class;
		
		private var appearing:Boolean = true;
		
		public function Bubble(X:Number = 0, Y:Number = 0)
		{
			super(X,Y);
			
			loadGraphic(bubblesPNG, true, true, 15, 15);
			addAnimation("bubblin", [0,1,1,1,2,2,0,0,0,2,2,0], 2, true);
			elasticity = 0.8;
			maxVelocity.y = 100;
			maxVelocity.x = 100;
			acceleration.y = -30;
			play("bubblin");
		}
		
		
		override public function update():void
		{			
			checkBounds();
			
			velocity.x += FlxMath.rand( -2, 2);
			
			super.update();
		}
		
		
		private function checkBounds():void {
			if (y < 208) {
				this.kill();
			}
				
		}
		
	}

}