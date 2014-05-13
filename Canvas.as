package {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextFieldAutoSize;
	import flash.net.SharedObject;
	import flash.geom.ColorTransform;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.media.Video;
	import flash.system.LoaderContext;

	
	public class Canvas extends MovieClip {
		public var bmp;
		private var prefix:String = "http://www.ludumdare.com/compo/ludum-dare-29/?action=preview&uid=";
		private var imgprefix:String = "http://www.ludumdare.com/compo/wp-content/compo2/thumb/";
		private var LDID:String;
		static const colorTransform:ColorTransform = new ColorTransform(1,1,1,1,-150,-150,-150);
		static private var iconLoaders:Object = {};
		
		public function initialize(room,id,image=null,caption=null,author=null,LDID=null,large=null,type=null,links:String=null):void {
			this.LDID = LDID;
			if(image) {
				canvas.visible = false;
				canvas.loadURL(imgprefix + image,large);
			}
			if(caption) {
				caption_text.text = caption;
				caption_text.autoSize = TextFieldAutoSize.LEFT;
				caption_text.width = canvas.width;
				caption_text.scaleY = caption_text.scaleX;
			}
			if(author) {
				author_text.text = author;
			}
			if(type) {
				type_tf.text = type;
			}
			if(links) {
				var lnks:Array = JSON.parse(links) as Array;
				for(var i=0;i<5;i++) {
					var icono:MovieClip = this["link"+(i+1)];
					var pair:Array = lnks[i];
					if(pair) {
						icono.visible = true;
						icono.type_tf.text = pair[0];
						var domain:String = pair[1].split("?")[0].split("#")[0].split("://")[1].split("/")[0].toLowerCase();
						loadIcon(icono,domain);
					}
					else {
						icono.visible = false;
					}
				}
			}
			addEventListener(MouseEvent.CLICK,doVisit);
			setVisited();
		}
		
		private function doVisit(e:MouseEvent):void {
			if(canvas.buttonMode) {
				navigateToURL(new URLRequest(prefix + LDID));
				var so:SharedObject = SharedObject.getLocal("Maze");
				if(!so.data["visited_"+LDID]) {
					so.setProperty("visited_"+LDID,true);
					setVisited();
					checkVisited();
					if(LDID=="20841") {
						Achievement.unlock(Achievement.JACK);
					}
				}
			}
		}
		
		private function loadIcon(icono:MovieClip,domain:String):void {
			var loader:Loader = iconLoaders[domain];
			if(!loader) {
//				iconLoaders[domain] = loader = new Loader();
//				loader.load(new URLRequest("http://www.google.com/s2/favicons?domain="+domain), new LoaderContext(true));
				loader = new Loader();
				loader.load(new URLRequest("http://www.google.com/s2/favicons?domain="+domain));
				icono.addChild(loader);
				loader.x = -16;
				return;
			}
			if(!loader.content) {
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,
					function(e:Event):void {
						var bitmap:Bitmap = icono.addChild(new Bitmap((loader.content as Bitmap).bitmapData)) as Bitmap;
						icono.addChild(bitmap);
						bitmap.x = -16;
					});
			}
			else {
				var bitmap:Bitmap = new Bitmap((loader.content as Bitmap).bitmapData);
				icono.addChild(bitmap);
				bitmap.x = -16;
			}
		}
		
		public function checkVisited():void {
			var entries:Array = LudumMap.instance.entries;
			var so:SharedObject = SharedObject.getLocal("Maze");
			var count:int = 0;
			for each(var entry:Object in entries) {
				if(so.data["visited_"+entry.id]) {
					count++;
				}
			}
			if(count>=10) {
				Achievement.unlock(Achievement.TEN);
			}
			if(count>=entries.length/3) {
				Achievement.unlock(Achievement.THIRD);
			}
			if(count>=entries.length/2) {
				Achievement.unlock(Achievement.HALF);
			}
			if(count==entries.length) {
				Achievement.unlock(Achievement.ALL);
			}
			Achievement.postScore(count);
			progress.visible = true;
			progress.text = count+"/"+entries.length;
		}
		
		public function moveTo(e) {
			canvas.buttonMode = e.distance<1;
			progress.visible = e.distance<1;
			if(progress.visible) {
				checkVisited();
			}
		}
		
		private function setVisited():void {
			var so:SharedObject = SharedObject.getLocal("Maze");
			check.visible = so.data["visited_"+LDID];
			
//				transform.colorTransform = colorTransform;
		}
		
		public function get canDraw():Boolean {
			return bmp;
		}
	}
}