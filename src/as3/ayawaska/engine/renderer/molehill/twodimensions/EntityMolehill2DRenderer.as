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
package as3.ayawaska.engine.renderer.molehill.twodimensions 
{
	import as3.ayawaska.engine.renderer.bitmap.AnimatedBitmap;
	import as3.ayawaska.engine.renderer.bitmap.BitmapFrame;
	import as3.ayawaska.engine.world.twodimensions.Entity2D;
	import as3.ayawaska.util.Profiler;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class EntityMolehill2DRenderer 
	{
		private var _entity:Entity2D;
		private var _animatedBitmap : AnimatedBitmap;
		
		private var _position : Point;
		private var _selected:Boolean;
		
		private var _lastBitmapFrame : BitmapFrame;
		private var left : Number;
		private var right : Number;
		private var top : Number;
		private var bottom : Number;
		private var _vertices : Vector.<Number>;
		private var _lastArea : Rectangle;
		private var _verticesByteArray: ByteArray;
		
		public function EntityMolehill2DRenderer(entity : Entity2D, animatedBitmap : AnimatedBitmap) 
		{
			_entity = entity;
			_animatedBitmap = animatedBitmap;
			
			_position = new Point();
			_vertices = new Vector.<Number>(16);
			_vertices.fixed = true;
			
			_verticesByteArray = new ByteArray();
			_verticesByteArray.length = 4 * 16;
		}
		
		public function updatePosition(x:Number, y:Number):void 
		{
			_position.x = x;
			_position.y = y;
		}
		
		private function get bitmapFrame() : BitmapFrame
		{
			return _animatedBitmap.getBitmapFrame(_entity.state, _entity.stateLifeTime, _entity.rotation);
		}
		
		public function get area() : Rectangle
		{
			return bitmapFrame.getArea(_position);
		}
		
		public function getVertices() : Vector.<Number>
		{			
			//caching to speed up
			if (bitmapFrame != _lastBitmapFrame)
			{
				//trace("frame changed");
				_lastBitmapFrame = bitmapFrame;
				
				left = _lastBitmapFrame.bitmapDataRectangle.left / _lastBitmapFrame.bitmapData.rect.width;
				right = _lastBitmapFrame.bitmapDataRectangle.right  / _lastBitmapFrame.bitmapData.rect.width;
				top = _lastBitmapFrame.bitmapDataRectangle.top / _lastBitmapFrame.bitmapData.rect.height;
				bottom = _lastBitmapFrame.bitmapDataRectangle.bottom / _lastBitmapFrame.bitmapData.rect.height;
				
				_vertices[2] = left;
				_vertices[3] = bottom;
				
				_vertices[6] = left;
				_vertices[7] = top;
				
				_vertices[10] = right;
				_vertices[11] = top;
				
				_vertices[14] = right;
				_vertices[15] = bottom;
			}
			
			var positionRectangle : Rectangle = area;
			
			_vertices[0] = positionRectangle.left;
			_vertices[1] = positionRectangle.bottom;
			
				
			_vertices[4] = positionRectangle.left;
			_vertices[5] = positionRectangle.top;

				
			_vertices[8] = positionRectangle.right;
			_vertices[9] = positionRectangle.top;

				
			_vertices[12] = positionRectangle.right;
			_vertices[13] = positionRectangle.bottom;


			return _vertices;
		}
		
		public function getVerticesByteArray() : ByteArray
		{			
			//caching to speed up
			if (bitmapFrame != _lastBitmapFrame)
			{
				//trace("frame changed");
				_lastBitmapFrame = bitmapFrame;
				
				left = _lastBitmapFrame.bitmapDataRectangle.left / _lastBitmapFrame.bitmapData.rect.width;
				right = _lastBitmapFrame.bitmapDataRectangle.right  / _lastBitmapFrame.bitmapData.rect.width;
				top = _lastBitmapFrame.bitmapDataRectangle.top / _lastBitmapFrame.bitmapData.rect.height;
				bottom = _lastBitmapFrame.bitmapDataRectangle.bottom / _lastBitmapFrame.bitmapData.rect.height;
				
				_verticesByteArray.position = 2 * 4;
				_verticesByteArray.writeFloat(left);
				_verticesByteArray.position = 3 * 4;
				_verticesByteArray.writeFloat(bottom);
				
				_verticesByteArray.position = 6 * 4;
				_verticesByteArray.writeFloat(left);
				_verticesByteArray.position = 7 * 4;
				_verticesByteArray.writeFloat(top);		
				
				_verticesByteArray.position = 10 * 4;
				_verticesByteArray.writeFloat(right);
				_verticesByteArray.position = 11 * 4;
				_verticesByteArray.writeFloat(top);
				
				_verticesByteArray.position = 14 * 4;
				_verticesByteArray.writeFloat(right);
				_verticesByteArray.position = 15 * 4;
				_verticesByteArray.writeFloat(bottom);
			}
			
			var positionRectangle : Rectangle = area;
			
			_verticesByteArray.position = 0 * 4;
			_verticesByteArray.writeFloat(positionRectangle.left);
			_verticesByteArray.position = 1 * 4;
			_verticesByteArray.writeFloat(positionRectangle.bottom);
			
			_verticesByteArray.position = 4 * 4;
			_verticesByteArray.writeFloat(positionRectangle.left);
			_verticesByteArray.position = 5 * 4;
			_verticesByteArray.writeFloat(positionRectangle.top);		
			
			_verticesByteArray.position = 8 * 4;
			_verticesByteArray.writeFloat(positionRectangle.right);
			_verticesByteArray.position = 9 * 4;
			_verticesByteArray.writeFloat(positionRectangle.top);
			
			_verticesByteArray.position = 12 * 4;
			_verticesByteArray.writeFloat(positionRectangle.right);
			_verticesByteArray.position = 13 * 4;
			_verticesByteArray.writeFloat(positionRectangle.bottom);
				
			return _verticesByteArray;
		}
		
		public function updateVertices(vertices:Vector.<Number>, drawnEntitiesNum:uint):void 
		{
			//caching to speed up
			if (bitmapFrame != _lastBitmapFrame)
			{
				//trace("frame changed");
				_lastBitmapFrame = bitmapFrame;
				
				left = _lastBitmapFrame.bitmapDataRectangle.left / _lastBitmapFrame.bitmapData.rect.width;
				right = _lastBitmapFrame.bitmapDataRectangle.right  / _lastBitmapFrame.bitmapData.rect.width;
				top = _lastBitmapFrame.bitmapDataRectangle.top / _lastBitmapFrame.bitmapData.rect.height;
				bottom = _lastBitmapFrame.bitmapDataRectangle.bottom / _lastBitmapFrame.bitmapData.rect.height;
			}
			
			var positionRectangle : Rectangle = area;
			
			var offset : uint = drawnEntitiesNum * 16;
			
			vertices[offset + 0] = positionRectangle.left;
			vertices[offset + 1] = positionRectangle.bottom;
			vertices[offset + 2] = left;
			vertices[offset + 3] = bottom;
				
			vertices[offset + 4] = positionRectangle.left;
			vertices[offset + 5] = positionRectangle.top;
			vertices[offset + 6] = left;
			vertices[offset + 7] = top;
				
			vertices[offset + 8] = positionRectangle.right;
			vertices[offset + 9] = positionRectangle.top;
			vertices[offset + 10] = right;
			vertices[offset + 11] = top;
				
			vertices[offset + 12] = positionRectangle.right;
			vertices[offset + 13] = positionRectangle.bottom;
			vertices[offset + 14] = right;
			vertices[offset + 15] = bottom;

		}
		
		
		public function hitTest(position:Point): Boolean
		{
			return bitmapFrame.hitTest(_position, position); //TODO : investigate whether there is any better way wioth molehill?
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