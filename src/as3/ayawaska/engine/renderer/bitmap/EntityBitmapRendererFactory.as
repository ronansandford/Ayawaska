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
	import as3.ayawaska.engine.core.Entity;
	import as3.ayawaska.engine.core.Renderer;
	import as3.ayawaska.engine.world.twodimensions.Entity2D;
	import flash.utils.Dictionary;
	
	public class EntityBitmapRendererFactory
	{
		private var _bitmapManager : BitmapManager;
		private var _entityRenderers : Dictionary;
		
		public function EntityBitmapRendererFactory(bitmapManager : BitmapManager) 
		{
			_bitmapManager = bitmapManager;
			_entityRenderers = new Dictionary(true); // use weak keys so that when the slot are garbage collected their renderer are removed as well
		}
		
		public function getEntityRenderer(entity : Entity): EntityBitmapRenderer
		{
			var renderer : EntityBitmapRenderer = _entityRenderers[entity];
			if (renderer == null)
			{
				if (entity is Entity2D)
				{
					var bitmapName : String = entity.type.graphicalAssetName;
					renderer = new EntityBitmapRenderer(Entity2D(entity), _bitmapManager.getAnimatedBitmap(bitmapName));
					_entityRenderers[entity] = renderer;
				}
			}
			return renderer;
		}
		
	}

}