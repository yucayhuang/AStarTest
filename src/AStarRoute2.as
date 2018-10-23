package 
{
	public class AStarRoute2 {
		
		private var map:Array;  // 地图矩阵，0表示能通过，1表示不能通过 //int[][]
		private var map_w:int;    // 地图宽度
		private var map_h:int;    // 地图高度
		private var start_x:int;  // 起点坐标X
		private var start_y:int;  // 起点坐标Y
		private var goal_x:int;   // 终点坐标X
		private var goal_y:int;   // 终点坐标Y
		
		private var closeList:Array;            // 关闭列表 //boolean[][]
		public  var openList:Array;               // 打开列表 //int[][][]
		private var openListLength:int;
		
		private static const EXIST:int = 1;
		private static const NOT_EXIST:int = 0;
		
		private static const ISEXIST:int = 0;  
		private static const EXPENSE:int = 1;     // 自身的代价
		private static const DISTANCE:int = 2;    // 距离的代价
		private static const COST:int = 3;        // 消耗的总代价
		private static const FATHER_DIR:int = 4;  // 父节点的方向
		
		public static const DIR_NULL:int = 0;
		public static const DIR_DOWN:int = 1;     // 方向：下
		public static const DIR_UP:int = 2;       // 方向：上
		public static const DIR_LEFT:int = 3;     // 方向：左
		public static const DIR_RIGHT:int = 4;    // 方向：右
		public static const DIR_UP_LEFT:int = 5;
		public static const DIR_UP_RIGHT:int = 6;
		public static const DIR_DOWN_LEFT:int = 7;
		public static const DIR_DOWN_RIGHT:int = 8;
		
		private var astar_counter:int;                // 算法嵌套深度
		private var isFound:Boolean;                  // 是否找到路径
		
		public function AStarRoute2(mp:Array, sx:int, sy:int, gx:int, gy:int){
			start_x = sx;
			start_y = sy;
			goal_x  = gx;
			goal_y  = gy;
			map     = mp;
			map_w   = mp.length;
			map_h   = mp[0].length;
			astar_counter = 5000;
			initCloseList();
			initOpenList(goal_x, goal_y);
		}
		
		// 得到地图上这一点的消耗值
		private function getMapExpense(x:int, y:int, dir:int):int
		{
			if(dir < 5){
				return 10;
			}else{
				return 14;
			}
		}
		
		// 得到距离的消耗值
		private function getDistance(x:int, y:int, ex:int, ey:int):int
		{
			return 10 * (Math.abs(x - ex) + Math.abs(y - ey));
		}
		
		// 得到给定坐标格子此时的总消耗值
		private function getCost(x:int, y:int):int
		{
			return openList[x][y][COST];
		}
		
		// 开始寻路
		public function searchPath():void
		{
			addOpenList(start_x, start_y);
			aStar(start_x, start_y);
		}
		
		// 寻路
		private function aStar(x:int, y:int):void
		{
			// 控制算法深度
			for(var t:int = 0; t < astar_counter; t++){
				if(((x == goal_x) && (y == goal_y))){
					isFound = true;
					return;
				}
				else if((openListLength == 0)){
					isFound = false;
					return;
				}
				
				removeOpenList(x, y);
				addCloseList(x, y);
				trace("当前节点：",x+1,y+1);
				// 该点周围能够行走的点
				addNewOpenList(x, y, x, y + 1, DIR_UP);
				addNewOpenList(x, y, x, y - 1, DIR_DOWN);
				addNewOpenList(x, y, x - 1, y, DIR_RIGHT);
				addNewOpenList(x, y, x + 1, y, DIR_LEFT);
//				addNewOpenList(x, y, x + 1, y + 1, DIR_UP_LEFT);
//				addNewOpenList(x, y, x - 1, y + 1, DIR_UP_RIGHT);
//				addNewOpenList(x, y, x + 1, y - 1, DIR_DOWN_LEFT);
//				addNewOpenList(x, y, x - 1, y - 1, DIR_DOWN_RIGHT);
				
				// 找到估值最小的点，进行下一轮算法
				var closeListTemp:Array = [];
				var cost:int = 0x7fffffff;
				for(var i:int = 0; i < map_w; i++){
					for(var j:int = 0; j < map_h; j++){
						if(openList[i][j][ISEXIST] == EXIST){
							trace("openList:",i+1,j+1, openList[i][j][COST], openList[i][j][EXPENSE], openList[i][j][DISTANCE], openList[i][j][FATHER_DIR]);
							if(cost > getCost(i, j)){
								cost = getCost(i, j);
								x = i;
								y = j;
							}
						}
						if(closeList[i][j] == true)
							closeListTemp.push((i+1)+","+(j+1));
					}
				}
				trace("closeList:",closeListTemp.toString());
				trace("------------------------------------------")
			}
			// 算法超深
			isFound = false;
			return;
		}
		
		// 添加一个新的节点
		private function addNewOpenList(x:int, y:int, newX:int, newY:int, dir:int):void
		{
			if(isCanPass(newX, newY)){
				if(openList[newX][newY][ISEXIST] == EXIST){
					trace("已存在节点:", newX+1, newY+1);
					if(openList[x][y][EXPENSE] + getMapExpense(newX, newY, dir) < 
						openList[newX][newY][EXPENSE]){
						trace("已存在节点变向:", openList[newX][newY][EXPENSE], openList[x][y][EXPENSE] + getMapExpense(newX, newY, dir));
						setFatherDir(newX, newY, dir);
						setCost(newX, newY, x, y, dir);
					}
				}else{
					trace("添加新节点：", newX+1, newY+1);
					addOpenList(newX, newY);
					setFatherDir(newX, newY, dir);
					setCost(newX, newY, x, y, dir);
				}
			}
		}
		
		// 设置消耗值
		private function setCost(x:int, y:int, ex:int, ey:int, dir:int):void
		{
			openList[x][y][EXPENSE] = openList[ex][ey][EXPENSE] + getMapExpense(x, y, dir);
			openList[x][y][DISTANCE] = getDistance(x, y, ex, ey);
			openList[x][y][COST] = openList[x][y][EXPENSE] + openList[x][y][DISTANCE];
		}
		
		// 设置父节点方向
		private function setFatherDir(x:int, y:int, dir:int):void
		{
			openList[x][y][FATHER_DIR] = dir;
		}
		
		// 判断一个点是否可以通过
		private function isCanPass(x:int, y:int):Boolean
		{
			// 超出边界
			if(x < 0 || x >= map_w || y < 0 || y >= map_h){
				return false;
			}
			// 地图不通
			if(map[x][y] != 0){
				return false;
			}
			// 在关闭列表中
			if(isInCloseList(x, y)){
				return false;
			}
			return true;
		}
		
		// 移除打开列表的一个元素
		private function removeOpenList(x:int, y:int):void
		{
			if(openList[x][y][ISEXIST] == EXIST){
				openList[x][y][ISEXIST] = NOT_EXIST;
				openListLength--;
			}
		}
		
		// 判断一点是否在关闭列表中
		private function isInCloseList(x:int, y:int):Boolean
		{
			return closeList[x][y];
		}
		
		// 添加关闭列表
		private function addCloseList(x:int, y:int):void
		{
			closeList[x][y] = true;
		}
		
		// 添加打开列表
		private function addOpenList(x:int, y:int):void
		{
			if(openList[x][y][ISEXIST] == NOT_EXIST){
				openList[x][y][ISEXIST] = EXIST;
				openListLength++;
			}
		}
		
		// 初始化关闭列表
		private function initCloseList():void
		{
			closeList = [];//new Array[map_w][map_h];//boolean
			for(var i:int = 0; i < map_w; i++){
				for(var j:int = 0; j < map_h; j++){
					if(!closeList[i])
						closeList[i] = [];
					closeList[i][j] = false;
				}
			}
		}
		
		// 初始化打开列表
		private function initOpenList(ex:int, ey:int):void
		{
			openList  = [];//new int[map_w][map_h][5];
			for(var i:int = 0; i < map_w; i++){
				for(var j:int = 0; j < map_h; j++){
					if(!openList[i])
						openList[i] = [];
					if(!openList[i][j])
						openList[i][j] = [];
					openList[i][j][ISEXIST] = NOT_EXIST;
					openList[i][j][EXPENSE] = getMapExpense(i, j, DIR_NULL);
					openList[i][j][DISTANCE] = getDistance(i, j, ex, ey);
					openList[i][j][COST] = openList[i][j][EXPENSE] + openList[i][j][DISTANCE];
					openList[i][j][FATHER_DIR] = DIR_NULL;
				}
			}
			openListLength = 0;
		}
		
		// 获得寻路结果
		public function getResult():Array{ //route_pt[] 
			var route:Array;
			searchPath();
			if(! isFound){
				return null;
			}
			route = [];
			// openList是从目标点向起始点倒推的。
			var iX:int = goal_x;
			var iY:int = goal_y;
			while((iX != start_x || iY != start_y)){
				route.push((iX+1)*10 + (iY+1));
				switch(openList[iX][iY][FATHER_DIR]){
					case DIR_DOWN:          iY++;            break;
					case DIR_UP:            iY--;            break;
					case DIR_LEFT:          iX--;            break;
					case DIR_RIGHT:         iX++;            break;
//					case DIR_UP_LEFT:       iX--;   iY--;    break;
//					case DIR_UP_RIGHT:      iX++;   iY--;    break;
//					case DIR_DOWN_LEFT:     iX--;   iY++;    break;
//					case DIR_DOWN_RIGHT:    iX++;   iY++;    break;
				}
			}
			return reverse(route);
		}
		
		/**
		 * 倒序 
		 * @param arr
		 * @return 
		 * 
		 */		
		private function reverse(arr : Array):Array{
			var arr2:Array = [];
			if(arr && arr.length>0){
				var len:int = arr.length;
				while(len > 1){//不包含终点
					arr2.push(arr[len-1]);
					len --;
				}
			}
			return arr2;
		}
	}
}