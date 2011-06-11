package
{
  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.StatusEvent;
  import flash.external.ExternalInterface;
  import flash.media.Camera;
  import flash.media.Video;

  [SWF(width = "320", height = "230", backgroundColor = "#ff0000")]
  
  public class Flashcam extends Sprite 
  {
    private static var camera:Camera;
    private static var video:Video;
    private static var bitmap:BitmapData;
    private static var pixels:String;

    public function Flashcam():void {
      if (stage){
        onAddedToStage();
      }else {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      }
    }

    private function onAddedToStage(e:Event = null):void{
      removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

      Flashcam.camera = Camera.getCamera();
      Flashcam.camera.setMode(320, 240, 24);
      Flashcam.camera.addEventListener(StatusEvent.STATUS, statusHandler);
        
      Flashcam.video = new Video(Flashcam.camera.width, Flashcam.camera.height);
      Flashcam.video.attachCamera(Flashcam.camera);

      Flashcam.bitmap = new BitmapData(video.width, video.height, false);
      
      ExternalInterface.addCallback("snapshot", Flashcam.snapshot);
    }
      
    private function statusHandler(event:StatusEvent):void{
      if (event.code == "Camera.Unmuted"){
          Flashcam.camera.removeEventListener(StatusEvent.STATUS, statusHandler);
          
          ExternalInterface.call("cameraUnmuted");
      }
    }
    
    public static function snapshot():String{
      var h:int = Flashcam.bitmap.rect.height,
          w:int = Flashcam.bitmap.rect.width,
          prev:uint = 0, curr:uint, i:int, j:int;

      Flashcam.bitmap.draw(Flashcam.video);
      
      pixels = "";
      
      for (i = 0; i < h; ++ i){
        for (j = 0; j < w; ++ j){
          curr = Flashcam.bitmap.getPixel(j, i);

          pixels += (curr - prev).toString(36);
          pixels += ',';

          prev = curr;
        }
      }
      
      return pixels;
    }
  }
}