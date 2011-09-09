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
package as3.ayawaska.test 
{
	import as3.ayawaska.engine.core.Entity;
	import as3.ayawaska.engine.world.twodimensions.Entity2D;
	import as3.ayawaska.engine.world.twodimensions.SampleEntityType;
	import as3.ayawaska.engine.world.twodimensions.SampleWorld2D;
	
	public class TestWorld extends SampleWorld2D 
	{
		
		private var _hero : TestEntity;
		
		public function TestWorld(width : uint, height : uint) 
		{
			super(width, height);
			
			/*
			for (var i : int = 0; i < 1000; i++)
			{
				addEntity(new TestEntity(new SampleEntityType("grass")),Math.random() * _width, Math.random() * (_height - 400), 1);
			}
			*/
			for (var i : uint = 0; i < width - 32; i+=32)
			{
				for (var j : uint = 0; j < height - 32; j += 32)
				{
					addEntity(new TestEntity(new SampleEntityType("grass")), i, j, 0);
				}
			}
			
			addEntity(new TestEntity(new SampleEntityType("base")), 192, 192, 1);
			
			//addEntity(new TestEntity(new SampleEntityType("tank09")), 288, 192, 1);
			//addEntity(new TestEntity(new SampleEntityType("tank09")), 256, 192, 1);
			//addEntity(new TestEntity(new SampleEntityType("tank09")), 288, 234, 1);
			//addEntity(new TestEntity(new SampleEntityType("tank09")), 256, 234, 1);
			
			//addEntity(new TestEntity(new SampleEntityType("tank09")), 320, 234, 1);
			//addEntity(new TestEntity(new SampleEntityType("tank09")), 320, 192, 1);
			
			
			_hero = new TestEntity(new SampleEntityType("tank09"));
			
			addEntity(_hero, 320, 234, 1);
		}
		
		public function get hero() : TestEntity
		{
			return _hero;
		}
		
		private function addEntity(entity : TestEntity, x : Number, y : Number, layer : uint = 0) : void
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