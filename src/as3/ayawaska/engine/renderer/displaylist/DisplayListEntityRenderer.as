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
	import as3.ayawaska.engine.world.twodimensions.Entity2D;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	
	public class DisplayListEntityRenderer
	{
		private var _entity : Entity2D;
		private var _shape : Shape;
		private var _display : DisplayObjectContainer;
		
		public function DisplayListEntityRenderer(entity : Entity2D, display:DisplayObjectContainer) 
		{
			_entity = entity;
			
			_display = display;
			
			var color : uint = 0x00FF00;
			if (entity.type.graphicalAssetName == "tank09")
			{
				color = 0xFF0000;
			}
			else if (entity.type.graphicalAssetName == "base")
			{
				color = 0x0000FF;
			}
			_shape = new Shape();
			_shape.graphics.beginFill(color);
			_shape.graphics.drawRect(0, 0, 32, 32);
			_shape.graphics.endFill();
			
			_display.addChild(_shape);
		}
		
		public function updatePosition(x : Number, y : Number, childIndex : uint) : void
		{
			_shape.x = x;
			_shape.y = y;
			var currentIndex : int = _display.getChildIndex(_shape);
			if (currentIndex != childIndex)
			{
				_display.setChildIndex(_shape, childIndex);
			}
		}
		
	}

}