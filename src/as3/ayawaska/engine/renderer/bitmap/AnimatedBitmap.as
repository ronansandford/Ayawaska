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
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class AnimatedBitmap 
	{
		
		private var _states : Dictionary; // a dictionnary of frames array containing themselves an array of rotations which cotnains themselves the bitmapData
		private var _generalAnimationSpeed : uint = 5; // should be replace by json information for each state
		
		public function AnimatedBitmap(spriteSheet : BitmapData, jsonObject : Object) 
		{
			_states = new Dictionary();
			
			var rectangle : Rectangle = new Rectangle();
			var position : Point = new Point();
			
			for (var stateName : String in jsonObject)
			{
				_states[stateName] = new Array();
				var state : Array = jsonObject[stateName];
				var frameCounter : uint = 0;
				for each (var frameArray : Array in state)
				{
					_states[stateName][frameCounter] = new Array(); 
					var rotationCounter : uint = 0;
					for each(var info : Object in frameArray)
					{
						var sourceSize : Object = info.sourceSize;
						var bitmapData : BitmapData = new BitmapData(sourceSize.w, sourceSize.h, true, 0x00000000);
						
						var frame : Object = info.frame;
						var spriteSourceSize : Object = info.spriteSourceSize;
						rectangle.x = frame.x;
						rectangle.y = frame.y;
						rectangle.width = frame.w;
						rectangle.height = frame.h;
						position.x = spriteSourceSize.x;
						position.y = spriteSourceSize.y;
						bitmapData.copyPixels(spriteSheet, rectangle, position);
						
						// TODO : generate rotations as option
						_states[stateName][frameCounter][rotationCounter] = bitmapData;
						rotationCounter ++;
					}
					frameCounter ++;
				}
			}
		}
		
		public function getBitmapData(state:String = "default", stateLifeTime:uint = 0, rotation:Number = 0):BitmapData
		{
			var frames : Array = _states[state];
			
			var numFrames : uint = frames.length;
			var interval : Number = 1000 / _generalAnimationSpeed;
			var frame : uint = Math.floor(stateLifeTime / interval ) % numFrames;
			
			var rotations : Array = frames[frame % frames.length];
			
			if (rotation != 0)
			{
				if (rotations.length == 1)
				{
					//trace("trying to get a rotated version of this bitmap but none are provided");
					return rotations[0];
				}
				if (rotation < 0)
				{
					rotation += (Math.PI * 2.0);
				}
				var rotationIndex : uint = Math.floor(rotation / ((Math.PI * 2.0) / Number(rotations.length)));
				return rotations[rotationIndex];
			}
			else
			{
				return rotations[0];
			}
		}

	}

}