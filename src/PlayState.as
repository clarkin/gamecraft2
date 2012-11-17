package
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
 
	public class PlayState extends FlxState
	{
		[Embed(source = "../assets/sky.png")] private var skyPNG:Class;
		[Embed(source = "../assets/sea.png")] private var seaPNG:Class;
		
		
		private var bird:FlxSprite;
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
			FlxControl.player1.setGravity(0, 100);
			//FlxControl.player1.setCursorControl(true, false, false, false);
			
			FlxG.watch(bird.velocity, "x", "vx");
			FlxG.watch(bird.velocity, "y", "vy");
			
			add(sky);
			add(sea);
			add(bird);
		}
		
		override public function update():void
		{
			
			
			if (FlxG.keys.justReleased("SPACE"))
			{
				var flap_y:int = 100;
				var flap_x:int = 30;
				
				bird.play("flap");
				bird.velocity.y -= flap_y;
				if (bird.facing == FlxObject.LEFT)
					bird.velocity.x -= flap_x;
				else
					bird.velocity.x += flap_x;
			}
			
			if (FlxG.keys.justReleased("ESCAPE"))
			{
				FlxG.switchState(new MenuState);
			}
			
			super.update();
		}
	}
}