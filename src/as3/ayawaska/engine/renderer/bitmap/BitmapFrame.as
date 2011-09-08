package as3.ayawaska.engine.renderer.bitmap 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	public class BitmapFrame 
	{
		private var _bitmapData:BitmapData;
		private var _referencePoint:Point;
		
		public function BitmapFrame(bitmapData : BitmapData, referencePoint : Point) 
		{
			_bitmapData = bitmapData;
			_referencePoint = referencePoint;
		}
		
		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}
		
		public function get referencePoint() : Point
		{
			return _referencePoint;
		}
		
	}

}