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
	import as3.ayawaska.engine.renderer.bitmap.BitmapManager;
	import com.adobe.crypto.SHA1;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class SpriteSheetManager 
	{
		
		private var _spritesheets : Dictionary;
		private var _bitmapManager:BitmapManager;
		
		public function SpriteSheetManager(bitmapManager : BitmapManager = null) 
		{
			_spritesheets = new Dictionary;
			_bitmapManager = bitmapManager;
		}
		
		
		public function getSpriteSheet(assetNames : Vector.<String>) : SpriteSheet
		{
			assetNames.sort(0);
			var hash : String = SHA1.hash(String(assetNames));
			if (_spritesheets[hash] != null)
			{
				return _spritesheets[hash];
			}
			var spriteSheet : SpriteSheet = createSpriteSheetFromAnimatedBitmaps(assetNames);
			if (spriteSheet != null)
			{
				_spritesheets[hash] = spriteSheet;
			}
			return spriteSheet;
		}
		
		private function createSpriteSheetFromAnimatedBitmaps(assetNames : Vector.<String>):SpriteSheet 
		{
			if (_bitmapManager == null)
			{
				return null;
			}
			
			var animatedBitmap : AnimatedBitmap
			var bitmapFrame : BitmapFrame;
			var name : String;
			
			var state : String;
			var frame : Object;
			var allBitmapFrames : Dictionary;
			
			var maxHeight : uint = 0;
			var maxWidth : uint = 0;
			var counter : uint = 0;
			for each(name in assetNames)
			{
				animatedBitmap = _bitmapManager.getAnimatedBitmap(name);
				if (animatedBitmap == null)
				{
					trace("no animated bitmap loaded with the name " + name);
					return null;
				}
				
				allBitmapFrames = animatedBitmap.states;
				for (state in allBitmapFrames)
				{
					for each(frame in allBitmapFrames[state])
					{
						for each(bitmapFrame in frame)
						{
							maxWidth = Math.max(maxWidth, bitmapFrame.bitmapDataRectangle.width);
							maxHeight = Math.max(maxHeight, bitmapFrame.bitmapDataRectangle.height);
							counter ++;
						}
					}
				}
				
				
			}
			
			var diagonal : uint = Math.ceil(Math.sqrt(counter));
			
			var exactWidth : uint = diagonal * maxWidth;
			var exactHeight : uint = diagonal * maxHeight;
			
			var width : uint = nextPow2(exactWidth);
			var height : uint = nextPow2(exactHeight);
			
			var combinedBimtapData : BitmapData = new BitmapData(width, height, true, 0x00000000);

			var column : uint = 0;
			var row : uint = 0;
			var position : Point = new Point();
			
			var metadata : Object = new Object;
			for each(name in assetNames)
			{
				metadata[name] = new Object;
				
				animatedBitmap = _bitmapManager.getAnimatedBitmap(name);
				
				allBitmapFrames = animatedBitmap.states;
				for (state in allBitmapFrames)
				{
					metadata[name][state] = new Array();
					for each(frame in allBitmapFrames[state])
					{
						var rotationArray : Array = new Array();
						
						for each(bitmapFrame in frame)
						{
							if (column * maxWidth + bitmapFrame.bitmapDataRectangle.width > diagonal * maxWidth)
							{
								column = 0;
								row ++;
							}
							position.x = column * maxWidth;
							position.y = row * maxHeight;
							combinedBimtapData.copyPixels(bitmapFrame.bitmapData, bitmapFrame.bitmapDataRectangle, position);
							
							
							var frameMetdata : Object = new Object();
							frameMetdata["frame"] = { x:position.x, y:position.y, w: bitmapFrame.bitmapDataRectangle.width, h:bitmapFrame.bitmapDataRectangle.height };
							frameMetdata["spriteSourceSize"] = { x:0, y:0, w:bitmapFrame.bitmapDataRectangle.width, h:bitmapFrame.bitmapDataRectangle.height };
							frameMetdata["sourceSize"] = { w:bitmapFrame.bitmapDataRectangle.width, h:bitmapFrame.bitmapDataRectangle.height };
							frameMetdata["referencePoint"] = { x:bitmapFrame.referencePoint.x, y:bitmapFrame.referencePoint.y };
						
							rotationArray.push(frameMetdata);
							
							metadata[name][state].push(rotationArray)
							
							
							column ++;
						}
					}
				}
								
			}
			
			return new SpriteSheet(combinedBimtapData, metadata);
			
		}
		
		private function nextPow2(x : uint) : uint
		{
			x--;
			x |= x >> 1;
			x |= x >> 2;
			x |= x >> 4;
			x |= x >> 8;
			x |= x >> 16;
			x++;
			return x;
		}
		
		public function load(spriteSheetFileName : String, callback : Function) : void
		{
			// TODO : implement a json loader
		}
		
	}

}