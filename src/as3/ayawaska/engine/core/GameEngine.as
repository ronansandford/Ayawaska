/*
Copyright 2011 Ronan Sandford

	This file is part of Ayawaska.

    Ayawaska is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Ayawaska is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with Ayawaska.  If not, see <http://www.gnu.org/licenses/>.
*/
package as3.ayawaska.engine.core
{
	import as3.ayawaska.util.Profiler;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	public class GameEngine  
	{
		private var _world : World;
		private var _renderer : Renderer;
		
		private var _timer : Timer;
		
		private var _lastMilisecondTime : int;
		
		private var _gameController : GameController;
		
		public function GameEngine(world : World, renderer : Renderer, gameController : GameController):void 
		{
			_world = world;
			_renderer = renderer;
			_gameController = gameController;
		}
		
		public function start():void 
		{
			_timer = new Timer(1000 / 60); // update 60 time per second
			_timer.addEventListener(TimerEvent.TIMER, update);
			_timer.start();
		}
		
		private function update(e:TimerEvent):void 
		{
			var newMilisecondTime : int = getTimer();
			var milisecondStep : int = newMilisecondTime - _lastMilisecondTime;
			_lastMilisecondTime = newMilisecondTime;
			
			_world.update(milisecondStep);
			
			Profiler.tick("renderer");
			_renderer.update(milisecondStep);
			Profiler.tick("renderer");
		}
		
		
	}
	
}