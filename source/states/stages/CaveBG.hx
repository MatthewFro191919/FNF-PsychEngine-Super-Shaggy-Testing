package states.stages;

// Required Dependencies/Imports (Assuming a HaxeFlixel or similar context)
// Note: These imports are assumptions based on common Haxe game frameworks.
// The actual imports might differ based on the specific framework used.
import haxe.ds.Vector; // Or Array<Float> depending on scroll_get_pos return type
import flixel.FlxG; // Assuming FlxG for global access if needed
import flixel.FlxSprite; // Assuming sprite_load returns FlxSprite or similar
import flixel.util.FlxColor; // Assuming c_black/c_white map to FlxColor

// Assuming existence of external functions/objects like:
// sprite_load(path:String):Dynamic // Or specific sprite type
// offset_setby_fraction(sprite:Dynamic, x:Float, y:Float):Void
// prop_set(object:Dynamic, propertyPath:String, value:Dynamic):Void
// draw_set_color(color:Int):Void // Or specific color type
// draw_rectangle(x1:Float, y1:Float, x2:Float, y2:Float, outline:Bool):Void
// draw_sprite_scrolled(sprite:Dynamic, x:Float, y:Float, z:Float, scrollX:Float, scrollY:Float):Void
// scroll_get_pos(x:Float, y:Float, factor:Float):Array<Float> // Or Vector<Float>
// draw_floor(sprite:Dynamic, x:Float, y:Float, z:Float, scrollX:Float, scrollY:Float, isCeiling:Bool = false):Void
// obj_fnf:Dynamic // Global or static object
// c_black:Int // Color constant
// c_white:Int // Color constant
class CaveBG extends BaseStage {
	// Static variables to hold sprite references, mimicking Lua's global scope
	static var bg:Dynamic;
	static var super_bg:Dynamic;
	static var es1:Dynamic;
	static var cal1:Dynamic;
	static var cal2:Dynamic;
	static var ground:Dynamic;
	static var ceil:Dynamic;

	// --- Assumed external functions (replace with actual framework calls) ---
	// These are placeholders demonstrating the expected function calls.
	// The actual implementation depends on the target Haxe framework.

	static function sprite_load(path:String):Dynamic {
		// Example: return new FlxSprite().loadGraphic(AssetPaths.image(path));
		trace("Warning: sprite_load not implemented. Called with path: " + path);
		return null; // Placeholder
	}

	static function offset_setby_fraction(sprite:Dynamic, x:Float, y:Float):Void {
		// Example: if (sprite != null) { sprite.offset.set(sprite.width * (x - 0.5), sprite.height * (y - 0.5)); } // Approximation
		trace("Warning: offset_setby_fraction not implemented.");
		// Placeholder implementation detail: Assumes sprite has width/height and offset properties
		if (sprite != null && Reflect.hasField(sprite, "width") && Reflect.hasField(sprite, "height") && Reflect.hasField(sprite, "offset")
			&& Reflect.hasField(sprite.offset, "set")) {
			// This is a guess based on common frameworks like HaxeFlixel
			// sprite.offset.set(sprite.width * x - sprite.frameWidth * 0.5, sprite.height * y - sprite.frameHeight * 0.5); // More accurate offset calc?
			// The original Lua function name suggests setting the origin/pivot point as a fraction of size.
			// Let's assume it sets the origin:
			if (Reflect.hasField(sprite, "origin") && Reflect.hasField(sprite.origin, "set")) {
				// sprite.origin.set(sprite.width * x, sprite.height * y); // This might be closer
			}
		}
	}

	static function prop_set(object:Dynamic, propertyPath:String, value:Dynamic):Void {
		trace("Warning: prop_set not implemented. Called with path: " + propertyPath + ", value: " + value);
		// Example using Reflection (careful with nested paths):
		var parts = propertyPath.split(".");
		var current:Dynamic = object;
		for (i in 0...parts.length - 1) {
			var part = parts[i];
			if (current == null || !Reflect.hasField(current, part)) {
				trace('Error: prop_set failed, invalid path part: ${part} in ${propertyPath}');
				return;
			}
			// Handle potential array access like "cam.0"
			var numIndex = Std.parseInt(part);
			if (numIndex != null && Std.string(numIndex) == part) {
				current = current[numIndex];
			} else {
				current = Reflect.field(current, part);
			}
		}
		var finalPart = parts[parts.length - 1];
		var numIndex = Std.parseInt(finalPart);
		if (current != null) {
			if (numIndex != null && Std.string(numIndex) == finalPart) {
				current[numIndex] = value;
			} else {
				Reflect.setProperty(current, finalPart, value);
			}
		} else {
			trace('Error: prop_set failed, final object in path is null for ${propertyPath}');
		}
	}

	static function draw_set_color(color:Int):Void {
		// Example: FlxG.camera.bgColor = color; or specific drawing context color
		trace("Warning: draw_set_color not implemented. Called with color: " + color);
		// Placeholder
	}

	static function draw_rectangle(x1:Float, y1:Float, x2:Float, y2:Float, outline:Bool):Void {
		// Example: FlxG.camera.buffer.drawRect(x1, y1, x2 - x1, y2 - y1, FlxColor.TRANSPARENT, { thickness: 1, color: currentColor }); // Complex example
		trace("Warning: draw_rectangle not implemented.");
		// Placeholder
	}

	static function draw_sprite_scrolled(sprite:Dynamic, x:Float, y:Float, z:Float, scrollX:Float, scrollY:Float):Void {
		// Example: Needs custom implementation or framework equivalent (e.g., FlxSprite with scrollFactor)
		trace("Warning: draw_sprite_scrolled not implemented.");
		// Placeholder - This likely requires setting sprite position based on camera scroll
		// if (sprite != null) {
		//    sprite.x = x - FlxG.camera.scroll.x * scrollX;
		//    sprite.y = y - FlxG.camera.scroll.y * scrollY;
		//    // Z-ordering would depend on the drawing system (e.g., adding to a FlxGroup)
		//    // sprite.draw(); // Or add to a render group
		// }
	}

	static function scroll_get_pos(x:Float, y:Float, factor:Float):Array<Float> {
		// Example: return [x - FlxG.camera.scroll.x * factor, y - FlxG.camera.scroll.y * factor];
		trace("Warning: scroll_get_pos not implemented.");
		// Placeholder
		// Assuming FlxG.camera exists and has a scroll property
		// if (Reflect.hasField(FlxG, "camera") && Reflect.hasField(FlxG.camera, "scroll")) {
		//    return [x - FlxG.camera.scroll.x * factor, y - FlxG.camera.scroll.y * factor];
		// }
		return [x, y]; // Default fallback
	}

	static function draw_floor(sprite:Dynamic, x:Float, y:Float, z:Float, scrollX:Float, scrollY:Float, isCeiling:Bool = false):Void {
		// Example: Needs custom implementation (likely tiling a sprite based on scroll)
		trace("Warning: draw_floor not implemented.");
		// Placeholder
	}

	// --- Assumed global constants/objects ---
	// Replace with actual framework constants/objects
	static var c_black:Int = 0xFF000000; // Example using FlxColor format (ARGB)
	static var c_white:Int = 0xFFFFFFFF; // Example using FlxColor format (ARGB)
	public static var obj_fnf:Dynamic = { // Placeholder structure based on usage
		bf: {x: 0.0, prop: {cam: [0.0, 0.0]}}, // Assuming cam is an array/vector
		dad: {x: 0.0},
		gf: {x: 0.0},
		camZoom: 1.0,
		camToZoom: 1.0
	};

	// --- Translated Lua Functions ---

	override function create():Void {
		bg = sprite_load("cavebg/bg");
		offset_setby_fraction(bg, 0.5, 0.5);
		super_bg = sprite_load("cavebg/super_bg");
		offset_setby_fraction(super_bg, 0.5, 0.5);
		es1 = sprite_load("cavebg/es1");
		offset_setby_fraction(es1, 0.5, 0.5);
		cal1 = sprite_load("cavebg/cal1");
		offset_setby_fraction(cal1, 0.5, 0.5);
		cal2 = sprite_load("cavebg/cal2");
		offset_setby_fraction(cal2, 0.5, 0.5);

		ground = sprite_load("cavebg/ground");
		offset_setby_fraction(ground, 0.5, 0.35);
		ceil = sprite_load("cavebg/ceil");
		offset_setby_fraction(ceil, 0.5, 1 - 0.1); // Haxe calculation is the same

		obj_fnf.bf.x = 750;
		obj_fnf.dad.x = -750;
		// Assuming prop_set exists and handles the path string "prop.cam.0" / "prop.cam.1"
		// Reading Lua's 1-based index obj_fnf.bf.prop.cam[1] -> Haxe's 0-based index obj_fnf.bf.prop.cam[0]
		// Reading Lua's 1-based index obj_fnf.bf.prop.cam[2] -> Haxe's 0-based index obj_fnf.bf.prop.cam[1]
		prop_set(obj_fnf.bf, "prop.cam.0", obj_fnf.bf.prop.cam[0] - 300);
		prop_set(obj_fnf.bf, "prop.cam.1", obj_fnf.bf.prop.cam[1] - 50);
		obj_fnf.gf.x = 80;
		obj_fnf.camZoom = 0.55;
		obj_fnf.camToZoom = obj_fnf.camZoom;
	}

	public static function drawBG():Void {
		draw_set_color(c_black);
		draw_rectangle(-4000, -4000, 4000, 4000, false);
		draw_set_color(c_white);

		draw_sprite_scrolled(super_bg, 0, 0, -400, 0.1, 0.1);
		draw_sprite_scrolled(bg, 0, 0, 300, 0.3, 0.3);
		var gp:Array<Float> = scroll_get_pos(0, -200, 0.1); // Declare gp as local variable, assuming Array<Float> return type
		// Accessing Lua's gp[1] -> Haxe's gp[0]
		// Accessing Lua's gp[2] -> Haxe's gp[1]
		draw_floor(ceil, 0, 0, -1200, gp[0], gp[1], true);

		draw_sprite_scrolled(cal2, 0, -70, -350, 0.5, 0.5);
		draw_sprite_scrolled(es1, 0, 0, 0, 0.6, 0.6);
		draw_sprite_scrolled(cal1, 0, -70, -600, 0.7, 0.7);
		// Re-declare gp locally (shadowing is allowed, matches Lua behavior)
		gp = scroll_get_pos(0, -100, 0.8);
		// Accessing Lua's gp[1] -> Haxe's gp[0]
		// Accessing Lua's gp[2] -> Haxe's gp[1]
		draw_floor(ground, 0, 0, 0, gp[0], gp[1]); // Default isCeiling is false
	}

	public function initModchart() {
		var newScript:ModScript = null;
		try {
			newScript = new ModScript(null);
			if (newScript.exists('create'))
				newScript.call('create');
			trace('initialized ModScript interp successfully');
			push(newScript);
		} catch (e:IrisError) {
			var pos:ModScriptInfos = cast {showLine: false};
			Iris.error(Printer.errorToString(e, false), pos);
			var newScript:ModScript = cast(Iris.instances.get(), ModScript);
			if (newScript != null)
				newScript.destroy();
		}
	}
}
