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
package as3.ayawaska.engine.renderer.molehill.twodimensions 
{
	import as3.ayawaska.engine.world.twodimensions.Entity2D;
	import flash.utils.Dictionary;

	public class EntityMolehill2DRendererFactory 
	{
		private var _entityRenderers: Dictionary;
		
		public function EntityMolehill2DRendererFactory() 
		{
			_entityRenderers = new Dictionary(true);
		}
		
		public function getEntityRenderer(entity : Entity2D): EntityMolehill2DRenderer
		{
			var renderer : EntityMolehill2DRenderer = _entityRenderers[entity];
			if (renderer == null)
			{
				var bitmapName : String = entity.type.graphicalAssetName;
				renderer = new EntityMolehill2DRenderer(entity);
				_entityRenderers[entity] = renderer;
			}
			return renderer;
		}
		
	}

}