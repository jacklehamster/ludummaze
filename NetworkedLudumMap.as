package  {
	import playerio.Client;
	import playerio.Connection;
	import flash.display.Stage;
	import playerio.PlayerIO;
	import playerio.PlayerIOError;
	import playerio.Message;
	
	public class NetworkedLudumMap extends LudumMap {

		static public var gameType:String = "LudumMaze";
		static public var gameId:String = "ludum-maze-wowd18ch7eys0rxfbjac7q";
		static public var online:Boolean = true;
		static public var ip_address:String = "172.16.73.128:8184";
		
		private var client:Client, xpos:int=0,ypos:int=0,hpos:int=0;
		private var connections:Object = {};
		private var joining:Object = {};
		
		public function NetworkedLudumMap(stage:Stage,link:String,seed:String="") {
			super(link,seed);
			PlayerIO.connect(
				stage,								//Referance to stage
				gameId,								//Game id (Get your own at playerio.com. 1: Create user, 2:Goto admin pannel, 3:Create game, 4: Copy game id inside the "")
				"public",							//Connection id, default is public
				Achievement.playerName,				//Username
				"",									//User auth. Can be left blank if authentication is disabled on connection
				null,								//Current PartnerPay partner.
				handleConnect,						//Function executed on successful connect
				handleError							//Function executed if we recive an error
			);
		}
		
		private function handleError(error:PlayerIOError):void{
			trace(error);
		}
		
		override public function getMap(xpos:int,ypos:int,hpos:int,idir:int,approach,mode:int):Array {
			this.xpos = xpos;
			this.ypos = ypos;
			this.hpos = hpos;
			updateRooms();
			return super.getMap(xpos,ypos,hpos,idir,approach,mode);
		}
		
		override public function sendMessage(message:Object):void {
			if(message.type=="comment") {
				trace(JSON.stringify(message));
				var roomX:int = Math.round(xpos/100);
				var roomY:int = Math.round(ypos/100);
				var roomID:String = "room_"+roomX+"_"+roomY;
				var connection:Connection = connections[roomID];
				if(connection) {
					connection.send("comment",message.wallID,message.message,message.author);
				}
			}
		}
				
		private function updateRooms():void {
			var roomX:int = Math.round(xpos/100);
			var roomY:int = Math.round(ypos/100);
			var roomsToJoin:Object = {};
			for(var rY:int=-1;rY<=1;rY++) {
				for(var rX:int=-1;rX<=1;rX++) {
					var roomID:String = "room_"+(roomX+rX)+"_"+(roomY+rY);					
					roomsToJoin[roomID] = true;
					if(rX==0 && rY==0) {
						var connection:Connection = connections[roomID];
						if(!connection) {
							joinRoom(roomID);
						}
					}
				}
			}
			for(roomID in connections) {
				if(!roomsToJoin[roomID]) {
					leaveRoom(roomID);
				}
			}
		}
		
		private function leaveRoom(room:String):void {
			trace("Leaving ",room);
			(connections[room] as Connection).disconnect();
			delete connections[room];
		}
		
		private function joinRoom(room:String):void {
			if(!client)
				return;
			if(!joining[room] && !connections[room]) {
				trace("Joining ",room);
				joining[room] = true;
				client.multiplayer.createJoinRoom(
					room,								//Room id. If set to null a random roomid is used
					gameType,							//The game type started on the server
					true,								//Should the room be visible in the lobby?
					{},									//Room data. This data is returned to lobby list. Variabels can be modifed on the server
					{},									//User join data
					handleJoin,							//Function executed on successful joining of the room
					handleError							//Function executed if we got a join error
				);			
			}
		}
		
		private function handleConnect(client:Client):void{
			trace("Sucessfully connected to Yahoo Games Network");
			this.client = client;
			//Set developmentsever (Comment out to connect to your server online)
			if(!online)
				client.multiplayer.developmentServer = ip_address;
			updateRooms();
		}
		
		private function handleJoin(connection:Connection):void{
			delete joining[connection.roomId];
			connections[connection.roomId] = connection;
			
			trace("Sucessfully connected to the multiplayer room "+connection.roomId);
			
			connection.addMessageHandler("comment",function(m:Message):void {
				for(var i:int=0;i<m.length;i+=4) {
					var wallID:String = m.getString(i+0);
					trace(wallID);
					var comment:String = m.getString(i+1);
					trace(comment);
					var author:String = m.getString(i+2);
					trace(author);
					var extra:String = i+3<m.length? m.getString(i+3):"";
					
					setWall(wallID,"comment.swf|"+comment+"|"+author+"|true");
				}
			});
		}
		
	}
	
}
