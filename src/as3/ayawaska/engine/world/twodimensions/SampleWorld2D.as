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
	import as3.ayawaska.engine.core.CollisionManager;
	import as3.ayawaska.engine.core.Entity;
	import as3.ayawaska.engine.core.EntityType;
	import flash.geom.Rectangle;

	public class SampleWorld2D implements World2D 
	{
		private var _collisionManager : CollisionManager;
		
		protected var _entities : Vector.<Vector.<Entity>>; // a 2d world contain 2d slots
		
		private var _width : int;
		private var _height : int;
		private var _focusArea : Rectangle;
		
		public function SampleWorld2D(collisionManager : CollisionManager, width : uint, height : uint) 
		{
			_entities = new Vector.<Vector.<Entity>>();
			_collisionManager = collisionManager;
			
			_width = width;
			_height = height;
			
			_focusArea = new Rectangle(0, 0, _width/2, _height/2);

		}
		
		// interface
		public function update(milisecondStep : int) : void
		{
			for each(var layer : Vector.<Entity> in _entities)
			{
				for each (var entity : Entity2D in layer)
				{
					entity.update(milisecondStep);
				
					// simple gravity
					var insideGround : Number = _height - entity.area.bottom;
					if (insideGround < 0) // world ground
					{
						//entity.area.y += insideGround;
					}
					else
					{
						//entity.area.y += Math.min(2, insideGround);
					}
				}
			}
			
			// simple camera
			//_focusArea.x += 1;
			//_focusArea.y += 1;
		}
		
		// interface
		public function get entities() : Vector.<Vector.<Entity>>
		{
			return _entities;//.slice(0, _entities.length); // clone the vector 
		}
		
		// interface
		public function get focusArea() : Rectangle
		{
			return _focusArea;
		}
		
		
		public function setup() : void
		{
			/*
			for (var i : int = 0; i < 1000; i++)
			{
				addEntity(new TestEntity(new SampleEntityType("grass")),Math.random() * _width, Math.random() * (_height - 400), 1);
			}
			*/
			for (var i : uint = 0; i < _width - 32; i+=32)
			{
				for (var j : uint = 0; j < _height - 32; j += 32)
				{
					addEntity(new Sample2DEntity(new SampleEntityType("grass")), i, j, 0);
				}
			}
			
			addEntity(new Sample2DEntity(new SampleEntityType("base")), 192, 192, 1);
			
			addEntity(new Sample2DEntity(new SampleEntityType("tank09")), 288, 192, 1);
			addEntity(new Sample2DEntity(new SampleEntityType("tank09")), 256, 192, 1);
			addEntity(new Sample2DEntity(new SampleEntityType("tank09")), 288, 234, 1);
			addEntity(new Sample2DEntity(new SampleEntityType("tank09")), 256, 234, 1);
			
			addEntity(new Sample2DEntity(new SampleEntityType("tank09")), 320, 234, 1);
			addEntity(new Sample2DEntity(new SampleEntityType("tank09")), 320, 192, 1);
			
		}
		
		private function addEntity(entity : Sample2DEntity, x : Number, y : Number, layer : uint = 0) : void
		{
			entity.area.x  = x;
			entity.area.y  = y;
			if (_entities.length <= layer)
			{
				for (var i : int = _entities.length; i <= layer; i++)
				{
					_entities[i] = new Vector.<Entity>();
				}
			}
			_entities[layer].push(entity);
		}
		
	}

}