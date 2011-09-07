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
	import as3.ayawaska.engine.world.twodimensions.Entity2D;
	import flash.geom.Rectangle;

	public class EntityMolehill2DRenderer 
	{
		private var _entity:Entity2D;
		private var _rectangle : Rectangle;
		
		public function EntityMolehill2DRenderer(entity : Entity2D) 
		{
			_entity = entity;
			
			_rectangle = new Rectangle(0,0, 32, 32); // for now use 30,30
		}
		
		public function updatePosition(x:Number, y:Number):void 
		{
			_rectangle.x = x;
			_rectangle.y = y;
		}
		
		public function get area() : Rectangle
		{
			return _rectangle;
		}
		
	}

}