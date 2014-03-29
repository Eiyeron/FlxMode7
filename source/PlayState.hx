package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

import flash.display.BitmapData;


typedef MODE_7_PARAMS =
{
    var space_z:Float; // this is the height of the camera above the plane
    var horizon:Int; // this is the number of pixels line 0 is below the horizon
    var angle:Float;
    var cx:Float;
    var cy:Float;
    var scale_x:Float;
    var scale_y:Float; // this determines the scale of space coordinates
    // to screen coordinates
    //var obj_scale_x:Float;
    //var obj_scale_y:Float; // this determines the relative size of
    // the objects
};

/**
 * A FlxState which can be used for the actual gameplay.
 */
 class PlayState extends FlxState
 {

 	private var cx = 0;
 	private var cy = 0;
 	private var params:MODE_7_PARAMS;
 	private var _canvas:BitmapData;

 	private static inline var b = 0xFF000000;
 	private static inline var w = 0xFFFFFFFF;

 	private var time:Int = 0;
 	private var tile:Array<Array<Int>> = 
 	[
 	[b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,w,w,w,w,w,w,w,w,w,w,w,w,w,w,b],
 	[b,b,b,b,b,b,b,b,b,b,b,b,b,b,b,b]
 	];

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	 override public function create():Void
	 {
	 	super.create();
	 	var half:Int = Math.floor(FlxG.height/2);
	 	var full:Int = Math.floor(FlxG.height);
	 	params = {cx : 0, cy: 0, angle: 0, space_z:100, horizon:full, scale_x:FlxG.width, scale_y:full};
	 	

	 	var sprite = new FlxSprite(0,0);
	 	sprite.makeGraphic(Math.floor(FlxG.width), Math.floor(FlxG.height), 0x00000000);
	 	_canvas = sprite.cachedGraphics.bitmap;
	 	add(sprite);
	 	var square = new FlxSprite(0,0);
	 	square.makeGraphic(8, 8, 0xFFFFFF00);
	 	add(square);
	 	FlxG.log.add("Meh");
	 	FlxG.watch.add(params, "space_z", "sz");
	 }

	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	 override public function destroy():Void
	 {
	 	super.destroy();
	 }

	/**
	 * Function that is called once every frame.
	 */
	 override public function update():Void
	 {
	 	super.update();
	 	time += Math.floor(FlxG.elapsed * 200);
	 	//params.space_z = 600*Math.cos(time/150) + 150;
	 	//params.angle = time/100;
	 	params.horizon = Math.floor( FlxG.height * Math.cos(time/100) + FlxG.height/2 );
	 	_mode7();
	 }	

	 private function _mode7()
	 {

	    // the distance and horizontal scale of the line we are drawing
	    var distance:Float, horizontal_scale:Float;

	    // masks to make sure we don't read pixels outside the tile
	    var mask_x:Int = (16 - 1);
	    var mask_y:Int = (16 - 1);

	    // step for points in space between two pixels on a horizontal line
	    var line_dx:Float, line_dy:Float;

	    // current space position
	    var space_x:Float, space_y:Float;

	    _canvas.lock();
	    for (screen_y in 0..._canvas.height)
	    {
	        // first calculate the distance of the line we are drawing
	        distance = (params.space_z* params.scale_y) / (screen_y + params.horizon/1.);
	        if(distance < 0) continue;
	        // then calculate the horizontal scale, or the distance between
	        // space points on this horizontal line
	        horizontal_scale = distance/params.scale_x;

	        // calculate the dx and dy of points in space when we step
	        // through all points on this line
	        line_dx = -Math.sin(params.angle)* horizontal_scale;
	        line_dy = Math.cos(params.angle)* horizontal_scale;

	        // calculate the starting position
	        space_x = (params.cx + distance* Math.cos(params.angle) - 128./2. * line_dx);
	        space_y = (params.cy + distance* Math.sin(params.angle) - 128./2. * line_dy);

	        // go through all points in this screen line
	        for (screen_x in 0...FlxG.width)
	        {
	            // get a pixel from the tile and put it on the screen
				/*putpixel (bmp, screen_x, screen_y,
					getpixel (tile,
						fixtoi (space_x) & mask_x,
						fixtoi (space_y) & mask_y));*/
						//ML_pixel(screen_x, screen_y, spr[UNFIX(space_x)&mask_x][UNFIX(space_y)&mask_y]);
						//ML_pixel(screen_x,screen_y + 32,spr[(UNFIX(space_y)&mask_y)*16 + (UNFIX(space_x)&mask_x)]);
						_canvas.setPixel32(screen_x, screen_y, tile[Math.floor(space_y)&mask_y][Math.floor(space_x)&mask_x]);
	            // advance to the next position in space
	            space_x += line_dx;
	            space_y += line_dy;
	        }
	    }
	    _canvas.unlock();


	}
}