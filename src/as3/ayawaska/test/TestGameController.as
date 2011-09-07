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
package as3.ayawaska.test 
{
	import as3.ayawaska.engine.core.Entity;
	import as3.ayawaska.engine.core.GameController;
	import as3.ayawaska.engine.renderer.MouseEnabledRenderer2D;
	import as3.ayawaska.engine.world.twodimensions.World2D;
	import as3.ayawaska.test.TestEntity;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;

	public class TestGameController implements GameController 
	{
		private var _renderer : MouseEnabledRenderer2D;
		private var _display : InteractiveObject;
		
		private var _hero:TestEntity;
		
		private var _world:World2D;
		
		private var _point1 : Point;
		private var _point2 : Point;
		
		private var _dragging : Boolean;
		private var _mouseDelay : uint;
		
		// display could be moved into renderer
		public function TestGameController(renderer : MouseEnabledRenderer2D, display : InteractiveObject, hero : TestEntity, world : World2D) 
		{
			_renderer = renderer;
			_display = display;
			
			_hero = hero;
			_world = world;
			
			_point1 = new Point();
			_point2 = new Point();
			
			_dragging = false;
			
			_display.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//_display.addEventListener(MouseEvent.CLICK, onMouseClick);
			
			
			
		}
		
		private function onMouseDown(e:MouseEvent):void 
		{
			_mouseDelay = getTimer();
			_point1.x = e.localX;
			_point1.y = e.localY;
			_dragging = true;
			_display.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_display.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			if (_dragging)
			{
				_point2.x = e.localX;
				_point2.y = e.localY;
				var deltaPoint : Point = _point2.subtract(_point1);
				_point1.x = _point2.x;
				_point1.y = _point2.y;
				
				_world.focusArea.x -= deltaPoint.x;
				_world.focusArea.y -= deltaPoint.y;
			}
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			var now : uint = getTimer();
			_display.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_display.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_dragging = false;
			
			if (now - _mouseDelay < 300)
			{
				onMouseClick(e);
			}
		}
		
		
		private function onMouseClick(e:MouseEvent):void 
		{
			
			var entity : Entity = _renderer.getEntityUnderMouse();			
			if (entity != null)
			{
				_hero.goKill(entity);
			}
			else 
			{
				_hero.moveTo(_renderer.getWorldPositionFromScreen(e.localX, e.localY));
			}
		}
				
	}

}