/*
Copyright (c) 2011 Juan Mellado

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

package
{
  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.StatusEvent;
  import flash.external.ExternalInterface;
  import flash.media.Camera;
  import flash.media.Video;

  [SWF(width = "320", height = "240", backgroundColor = "#ff0000")]
  
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