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
	import as3.ayawaska.engine.renderer.bitmap.BitmapFrame;
	import as3.ayawaska.engine.renderer.bitmap.SpriteSheet;
	import as3.ayawaska.engine.renderer.bitmap.SpriteSheetManager;
	import as3.ayawaska.util.Profiler;
	import com.adobe.utils.AGALMiniAssembler;
	import as3.ayawaska.engine.core.Entity;
	import as3.ayawaska.engine.renderer.MouseEnabledRenderer2D;
	import as3.ayawaska.engine.world.twodimensions.Entity2D;
	import as3.ayawaska.engine.world.twodimensions.World2D;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.textures.Texture;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class Molehill2DRenderer implements MouseEnabledRenderer2D 
	{
		private var _width:Number = 700;
		private var _height:Number = 600;
		
		private var _context3D:Context3D;
		private var _shaderProgram:Program3D;
		
		private var _vertexBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		private var _indices : Vector.<uint>
		
		private var _viewMatrix:Matrix3D;
		private var _ready:Boolean;
		private var _entityRendererFactory: EntityMolehill2DRendererFactory;
		private var _entityUnderMouse:Entity;
		private var _world: World2D;
		private var _position: Point;
		private var _stage: Stage;
		private var _spriteSheetManager:SpriteSheetManager;
		private var _texture:Texture;
		private var _spriteSheet:SpriteSheet;
		private var _maxEntitiesNum: uint = 500;
		
		private var _entitiesVertices : Vector.<Number>;
		private var layer0Done: Boolean;
		
		
		public function Molehill2DRenderer(stage : Stage, width : uint, height : uint, world : World2D, entityRendererFactory : EntityMolehill2DRendererFactory, spriteSheetManager : SpriteSheetManager) 
		{
			_ready = false;
			
			_stage = stage;
			_world = world;
			
			_spriteSheetManager = spriteSheetManager;
			_entityRendererFactory = entityRendererFactory;
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
			
			_width = width;
			_height = height;
			
			var stage3D:Stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, initialize);
			stage3D.requestContext3D(Context3DRenderMode.AUTO);
			
			
			//stage3D.viewPort = new Rectangle(0, 0, _width, _height);
			
			
			_position = new Point();
		}
		
		private function initialize(e:Event):void 
		{
			var stage3D:Stage3D = e.target as Stage3D;
			
			_context3D = stage3D.context3D;
			if (_context3D == null)
			{
				trace("oh no, context is null!");
				return;
			}
			
			_context3D.enableErrorChecking = true;
			
			trace(_context3D.driverInfo);
			try
			{
				_context3D.configureBackBuffer(_width, _height, 4, true);		
			}
			catch (e:Error)
			{
				trace(e);
			}
			
			
			//compile vertex shader
			var vertexShader:Array =
			[
				"m44 op, va0, vc0", //4x4 matrix transform from 0 to output clipspace
				"mov v0, va1"    //copy texcoord from 1 to fragment program
			];
			var vertexAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			vertexAssembler.assemble(flash.display3D.Context3DProgramType.VERTEX, vertexShader.join("\n"));
			
			//compile fragment shader
			var fragmentShader:Array =
			[
				"mov ft0, v0",
				"tex ft1, ft0, fs1 <2d,clamp,linear>", //sample texture 1		
				"mov oc, ft1"
			];
			//var fragmentShader:Array =
			//[
			//	"mov oc, v0"
			//];
			var fragmentAssembler:AGALMiniAssembler = new AGALMiniAssembler();
			fragmentAssembler.assemble(Context3DProgramType.FRAGMENT, fragmentShader.join("\n"));
			
			_shaderProgram = _context3D.createProgram();
			_shaderProgram.upload(vertexAssembler.agalcode, fragmentAssembler.agalcode);	
            
            _viewMatrix = new Matrix3D();

			_viewMatrix.appendTranslation( -(_width * 0.5), -(_height * 0.5) , 0);
            _viewMatrix.appendScale( 1 / (_width * 0.5), -1 / (_height * 0.5), 1 );
			
			_context3D.setProgram(_shaderProgram);
			
			_context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, _viewMatrix, true);
			
			_context3D.setDepthTest(false, Context3DCompareMode.NOT_EQUAL);
            _context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			
			
			// since all entities are squares we do not need to upload the indices only one but draw only alimited of them every time
			_indexBuffer = _context3D.createIndexBuffer(_maxEntitiesNum * 6);
			_indices = new Vector.<uint>();
			for (var i : uint  = 0; i < _maxEntitiesNum; i++)
			{
				//0, 1, 2, 0, 2, 3
				_indices.push(i * 4 + 0);
				_indices.push(i * 4 + 1);
				_indices.push(i * 4 + 2);
				_indices.push(i * 4 + 0);
				_indices.push(i * 4 + 2);
				_indices.push(i * 4 + 3);
			}
			_indices.fixed = true;
			_indexBuffer.uploadFromVector(_indices, 0, _indices.length);
			
			
			var assets : Vector.<String> = Vector.<String>(["grass", "grass2", "SmallCluffSnail", "SmallEdSnail", "fire"]);
			_spriteSheet = _spriteSheetManager.getSpriteSheet(assets);
			initTexture(_spriteSheet.bitmapData);
			
			_ready = true;
			
			_entitiesVertices = new Vector.<Number>(_maxEntitiesNum);
		}
		
		public function initTexture(bitmapData : BitmapData) : void
		{
			_texture = _context3D.createTexture(bitmapData.width, bitmapData.height, Context3DTextureFormat.BGRA, false);
			_texture.uploadFromBitmapData(bitmapData);
			_context3D.setTextureAt(1, _texture);
		}
		
		//interface
		public function update(milisecondStep:int):void 
		{	
			if (!_ready)
			{
				return;
			}
			
			
			Profiler.tick("setVertices");
			
			// re initialize
			_entityUnderMouse = null;
			
			
			var entitiesVerticesByteArray : ByteArray = new ByteArray();
			var drawnEntitiesNum : uint = 0;
			
			var entities : Vector.<Vector.<Entity>> = _world.entities;
			
			var focusArea : Rectangle = _world.focusArea;
			
			var layerCounter : uint = 0;
			for each(var layer : Vector.<Entity> in entities)
			{
				if (layerCounter == 0)
				{
					if (layer0Done) 
					{
						layerCounter ++;
						continue;
					}
					//else layer0Done = true;
				}
				for each (var entity : Entity2D in layer)
				{
					//Profiler.tick("setupEntityRenderer");
					
					var xOffset : Number = entity.area.x - focusArea.x;
					var yOffset : Number = entity.area.y - focusArea.y;
					
					var renderer : EntityMolehill2DRenderer = _entityRendererFactory.getEntityRenderer(entity);
					renderer.updatePosition(xOffset, yOffset);
					
					var rectangle : Rectangle = renderer.area
				
					//Profiler.tick("setupEntityRenderer");
					
					if (rectangle.x > -rectangle.width && rectangle.x < _width && rectangle.y > -rectangle.height && rectangle.y < _height ) // will only render if it fits into (intersects) the display
					{
						//Profiler.tick("addVertices");
						//entitiesVertices = entitiesVertices.concat(renderer.getVertices());
						renderer.updateVertices(_entitiesVertices, drawnEntitiesNum);
						//var verticesByteArray : ByteArray = renderer.getVerticesByteArray();
						//entitiesVerticesByteArray.writeBytes(verticesByteArray);
						//Profiler.tick("addVertices");
						
						drawnEntitiesNum++;
						
						//Profiler.tick("mouseOver");
						_position.x = _stage.mouseX;
						_position.y = _stage.mouseY;
						if (layerCounter > 0 && rectangle.containsPoint(_position))// do not consider the first layer as clickable/overable (TODO : make it configurable)
						{
							if (renderer.hitTest(_position))
							{
								_entityUnderMouse = entity;
							}
						}
						//Profiler.tick("mouseOver");
					}
					
					
				}
				layerCounter ++;
			}
			
			Profiler.tick("setVertices");
			
			//Profiler.traceTotal("addVertices");
			//Profiler.reset("addVertices");
			
			//Profiler.traceTotal("mouseOver");
			//Profiler.reset("mouseOver");
			
			
			
			Profiler.tick("setBuffers");
			_vertexBuffer = _context3D.createVertexBuffer(_entitiesVertices.length /4, 4);
			_vertexBuffer.uploadFromVector(
				_entitiesVertices
				, 0, _entitiesVertices.length /4
			);
			
			//_vertexBuffer = _context3D.createVertexBuffer(drawnEntitiesNum * 4, 4);
			//_vertexBuffer.uploadFromByteArray(
			//				entitiesVerticesByteArray
			//				, 0, 0, drawnEntitiesNum * 4
			//			);
			
			
			_context3D.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); //xy
			_context3D.setVertexBufferAt(1, _vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); //uv
			
			_indexBuffer = _context3D.createIndexBuffer(drawnEntitiesNum * 6);
			_indexBuffer.uploadFromVector(_indices.slice(0, drawnEntitiesNum * 6), 0, drawnEntitiesNum * 6);
			
			Profiler.tick("setBuffers");
			
			Profiler.tick("drawTriangles");
			_context3D.clear();
			_context3D.drawTriangles(_indexBuffer, 0, drawnEntitiesNum * 2); // since all entities are squares we do not need to upload a new indices vectro every time
			_context3D.present();
			Profiler.tick("drawTriangles");
			
			
			//Profiler.tick("context3d");
		}
		
		//interface
		public function getWorldPositionFromScreen(x:Number, y:Number):Point 
		{
			return new Point(_world.focusArea.x + x, _world.focusArea.y + y);
		}
		
		//interface
		public function getEntityUnderMouse():Entity 
		{
			return _entityUnderMouse;
		}
		
		//interface
		public function select(entity:Entity):void 
		{
			
		}
		
		//interface
		public function unselect(entity:Entity):void 
		{
			
		}
		
	}

}