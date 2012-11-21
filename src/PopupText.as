package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class PopupText extends FlxText
	{
		private var _timeTilDeath:Number = 4.0;
		
		public function PopupText(X:Number = 0, Y:Number = 0)
		{
			super(X, Y, 50);
			this.setFormat("system", 20, 0xFFFFFFCC, "center", 0xFF333333);
			
			velocity.x = FlxMath.rand( -5, 5);
			velocity.y = FlxMath.rand( -20, 10);
			acceleration.y = 30;
		}
		
		
		override public function update():void
		{			
			checkElapsed();
			
			velocity.x += FlxMath.rand( -2, 2);
			
			super.update();
		}
		
		
		private function checkElapsed():void {
			_timeTilDeath -= FlxG.elapsed;
			if (_timeTilDeath <= 0) {
				this.kill();
			}
		}
		
	}

}