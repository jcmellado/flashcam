Capture video on Flash so you can use it from JavaScript using ExternalInterface.

### Demo ###

Try the [live demo](http://www.inmensia.com/files/flashcam/demo/demo.html")!

### How to use it? ###

The library calls the `cameraUnmuted` JavaScript function when the user "unmutes" webcam on Flash:

```
var camera, canvas, context, imageData, pixels;

function cameraUnmuted(){
  camera = document.getElementById("flashcam");
  canvas = document.getElementById("canvas");
  context = canvas.getContext("2d");
  imageData = context.getImageData(0, 0, canvas.width, canvas.height);
}
```

Then the `snapshot` function of the `camera` object can be called anytime to get the image data:

```
function snapshot(){
  var image = imageData.data, i = 0, j = 0, pixel = 0, len;

  pixels = camera.snapshot().split(",");

  len = pixels.length - 1;
  while(len --){
    pixel += parseInt( pixels[j ++], 36);

    image[i ++] = pixel >> 16;
    image[i ++] = (pixel >> 8) & 0xff;
    image[i ++] = pixel & 0xff;
    image[i ++] = 255;
  }

  context.putImageData(imageData, 0, 0);
}
```

### Security Issue ###

You probably need to visit the Flash settings on the Global Security Panel to run the demo on your local hard drive.

Search "flash global security settings" on Google to get more information.