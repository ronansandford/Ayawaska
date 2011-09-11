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
package as3.ayawaska.engine.renderer.displaylist 
{
	import as3.ayawaska.engine.core.Entity;
	import as3.ayawaska.engine.renderer.MouseEnabledRenderer2D;
	import as3.ayawaska.engine.world.twodimensions.Entity2D;
	import as3.ayawaska.engine.world.twodimensions.World2D;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class DisplayListRenderer implements MouseEnabledRenderer2D
	{
		private var _world : World2D;
		
		private var _entityRenderers : Dictionary;
		
		private var _display : DisplayObjectContainer;
		
		public function DisplayListRenderer(world : World2D, display : DisplayObjectContainer) 
		{
			_world = world;
			_display = display;
			_entityRenderers = new Dictionary(true); // use weak keys so that when the slot are garbage collected they are not attempted to be rendered
		}
		
		public function changeWorld(newWorld : World2D) : void
		{
			_world = newWorld;
		}
		
		public function update(milisecondStep : int) : void
		{
			var entities : Vector.<Vector.<Entity>> = _world.entities;
			
			var focusArea : Rectangle = _world.focusArea;
			
			var layerCounter : uint = 0;
			var entityCounter : uint = 0;
			for each(var layer : Vector.<Entity> in entities) // TODO : put layer in sperate displayObjectcontainer children of _display
			{
				for each (var entity : Entity2D in layer)
				{
					var renderer : DisplayListEntityRenderer = getEntityRenderer(entity);
					if (renderer != null)
					{
						renderer.updatePosition(entity.area.x - focusArea.x, entity.area.y - focusArea.y, entityCounter);
					}
					entityCounter ++;
				}
				layerCounter ++;
			}
			
		}
		
		private function getEntityRenderer(entity : Entity2D):DisplayListEntityRenderer 
		{
			var renderer : DisplayListEntityRenderer = _entityRenderers[entity];
			if (renderer == null)
			{
				if (entity is Entity2D)
				{
					renderer = new DisplayListEntityRenderer(entity, _display);
					_entityRenderers[entity] = renderer;
				}
				else
				{
					trace("DisplayListRenderer require 2d entities");
				}
			}
			return renderer;
		}
		
		
		public function getEntityUnderMouse() : Entity
		{
			return null;  //return _entityUnderMouse;
		}
	
		public function select(entity : Entity) : void
		{
			//var entityBitmapRenderer : EntityBitmapRenderer = _entityRendererFactory.getEntityRenderer(entity);
			//entityBitmapRenderer.selected = true;
		}
		
		public function unselect(entity : Entity) : void
		{
			//var entityBitmapRenderer : EntityBitmapRenderer = _entityRendererFactory.getEntityRenderer(entity);
			//entityBitmapRenderer.selected = false;
		}
		
		public function getWorldPositionFromScreen(x : Number, y : Number) : Point
		{
			return new Point(_world.focusArea.x + x, _world.focusArea.y + y);
		}
		
		
	}

}