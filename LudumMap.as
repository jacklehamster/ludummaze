package  {
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.utils.ByteArray;
	import by.blooddy.crypto.MD5;
	
	public class LudumMap extends Map {

		[Embed("LD29.json", mimeType = "application/octet-stream")]
		var LD29JSon:Class;
		
		private var so:SharedObject = SharedObject.getLocal("LD29");
		public var entries:Array = [], seed:String;
		public var otherRandomList:Array = [
			"ut.swf|OZ_jgNQNqzI|Ludum Dare 29 Keynote",
			"ut.swf|OZ_jgNQNqzI|Ludum Dare 29 Keynote",
			"ut.swf|OZ_jgNQNqzI|Ludum Dare 29 Keynote",
			"ut.swf|OZ_jgNQNqzI|Ludum Dare 29 Keynote",
			"ut.swf|OZ_jgNQNqzI|Ludum Dare 29 Keynote",
			"ut.swf|OZ_jgNQNqzI|Ludum Dare 29 Keynote"
		];
		
		static public var instance:LudumMap;
		
		public function LudumMap(link:String,seed:String="") {
			instance = this;
			this.seed = seed;
			// constructor code
			if(link=="LD29.json") {
				var bytes:ByteArray = new LD29JSon() as ByteArray;
				var json:String = bytes.readUTFBytes(bytes.bytesAvailable);
				entries = JSON.parse(json) as Array;
				//trace(entries);
			}
			else {
				var urlloader:URLLoader = new URLLoader();
				urlloader.addEventListener(Event.COMPLETE,
					function(e:Event):void {
						entries = JSON.parse(urlloader.data) as Array;
						trace(entries.length);
				});
				urlloader.load(new URLRequest(link));
			}
//			http://r.playerio.com/r/princess-fart-zarir7fqlucotpfhkcxsa/LD29.json
		}

		override public function hasGround(px:int,py:int,ph:int):Boolean {
			var id:String = px+"|"+py+"|"+ph;
			if(id in grounds)
				return getGround(px,py,ph) && getGroundObjects(px,py,ph).G;
//			if(super.hasGround(px,py,ph))
//				return true;
			var mt:int = (px^py)+1;//^(hi+hpos);
//			return !mt||Math.abs(Math.abs(mt))%13;
			return Boolean((Math.abs(mt)%3)||!(Math.abs(mt)%7)||!(Math.abs(mt)%13)||!(Math.abs(mt)%1978));
		}
		
		private function extractYoutube(entry:Object):void {
			for each(var pair:Array in entry.links) {
				if(pair[1].indexOf("youtube.com/watch?v=")>=0) {
					var id:String = pair[1].split("youtube.com/watch?v=")[1].split("&")[0];
					otherRandomList.push("ut.swf|"+id+"|"+pair[0]);
					otherRandomList.unshift("ut.swf|"+id+"|"+pair[0]);
				}
			}
		}
		
		override public function getWall(wallID:String):String {
			if(!walls[wallID] && entries.length) {
				if(!so.data[wallID]) {
					var md5:String = MD5.hash(wallID+seed);
					var xp:int = (wallID.split("|")[1]);
					var yp:int = (wallID.split("|")[2]);
					var DIR:String = (wallID.split("|")[3]);
					var index:int = -1;
					var rand:uint = parseInt(md5.substr(0,8),16);
					if(rand%4==0) {
						index = rand%entries.length;
						var entry:Object = entries[index];
						setWall(wallID,
							"canvas.swf|"+entry.img+"|"+entry.title.split("|").join("_")+"|"
							+entry.author.split("|").join("_")+"|"+entry.id+"|"
							+entry.large+"|"+entry.type+"|"
							+JSON.stringify(entry.links).split("|").join("_"));
						extractYoutube(entry);
					}
					else if(rand%50==1 && otherRandomList.length) {
						trace(wallID,otherRandomList.length,otherRandomList[0]);
						setWall(wallID,otherRandomList.shift());
					}
					so.setProperty(wallID,""+index);
				}
				else {
					index = parseInt(so.data[wallID]);
					if(index>=0) {
						entry = entries[index]; //entries.pop();
						setWall(wallID,
							"canvas.swf|"+entry.img+"|"+entry.title.split("|").join("_")+"|"
							+entry.author.split("|").join("_")+"|"+entry.id+"|"
							+entry.large+"|"+entry.type+"|"
							+JSON.stringify(entry.links).split("|").join("_"));
						extractYoutube(entry);
					}
					else if(rand%20==1 && otherRandomList.length) {
						trace(wallID,otherRandomList.length,otherRandomList[0]);
						setWall(wallID,otherRandomList.shift());
					}
				}
			}
			return super.getWall(wallID);
		}
		
	}
	
}
