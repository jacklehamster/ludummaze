﻿package {
	
	public class Maze extends MovieClip {
		

		static public const MAPPING:Object = {
			QWERTY: {
				"forward":Keyboard.W,
				"backward":Keyboard.S,
				"left":Keyboard.A,
				"right":Keyboard.D,
				"rotateleft":Keyboard.Q,
				"rotateright":Keyboard.E
			},
			AZERTY: {
				"forward":Keyboard.Z,
				"backward":Keyboard.S,
				"left":Keyboard.Q,
				"right":Keyboard.D,
				"rotateleft":Keyboard.A,
				"rotateright":Keyboard.E
			}
		};
		
		static public var keyMapping:Object = MAPPING.QWERTY;
		
		

		[Embed("canvas.swf", mimeType = "application/octet-stream")]
		var Canvas:Class;
		[Embed("jopi.swf", mimeType = "application/octet-stream")]
		var Jopi:Class;
		[Embed("ut.swf", mimeType = "application/octet-stream")]
		var YouTube:Class;
		[Embed("comment.swf", mimeType = "application/octet-stream")]
		var Comment:Class;
		
		var embeded:Object = {
			"canvas.swf":new Canvas(),
			"jopi.swf":new Jopi(),
			"ut.swf":new YouTube(),
			"comment.swf":new Comment()
		};
		
		var version:String = "1.00"+new Date().getTime();
		var inited:Boolean;
		}
		public function init(params,data=null,bgpass=null) {
				return;
			}
			inited = true;
			Achievement.init(this);
		
			
				function(e) {
					approachWall();
				});
			ui.back.visible = false;
							e.preventDefault();
							e.stopImmediatePropagation();
			setMap(new NetworkedLudumMap(stage,"LD29.json",loaderInfo.url));
//			setMap(TestMap.instance);
		
		public function transport(x:int,y:int):void {
			if(x==0 && y==0) {
				x = int(Math.random()*10-5);
				y = int(Math.random()*10-5);
			}
			dstx = posx = (posx+x);
			dsty = posy = (posy+y);
			stage.focus = stage;
			map.dirty = true;
		}
			return false;
		//	trace(MD5.hash(loaderInfo.url));
				case 'dbbdb55ef19adb892d395663e4c05806':
				case '8686d81661177d5750ff638fb2084a4d':
			
			for (var k:String in keyMapping) {
				//trace(k);
				ui.kb[k].visible = keycodes[keyMapping[k]];
			}
			var wall2 = screen.getChildByName("F|0|0|0");
			ui.front.visible = !approach && wall2 && wall2.visible;
//				ui.front.alpha = Math.min(1,(4000-getTimer()+idle)/1000);
			ui.right.visible = ui.left.visible = false;
			*/
			//trace(url);
				loader.loadBytes(embeded[url]);
			}
			else {
				if(!loadinprogress) {
						request.data.update = version;
					}
				}
			}
			trace(url);
			var ground;
				loader.loadBytes(embeded[url]);
			}
			else {
				if(!loadinprogress) {
			}
			idle = getTimer();
			approach = frontspot(dir);
		}
		
		public function setFrontWall(str:String,confirm:Boolean = false) {
				else if(ui.addvideo.currentFrame==4) {
					if(ui.addvideo.clicka.dirty && ui.addvideo.clicka.comment.text.length) {
						setFrontWall("comment.swf|"+escape(ui.addvideo.clicka.comment.text)+"|"+Achievement.playerName+"|true");
						
						theWall = screen.getChildByName("F|0|-1|0");
						map.sendMessage(
							{
								type:"comment",
								message:escape(ui.addvideo.clicka.comment.text),
								wallID:theWall.gid,
								author:Achievement.playerName
							}
						);
						
						ui.addvideo.clicka.dirty = false;
						ui.addvideo.clicka.comment.text = "Click here to enter comment";
					}
				}