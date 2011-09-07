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
	import as3.ayawaska.engine.core.GameEngine;
	import as3.ayawaska.engine.core.Renderer;
	import as3.ayawaska.engine.renderer.bitmap.BitmapManager;
	import as3.ayawaska.engine.renderer.bitmap.BitmapRenderer;
	import as3.ayawaska.engine.renderer.bitmap.EntityBitmapRendererFactory;
	import as3.ayawaska.engine.renderer.displaylist.DisplayListRenderer;
	import as3.ayawaska.engine.renderer.MouseEnabledRenderer2D;
	import as3.ayawaska.engine.world.twodimensions.SampleCollisionManager;
	import as3.ayawaska.test.TestGameController;
	import as3.ayawaska.test.TestWorld;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Test2 extends Sprite 
	{
		private var gameEngine:GameEngine;
		private var bitmapManager:BitmapManager;
		
		public function Test2():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var bitmapData : BitmapData = new BitmapData(stage.stageWidth, stage.stageHeight, false);
			var bitmap : Bitmap = new Bitmap(bitmapData);
			var bitmapContainer : Sprite = new Sprite();
			bitmapContainer.addChild(bitmap);
			stage.addChild(bitmapContainer);
			
			
			bitmapManager = new BitmapManager();
			
			var world : TestWorld = new TestWorld(new SampleCollisionManager(), stage.stageWidth * 2, stage.stageHeight * 2);
			
			var renderer : MouseEnabledRenderer2D = new BitmapRenderer(world, bitmap, new EntityBitmapRendererFactory(bitmapManager));
			//var sprite : Sprite = new Sprite();
			//stage.addChild(sprite);
			//var renderer : MouseEnabledRenderer2D = new DisplayListRenderer(world, sprite);
			
			var controller : TestGameController = new TestGameController(renderer, bitmapContainer, world.hero, world);
			
			gameEngine = new GameEngine(world, renderer, controller);
			
			bitmapManager.loadMultipleAnimatedBitmap(["base", "grass", "tank09"], onBitmapPreloaded);
			
		}
		
		private function onBitmapPreloaded():void 
		{
			gameEngine.start();
		}
		
	}
	
}