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
	import flash.utils.Dictionary;
	import org.assetloader.AssetLoader;
	import org.assetloader.base.Param;
	import org.assetloader.core.IAssetLoader;
	import org.assetloader.core.ILoader;
	import org.assetloader.signals.ErrorSignal;
	import org.assetloader.signals.LoaderSignal;

	public class BitmapManager 
	{
		private static const BASEPATH : String = "file:///C:/Development/GJAM/TheSecretOfAlchemy/trunk/bin/assets/"; // need full path for molehill player
		
		private var _animatedBitmaps : Dictionary;
		
		public function BitmapManager() 
		{
			_animatedBitmaps = new Dictionary();
		}
		
		public function getAnimatedBitmap(name:String):AnimatedBitmap 
		{
			var animatedBitmap : AnimatedBitmap = _animatedBitmaps[name];
			if (animatedBitmap != null)
			{
				return animatedBitmap;
			}
			else
			{
				// try to get it ?
				// TODO get the animated bitmap from a actual file : need an assetManager/loaderManager
				return null; // return a laoding placeholder ?
			}
		}
		
		public function loadMultipleAnimatedBitmap(names: Array, callback : Function = null) : void
		{
			
			var mainLoader : AssetLoader = new AssetLoader();
			
			// Child loaders will inherit params.
			mainLoader.setParam(Param.BASE, BASEPATH );
			
			for each(var name : String in names)
			{
				var subLoader : AssetLoader = new AssetLoader(name);
				subLoader.setParam(Param.BASE, BASEPATH);
				subLoader.addLazy("bitmap", name + ".png");
				subLoader.addLazy("info", name + ".json");
				mainLoader.addLoader(subLoader);
			}
			
			mainLoader.onChildComplete.add(
					function(signal : LoaderSignal, childLoader : ILoader) : void {
						var bitmapData : BitmapData = AssetLoader(childLoader).getAsset("bitmap").bitmapData;
						var info : Object = AssetLoader(childLoader).getAsset("info");
						//var bitmapData : BitmapData = assets["bitmap"].bitmapData;
						//var info : Object = assets["info"];
						var animatedBitmap : AnimatedBitmap = new AnimatedBitmap(bitmapData, info);
						_animatedBitmaps[childLoader.id] = animatedBitmap;
					}
				);
			
			mainLoader.onComplete.add(
				function(signal : LoaderSignal, assets : Dictionary) : void {
					callback();
				}
			);
			
			mainLoader.onError.add(
				function(signal : ErrorSignal) : void {
					trace(signal.message);
					callback();
				});
			
			mainLoader.onChildError.add(
				function(signal : ErrorSignal, loader : ILoader) : void {
					trace(signal.message);
				});
				
			mainLoader.start();
		} 
		
	}

}