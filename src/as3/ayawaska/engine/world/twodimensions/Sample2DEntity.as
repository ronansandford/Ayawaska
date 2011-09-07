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
package as3.ayawaska.engine.world.twodimensions 
{
	import as3.ayawaska.engine.core.Entity;
	import as3.ayawaska.engine.core.EntityType;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class Sample2DEntity implements Entity2D
	{
		private var _type : EntityType;
		private var _stateLifeTime : uint;
		
		private var _rectangle : Rectangle;
		private var _rotation:Number;
		
		private var _destination:Point;
		
		private var _vector : Point; // used for calculation
		
		
		public function Sample2DEntity(type : EntityType) 
		{
			_type = type;
			_stateLifeTime = 0;
			
			_rectangle = new Rectangle(0, 0, 30, 30);
			_rotation = 0;
			
			_destination = null;
			
			_vector = new Point();
		}
		
		//interface
		public function update(milisecondStep : int) : void
		{
			// actions (state machine, ...)
			_stateLifeTime += milisecondStep; // should be reset on new state
			
			if (_destination != null)
			{
				_vector.x = _rectangle.x;
				_vector.y = _rectangle.y;
				
				var increment : Number = type.speed * (milisecondStep / 1000.0);
				
				var deltaPoint : Point = _destination.subtract(_vector);
				if (deltaPoint.length < increment)
				{
					_rectangle.x = _destination.x;
					_rectangle.y = _destination.y;
					_destination = null;
				}
				else
				{
					deltaPoint.normalize(1);
					
					_rotation = Math.atan2(deltaPoint.y, deltaPoint.x);
					_rotation = Math.floor(_rotation / (Math.PI / 4.0)) * (Math.PI / 4.0); // TODO : the number of rotation could be taken from the asset
					_rectangle.x += increment * Math.cos(_rotation);
					_rectangle.y += increment * Math.sin(_rotation);
				}
			}
		}
		
		//interface
		public function get state() : String
		{
			return "default"; // TODO : state machine
		}
		
		//interface
		public function get type() : EntityType
		{
			return _type
		}
		
		//interface
		public function get stateLifeTime() : uint
		{
			return _stateLifeTime;
		}
		
		//interface
		public function get area() : Rectangle
		{
			return _rectangle;
		}
		
		//interface
		public function moveTo(destination : Point) : void
		{
			_destination = destination;
		}
		
		//interface
		public function get rotation() : Number
		{
			return _rotation;
		}
		
	}

}