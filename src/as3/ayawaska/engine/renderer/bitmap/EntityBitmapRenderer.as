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
	import as3.ayawaska.engine.world.twodimensions.Entity2D;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;

	public class EntityBitmapRenderer
	{
		private var _entity : Entity2D;
		private var _animatedBitmap : AnimatedBitmap;
		
		private var _position : Point;
		
		private var _selected : Boolean;
		
		public function EntityBitmapRenderer(entity : Entity2D, animatedBitmap : AnimatedBitmap) //TODO clean :entity shoukld alredy be able to get the animatedbitmap via its type
		{
			_entity = entity;
			_animatedBitmap = animatedBitmap;	
			
			_position = new Point();
		}
		
		public function get area() : Rectangle
		{
			return bitmapFrame.getArea(_position);
		}
		
		
		private function get bitmapFrame() : BitmapFrame
		{
			return _animatedBitmap.getBitmapFrame(_entity.state, _entity.stateLifeTime, _entity.rotation);
		}
		
		public function copyTo(destination:BitmapData):void 
		{	
			bitmapFrame.copyTo(destination, _position);
			if (_selected)
			{
				//destination.colorTransform(area, new ColorTransform(1, 0, 0, 1, 0, 0, 0, 0));
			}
		}
		
		public function updatePosition(x:Number, y:Number):void 
		{
			_position.x = x;
			_position.y = y;
		}
		
		public function hitTest(position:Point): Boolean
		{
			return bitmapFrame.hitTest(_position, position);
		}
		
		public function get selected() : Boolean
		{
			return _selected;
		}
		
		public function set selected(value : Boolean) : void
		{
			_selected = value;
		}
		
	}

}