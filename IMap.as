package {
	
	interface IMap {
		
		function setGround(px:int,py:int,ph:int,value:String):void;
		function hasGround(px:int,py:int,ph:int):Boolean;
		function getGroundObjects(px:int,py:int,ph:int):Object;
		function getWall(wallID:String):String;
		function get dirty():Boolean;
		function set dirty(value:Boolean):void;
		function getMap(xpos:int,ypos:int,hpos:int,idir:int,approach,mode:int):Array;
		function setWall(wallID:String,code:String):void;
		function sendMessage(message:Object):void;
	
	}
}