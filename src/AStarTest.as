package
{
	import flash.display.Sprite;
	
	/**
	 * A*寻路 算法 
	 * @author huangyc
	 * 
	 */	
	public class AStarTest extends Sprite
	{
		public function AStarTest()
		{
			init();
		}
		
		/**
		 * 测试 
		 * 
		 */		
		private function init():void{
			trace("Astar算法寻路");
			var mapInfo:Array = [[0,0,0,0,0],[0,1,0,1,0],[0,0,1,0,0],[0,0,0,0,0]];
			var astar:AStarRoute2 = new AStarRoute2(mapInfo, 0, 2, 3, 2);
			var res:Array = astar.getResult();
			trace(res.toString());
		}
	}
}