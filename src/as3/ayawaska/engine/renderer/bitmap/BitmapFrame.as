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
	public class BitmapFrame 
	{
		private var _bitmapData:BitmapData;
		private var _referencePoint:Point;
		
		public function BitmapFrame(bitmapData : BitmapData, referencePoint : Point) 
		{
			_bitmapData = bitmapData;
			_referencePoint = referencePoint;
		}
		
		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}
		
		public function get referencePoint() : Point
		{
			return _referencePoint;
		}
		
	}

}