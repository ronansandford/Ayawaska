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
package as3.ayawaska.engine.controller 
{
	import as3.ayawaska.engine.core.Entity;
	import as3.ayawaska.engine.core.GameController;
	import as3.ayawaska.engine.core.Renderer;
	import as3.ayawaska.engine.renderer.MouseEnabledRenderer2D;
	import as3.ayawaska.engine.world.twodimensions.Entity2D;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class SampleGameController implements GameController 
	{
		private var _renderer : MouseEnabledRenderer2D;
		private var _display : InteractiveObject;
		
		private var _selectedEntities : Vector.<Entity>;
		
		public function SampleGameController(renderer : MouseEnabledRenderer2D, display : InteractiveObject) 
		{
			_renderer = renderer;
			_display = display;
			
			_selectedEntities = new Vector.<Entity>();
			
			_display.doubleClickEnabled = true;
			_display.addEventListener(MouseEvent.CLICK, onMouseClick);
			_display.addEventListener(MouseEvent.DOUBLE_CLICK, onMouseDoubleClick);
		}
		
		private function onMouseDoubleClick(e:MouseEvent):void 
		{
			unselectAll();
		}
		
		private function onMouseClick(e:MouseEvent):void 
		{
			
			var entity : Entity = _renderer.getEntityUnderMouse();			
			if (entity != null)
			{
				unselectAll();
				selectEntity(entity);
			}
			else 
			{
				for each (var selectedEntity : Entity2D in _selectedEntities)
				{
					selectedEntity.moveTo(_renderer.getWorldPositionFromScreen(e.localX, e.localY));
				}
			}

		}
		
		private function unselectAll():void 
		{
			for each(var entity : Entity in _selectedEntities)
			{
				_renderer.unselect(entity);
			}
			_selectedEntities = new Vector.<Entity>;
		}
		
		private function selectEntity(entity:Entity):void 
		{
			if (_selectedEntities.indexOf(entity) == -1)
			{
				_selectedEntities.push(entity);
			}
			_renderer.select(entity);
		}
		
	}

}