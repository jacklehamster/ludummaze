package {
	import flash.geom.Point;
	import flash.system.Security;
	
	public class Map implements IMap {

		protected var grounds:Object = {};
		protected var walls:Object = {};
		protected var securedomains:Object = {};
		
		public function hasGround(px:int,py:int,ph:int):Boolean {
			var id:String = px+"|"+py+"|"+ph;
			if(id in grounds)
				return getGround(px,py,ph) && getGroundObjects(px,py,ph).G;
			var mt:int = (px^py)+1;//^(hi+hpos);
			return !mt||Math.abs(Math.abs(mt))%13;
		}

		public function getWall(wallID:String):String {
			return walls[wallID];
		}
		
		public function sendMessage(message:Object):void {
			
		}
		
		public function setWall(wallID:String,code:String):void {
			//trace(wallID,code);
			walls[wallID] = code;
			var idsplit = wallID.split("|");
			setGround(idsplit[1],idsplit[2],0,null);
			dirty = true;
		}
		
		public function getGround(px:int,py:int,ph:int):String {
			var id:String = px+"|"+py+"|"+ph;
			return grounds[id];
		}
		
		public function setGround(px:int,py:int,ph:int,value:String):void {
			var id:String = px+"|"+py+"|"+ph;
			if(grounds[id]!=value)
				grounds[id] = value;
			dirty = true;
		}

		public function getGroundObjects(px:int,py:int,ph:int):Object {
			var str = getGround(px,py,ph);
			if(!str)
				return null;
				//trace(str);
			var list = str.split("|");
			var obj:Object = {};
			for(var i=0;i<list.length;i++) {
				var entry = list[i].split("@");
				var loc:String = entry[1]?entry[1].charAt(0):'G';
				if(!obj[loc])
					obj[loc] = [];
				var objsplit = entry[0].split(":");
				var o = null;
				switch(objsplit[objsplit.length-1]) {
					case "M":	//	don't load. only for minimap
						o = null;
						break;
					default:
					case "U":	//	youtube bideo
					//-1,2,0,F,F|e-1|2|0,#|-1|3|N,FrontWall,loadwall,https://5466333522733975465-a-1802744773732722657-s-sites.googlegroups.com/site/jacklehamster/archive/graph.swf
						break;
					case "H":	//	hardcoded
						o = objsplit[0];
						break;
				}
				if(o) {
					var en = [o].concat(entry[1]?entry[1].substr(1).split(","):[0,0]);
					obj[loc].push(en);					
				}
			}
			return obj;
		}
		
		static function transcode(xd:int,yd:int,xyd:int,yxd:int,xx:int,yy:int) {
			var xpart:int = xx*xd+yy*xyd;
			var ypart:int = yy*yd+xx*yxd;
			return xpart<0?'E':xpart>0?'W':ypart<0?'N':ypart>0?'S':'';
		}
		
		var _dirty = false;
		public function get dirty():Boolean {
			return _dirty;
		}

		public function set dirty(value:Boolean):void {
			_dirty = value;
		}
		
		public function getMap(xpos:int,ypos:int,hpos:int,idir:int,approach,mode:int):Array {
			var array:Array = [];
			
			var xd:int, yd:int, xyd:int, yxd:int;
			switch(idir) {
				case 0: xd=1;yd=1;xyd=0;yxd=0;break;
				case 1: xd=0;yd=0;xyd=1;yxd=-1; break;
				case 2: xd=-1;yd=-1;xyd=0;yxd=0; break;
				case 3: xd=0;yd=0;xyd=-1;yxd=1; break;
			}
			var ylimit:int = approach?0:2+(mode==1?1:0);
			var SIDE4:Array = [['L',new Point(-1,0)],['R',new Point(1,0)],['F',new Point(0,-1)],['B',new Point(0,1)]];
			
			for(var yi=approach||mode==2?-1:0;yi<=ylimit;yi++) {
				var xlimit:int = approach?0:2+Math.max(0,yi*2)+(mode==2?3:0);
				for(var xi=-xlimit;xi<=xlimit;xi++) {
					var px:int = xi*xd+yi*xyd+xpos;
					var py:int = yi*yd+xi*yxd+ypos;
					var ph:int = hpos;
					var gid:String = ["#",px,py].join("|");
					
					if(hasGround(px,py,ph)) {
						
						array.push([xi,yi,-1,'D',['D',xi,yi,-1].join("|"),gid+"|F","Block"]);
						var ixp, iyp, xxp, yyp;
						//if(mode==1)
							//array.push([xi,yi, 1,'U',['U',xi,yi, 1].join("|"),gid+"|C","Block"]);
						if(px==1&&py==1) {
							ixp = 1-xpos;
							iyp = 1-ypos;
							xxp = ixp*xd-iyp*xyd;
							yyp = iyp*yd-ixp*yxd-.5;
							//trace(xxp,yyp);//[type,xi,yi].join(",")
							//array.push([xxp,yyp,0,null,"smurfy","smurfy","SmurfBMP"]);
							array.push([xxp,yyp,0,null,"jopi.swf",gid+"|"+"jopi.swf","jopi.swf","load"]);
						}
						else if(px==5&&py==3) {
							ixp = 4.8-xpos;//+getTimer()/10000;
							//trace(getTimer()/1000);
							iyp = 2.2-ypos;
							xxp = ixp*xd-iyp*xyd;
							yyp = iyp*yd-ixp*yxd-.5;
							array.push([xxp,yyp,0,null,gid+"|d13",gid+"|"+"d13","Dude13","unique"]);
							array.push([xxp+1,yyp,0,null,gid+"|d12",gid+"|"+"d12","Dude12","unique"]);
//							array.push([xxp,yyp,0,null,"smurfy",gid+"|"+"smurfy","SmurfBMP","unique"]);
//							trace([xxp,yyp,0,null,gid+"|d13",gid+"|"+"d13","Dude13","unique"]);
						}
						else if(px==2009&&py==3540) {
//							trace("here");
							ixp = 9.2-xpos;//+getTimer()/10000;
							iyp = 14.2-ypos;
							xxp = ixp*xd-iyp*xyd;
							yyp = iyp*yd-ixp*yxd-.5;//
							array.push([xxp,yyp,0,null,"smurfy",gid+"|"+"smurfy","SmurfBMP","unique"]);
//							array.push([xxp,yyp,0,null,"smurfy","smurfy","SmurfBMP"]);
							//array.push([xxp,yyp,0,null,"pixoo",gid+"|"+"pixoo","Pixoo"]);						
						}
					}
					else {
						///*
						for(var i=0;i<SIDE4.length;i++) {
							//if(approach&&i!=2)
								//continude;
							
							if(i<2 || yi>=0) {
								var s4 = SIDE4[i];
								var xp:Number = xi+s4[1].x*.5;
								var yp:Number = yi+s4[1].y*.5-(i<2?0:.5);
								var sid:String = [s4[0],xp,yp,0].join("|");
								var ggid:String = gid+"|"+transcode(xd,yd,xyd,yxd,s4[1].x,s4[1].y);
								var cell:Array = [xp,yp,0,s4[0],sid,ggid,i<2?"Block":"FrontWall"];
								if(!(ggid in walls)) {
								}
								else if(walls[ggid]) {
									cell[7] = "loadwall";
									cell = cell.concat(walls[ggid].split("|"));
								}
								else if(ggid=="#|-1|3|N") {
									cell[7]="loadwall";
									cell[8]="graph.swf";
									if(!securedomains[cell[8]]) {
										securedomains[cell[8]] = true;
										Security.allowDomain(cell[8]);
									}
								}
								array.push(cell);
							}
						}
						/*/
						array.push([xi-.5,yi,0,'L',['L',xi-.5,yi,0].join("|"),gid+"|"+transcode(xd,yd,xyd,yxd,-1,0),"Block"]);
						array.push([xi+.5,yi,0,'R',['R',xi+.5,yi,0].join("|"),gid+"|"+transcode(xd,yd,xyd,yxd,1,0),"Block"]);
						if(yi>=0) {
							array.push([xi,yi,0,'B',['B',xi,yi,0].join("|"),gid+"|"+transcode(xd,yd,xyd,yxd,0,1),"FrontWall"]);
							array.push([xi,yi-1,0,'F',['F',xi,yi-1,0].join("|"),gid+"|"+transcode(xd,yd,xyd,yxd,0,-1),"FrontWall"]);
						}
						//*/
					}
					var objs = getGroundObjects(px,py,ph);
					if(objs) {
						for(var o in objs) {
							var list = objs[o];
							for(i=0;i<list.length;i++) {
								var l = list[i];
								ixp = px-xpos + (l[1]?parseInt(l[1])/10:0);//4.8-xpos;
								iyp = py-ypos + (l[2]?parseInt(l[2])/10:0);//2.2-ypos;
								xxp = ixp*xd-iyp*xyd;
								yyp = iyp*yd-ixp*yxd-.5;
								array.push([xxp,yyp,0,null,gid+"|"+l[0],gid+"|"+l[0],l[0],"unique"]);
//w								trace(gid,l[0],xxp,yyp);
//									trace([xxp,yyp,0,null,gid+"|d12"+l[0],gid+"|d13"+l[0],l[0],"unique"]);
							}
						}
					}
				}
			}
			
			return array;
		}

	}
	
	
}