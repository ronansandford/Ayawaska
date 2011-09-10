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
package as3.ayawaska.engine.renderer.bitmap 
{
	import as3.ayawaska.engine.core.Entity;
	import as3.ayawaska.engine.renderer.MouseEnabledRenderer2D;
	import as3.ayawaska.engine.world.twodimensions.Entity2D;
	import as3.ayawaska.engine.world.twodimensions.World2D;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapRenderer implements MouseEnabledRenderer2D
	{
		private var _world : World2D;
		private var _display : Bitmap;
		private var _entityRendererFactory : EntityBitmapRendererFactory;
		
		
		private var _position : Point; // use to do point work avoinding point instanciation every time
		// TODO : use ObjectPool for Point, Rectangle... 
		
		private var _entityUnderMouse:Entity;
		
		public function BitmapRenderer(world : World2D, display : Bitmap, entityRendererFactory : EntityBitmapRendererFactory) 
		{
			_world = world;
			_display = display;
			_entityRendererFactory = entityRendererFactory;
			
			_position = new Point();
		}
		
		public function update(milisecondStep : int) : void
		{
			var bitmapData : BitmapData = _display.bitmapData;
			var bitmapDataRect : Rectangle = bitmapData.rect;
			
			//clear the display // could potentially check whether things have changed and update only these
			bitmapData.lock();
			bitmapData.fillRect(bitmapDataRect, 0x000000);
			
			// re initialize
			_entityUnderMouse = null;
			
			
			var entities : Vector.<Vector.<Entity>> = _world.entities;
			
			var focusArea : Rectangle = _world.focusArea;
			
			var layerCounter : uint = 0;
			for each(var layer : Vector.<Entity> in entities)
			{
				for each (var entity : Entity2D in layer)
				{
					var xOffset : Number = entity.area.x - focusArea.x;
					var yOffset : Number = entity.area.y - focusArea.y;
					
					var renderer : EntityBitmapRenderer = _entityRendererFactory.getEntityRenderer(entity);
					renderer.updatePosition(xOffset, yOffset);
					
					var rectangle : Rectangle = renderer.area

					if (_display.bitmapData.rect.intersects(rectangle)) // will only render if it fits into (intersects) the display
					{
						renderer.copyTo(bitmapData);
						
						_position.x = _display.mouseX;
						_position.y = _display.mouseY;
						if (layerCounter > 0 && rectangle.containsPoint(_position))// do not consider the first layer as clickable/overable (TODO : make it configurable)
						{
							if (renderer.hitTest(_position))
							{
								_entityUnderMouse = entity;
							}
						}
					}
				}
				layerCounter ++;
			}
			
			bitmapData.unlock();
		}
		
		public function getEntityUnderMouse() : Entity
		{
			return _entityUnderMouse;
		}
	
		public function select(entity : Entity) : void
		{
			var entityBitmapRenderer : EntityBitmapRenderer = _entityRendererFactory.getEntityRenderer(entity);
			entityBitmapRenderer.selected = true;
		}
		
		public function unselect(entity : Entity) : void
		{
			var entityBitmapRenderer : EntityBitmapRenderer = _entityRendererFactory.getEntityRenderer(entity);
			entityBitmapRenderer.selected = false;
		}
		
		public function getWorldPositionFromScreen(x : Number, y : Number) : Point
		{
			return new Point(_world.focusArea.x + x, _world.focusArea.y + y);
		}
		
	}

}