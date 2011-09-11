package as3.ayawaska.util 
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	public class Profiler 
	{
		private static var _times:Dictionary = new Dictionary();
		private static var _iterations:Dictionary = new Dictionary();
		private static var _totals:Dictionary = new Dictionary();


		private static function count(type : String):Number {		
			var time : Number = getTimer() - _times[type];
			
			if (!_iterations[type]) _iterations[type] = 0;
			_iterations[type] ++;
			
			if (!_totals[type]) _totals[type] = 0;
			_totals[type] += time;
			
			if (time > 0)
			{
				trace("Profiler - time", type, "time : ", time, "(average : ", Number(_totals[type]) / Number(_iterations[type]), ")");
				if (time > 90)
				{
					trace("Too slow!");
				}
			}
			delete _times[type];
			
			return time;
		}
		
		// cannot deal with recursive call if the type is the function name
		public static function tick(type:String):void {
			if (_times[type]) {
				count(type);
			} else {
				_times[type] = getTimer();
			}
		}

		
	}

}