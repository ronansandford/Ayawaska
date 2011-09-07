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
	import as3.ayawaska.engine.core.EntityType;
	
	public class SampleEntityType implements EntityType 
	{
		private var _name : String;
		
		public function SampleEntityType(name : String) 
		{
			_name = name;
		}
		
		public function get graphicalAssetName() : String
		{
			return _name; // for now graphical asset equal type name, TODO : complexify ?
		}
		
		public function get speed() : Number
		{
			return 60; 
		}
		
	}

}