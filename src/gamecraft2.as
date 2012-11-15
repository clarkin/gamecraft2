package
{
	import org.flixel.*; 
	[SWF(width = "640", height = "480", backgroundColor = "#000000")] 
	[Frame(factoryClass="Preloader")]
 
	public class gamecraft2 extends FlxGame
	{
		public function gamecraft2()
		{
			
			super(640, 480, MenuState, 1); 
		}
	}
}