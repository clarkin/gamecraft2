package  
{
	import org.flixel.*;
	
	public class Bird extends FlxSprite
	{
		[Embed(source = "../assets/birds32x32_flipped.png")] private var birdPNG:Class;
		
		public function Bird(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			
			width = 32;
			height = 32;
			elasticity = 0.2;
			maxVelocity.y = 200;
			maxVelocity.x = 200;
			loadGraphic(birdPNG, true, true, 32, 32);
			addAnimation("stop", [5], 10, true);
			addAnimation("flap", [5, 4, 1], 20, false);
		}
		
	}

}