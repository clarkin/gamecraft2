package
{
	import org.flixel.*; 
	[SWF(width = "800", height = "600", backgroundColor = "#000000")] 
	[Frame(factoryClass="Preloader")]
 
	public class gamecraft2 extends FlxGame
	{
		public function gamecraft2()
		{
			
			super(800, 600, MenuState, 1); 
		}
	}
}