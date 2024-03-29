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
package
{
	import as3.ayawaska.engine.controller.SampleGameController;
	import as3.ayawaska.engine.core.GameController;
	import as3.ayawaska.engine.core.GameEngine;
	import as3.ayawaska.engine.core.Renderer;
	import as3.ayawaska.engine.renderer.bitmap.BitmapManager;
	import as3.ayawaska.engine.renderer.bitmap.BitmapRenderer;
	import as3.ayawaska.engine.renderer.bitmap.EntityBitmapRendererFactory;
	import as3.ayawaska.engine.renderer.displaylist.DisplayListRenderer;
	import as3.ayawaska.engine.renderer.molehill.twodimensions.EntityMolehill2DRendererFactory;
	import as3.ayawaska.engine.renderer.molehill.twodimensions.Molehill2DRenderer;
	import as3.ayawaska.engine.renderer.MouseEnabledRenderer2D;
	import as3.ayawaska.engine.world.twodimensions.SampleWorld2D;
	import as3.ayawaska.test.TestWorld;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Test3 extends Sprite 
	{
		private var gameEngine:GameEngine;
		private var bitmapManager:BitmapManager;
		
		public function Test3():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			//bitmapManager = new BitmapManager();
			
			var world : SampleWorld2D = new SampleWorld2D(stage.stageWidth * 2, stage.stageHeight * 2);
			world.setup();

			var renderer : MouseEnabledRenderer2D = new Molehill2DRenderer(stage, world, new EntityMolehill2DRendererFactory());
		
			var controller : GameController = new SampleGameController(renderer, stage);
			gameEngine = new GameEngine(world, renderer, controller);
			
			//bitmapManager.setupFromXml("assetsLibrary.xml", onBitmapPreloaded);
			//bitmapManager.loadMultipleAnimatedBitmap(["base", "grass", "tank09"], onBitmapPreloaded);
			onBitmapPreloaded(); //for now
			
		}
		
		private function onBitmapPreloaded():void 
		{
			gameEngine.start();
		}
		
	}
	
}