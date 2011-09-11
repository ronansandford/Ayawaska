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
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class BitmapFrame 
	{
		private var _bitmapData:BitmapData;
		private var _referencePoint:Point;
		private var _bitmapDataRectangle:Rectangle;
		private var _originalPosition:Point;
		
		private var _lastX : Number;
		private var _lastY : Number;
		private var _lastRectangle : Rectangle;
		
		public function BitmapFrame(bitmapData : BitmapData, referencePoint : Point, bitmapDataRectangle : Rectangle = null, originalPosition : Point = null) 
		{
			_bitmapData = bitmapData;
			_referencePoint = referencePoint.clone();;
			
			if (bitmapDataRectangle == null)
			{
				_bitmapDataRectangle = _bitmapData.rect.clone(); 
			}
			else
			{
				_bitmapDataRectangle = bitmapDataRectangle.clone();;
			}
			
			if (originalPosition == null)
			{
				_originalPosition = new Point(0, 0);
			}
			else
			{
				_originalPosition = originalPosition.clone();
			}
			
			_lastRectangle = getArea(new Point(_lastX, _lastY));
		}
		
		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}
		
		public function get referencePoint() : Point
		{
			return _referencePoint;
		}
		
		public function get bitmapDataRectangle() : Rectangle
		{
			return _bitmapDataRectangle;
		}
		
		public function get originalPosition() : Point
		{
			return _originalPosition;
		}
		
		public function copyTo(bitmapData : BitmapData, position : Point) : void
		{
			bitmapData.copyPixels(_bitmapData, _bitmapDataRectangle, position.add(_originalPosition).subtract(_referencePoint));
		}
		
		public function hitTest(position:Point, position1:Point): Boolean
		{
			var positionInBitmapData : Point = new Point(_bitmapDataRectangle.x, _bitmapDataRectangle.y);
			return _bitmapData.hitTest(position.add(_originalPosition).subtract(_referencePoint), 0, position1.add(positionInBitmapData));
		}
		
		public function getArea(position:Point):Rectangle 
		{
			if (position.x != _lastX || position.y != _lastY)
			{
				var rectangle : Rectangle = new Rectangle();
				rectangle.x = position.x + _originalPosition.x - _referencePoint.x;
				rectangle.y = position.y + _originalPosition.y - _referencePoint.y;
				rectangle.width = _bitmapDataRectangle.width;
				rectangle.height = _bitmapDataRectangle.height;
				_lastRectangle = rectangle;
				_lastX = position.x;
				_lastY = position.y;
			}
			return _lastRectangle;
		}
		
		
		
	}

}