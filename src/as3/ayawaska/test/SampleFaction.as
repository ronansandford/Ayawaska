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

	public class SampleFaction implements Faction
	{
		
		private var _name : String;
		private var _color : uint;
		
		public function SampleFaction(name : String, color : uint) 
		{
			_name = name;
			_color = color;
		}
		
		public function get name() : String
		{
			return _name;
		}
		
		public function get color() : uint
		{
			return _color;
		}
		
	}

}