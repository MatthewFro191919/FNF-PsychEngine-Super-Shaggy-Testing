package shaggymodchart;

import haxe.ds.Vector;
import Math;

// Placeholder for external dependencies - Replace with actual implementations
typedef Vector3 = { x: Float, y: Float, z: Float };
typedef PointData = { x: Float, y: Float, z: Float }; // Assuming structure for points in prop_set

class Sys {
    public static var skin = { sep: 100.0 }; // Example value, replace with actual
    public static var opt = { downscroll: false }; // Example value, replace with actual
}

class TweenEase {
    public static inline var INOUT_QUAD = "inout_quad";
    public static inline var OUT_QUAD = "out_quad";
    public static inline var IN_QUAD = "in_quad";
    public static inline var LINEAR = "linear";
    public static inline var IN_ELASTIC = "in_elastic";
    public static inline var OUT_ELASTIC = "out_elastic";
}

// Placeholder for tweening function - Replace with actual implementation
function tweenStart(target:Dynamic, properties:Dynamic, duration:Float, ease:String, ?delay:Float = 0.0):Void {
    // Example: trace('tweenStart: Target: ${target}, Props: ${properties}, Duration: ${duration}, Ease: ${ease}, Delay: ${delay}');
    // Replace with actual tweening library call, e.g., FlxTween.tween(...) or Actuate.tween(...)
    ExternalAPI.tweenStart(target, properties, duration, ease, delay);
}

// Placeholder for property setting function - Replace with actual implementation
function prop_set(target:Dynamic, propertyPath:String, value:Dynamic):Void {
    // Example: trace('prop_set: Target: ${target}, Path: ${propertyPath}, Value: ${value}');
    // Replace with actual property setting logic, potentially using reflection or specific object accessors
    ExternalAPI.prop_set(target, propertyPath, value);
}

// Placeholder for random integer function
function randomInt(min:Int, max:Int):Int {
     return min + Math.floor(Math.random() * (max - min + 1));
}

// Placeholder for math utilities
class MathUtil {
    public static inline function degToRad(deg:Float):Float {
        return deg * Math.PI / 180;
    }
    public static inline function radToDeg(rad:Float):Float {
        return rad * 180 / Math.PI;
    }
}

// Placeholder for the main game object - Replace with actual type if known
var obj_game:Dynamic = {
    // Mock structure based on usage
    field: [{x:0.0, y:0.0, z:0.0}, {x:0.0, y:0.0, z:0.0}],
    strums: [
        // Example for one strum, repeat 8 times
        {
            lines: [
                { p: [], a: 0.0, ax: 0.0, ay: 0.0, w: 0.0 },
                { a: 0.0, ax: 0.0, ay: 0.0, w: 0.0 }
            ],
            pos: {x:0.0, y:0.0, z:0.0},
            ang3D: {x:0.0, y:0.0, z:0.0},
            dir: {x:0.0, y:0.0, z:0.0}
        },
        // ... (repeat 7 more times)
    ]
}; // Replace with actual game object reference

// Placeholder for external API calls if needed
class ExternalAPI {
    public static function tweenStart(target:Dynamic, properties:Dynamic, duration:Float, ease:String, ?delay:Float = 0.0):Void { /* Actual implementation needed */ }
    public static function prop_set(target:Dynamic, propertyPath:String, value:Dynamic):Void { /* Actual implementation needed */ }
}


class ModScript {

    public static var mod:Int = 0;
    public static var subMod:Int = 0;
    public static var modBeat:Int = 0;
    public static var modStep:Int = 0; // Note: modStep is declared but never used in the Lua code
    public static var started:Bool = false;

    // Translated from Lua global scope
    public static var l:Float;
    public static var cnt:Array<Float>;
    public static var centerY:Float = 270;

    public static var rot:Float = 0;
    public static var rotspd:Float = 1;
    public static var circAng:Float = MathUtil.degToRad(180);

    // Added static init block to initialize variables dependent on others
    static function __init__() {
        l = Sys.skin.sep;
        cnt = [l*1.5, l / 2, -l / 2, -l*1.5];

        // Initialize obj_game structure if it's managed here (adjust if obj_game is external)
        obj_game = {
            field: [{x:0.0, y:0.0, z:0.0}, {x:0.0, y:0.0, z:0.0}],
            strums: []
        };
        for (i in 0...8) {
            obj_game.strums.push({
                lines: [
                    { p: [], a: 0.0, ax: 0.0, ay: 0.0, w: 0.0 },
                    { a: 0.0, ax: 0.0, ay: 0.0, w: 0.0 }
                ],
                pos: {x:0.0, y:0.0, z:0.0},
                ang3D: {x:0.0, y:0.0, z:0.0},
                dir: {x:0.0, y:0.0, z:0.0}
            });
        }
    }


    public static function create():Void
    {
        modInit(0);
    }


    public static function modInit(Mod:Int):Void
    {
        mod = Mod;
        subMod = 0;
        modBeat = 0;
        modStep = 0; // Resetting modStep although unused
        tweenStart({obj_game: obj_game, prop: "field.0"}, {x : 0, y : 0, z : 0}, 0.1, TweenEase.INOUT_QUAD);
        tweenStart({obj_game: obj_game, prop: "field.1"}, {x : 0, y : 0, z : 0}, 0.1, TweenEase.INOUT_QUAD);
        for (i in 0...8) {
            prop_set(obj_game, "strums." + i + ".lines.0.p", []);
            tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0"}, {a : 270, ax : 0, ay : 0, w : 1}, 0.1, TweenEase.INOUT_QUAD);
            tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.1"}, {a : 270, ax : 0, ay : 0, w : 1}, 0.1, TweenEase.INOUT_QUAD);
            tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {x : 0, y : 0, z : 0}, 0.1, TweenEase.INOUT_QUAD);
            tweenStart({obj_game: obj_game, prop: "strums." + i + ".ang3D"}, {x : 0, y : 0, z : 0}, 0.1, TweenEase.INOUT_QUAD);
            tweenStart({obj_game: obj_game, prop: "strums." + i + ".dir"}, {x : 0, y : 0, z : 0}, 0.1, TweenEase.INOUT_QUAD);
        }
        if (mod == 0) {
            // curSide is used later in onBeatHit, initialize it here or ensure it's initialized elsewhere
            // Assuming curSide should be initialized here for mod 0 based on onBeatHit logic
            curSide = 1;
            for (i in 0...8) {
                prop_set(obj_game, "strums." + i + ".lines.0.p", [{x : 0.0, y : 360.0, z : 0.0}]);
            }
        }
        else if (mod == 1) {
            for (i in 0...8) {
                prop_set(obj_game, "strums." + i + ".lines.0.p", [{x : 0.0, y : 360.0, z : 0.0}]);
            }
        }
        else if (mod == 2) {

            for (i in 0...8) {
                prop_set(obj_game, "strums." + i + ".lines.0.p", [{x : 0.0, y : 720.0 / 4.0, z : 0.0}, {x : 0.0, y : 720.0 / 4.0 * 3.0, z : 0.0}]);
            }

            var l:Float = Sys.skin.sep;
            var woo:Float = l * 0.8;
            for (i in 0...2) {
                //idk
                var num0:Int = i*4;
                var num1:Int = i*4 + 1;
                var num2:Int = i*4 + 2;
                var num3:Int = i*4 + 3;

                var vdir:Float = 1;

                if (Sys.opt.downscroll) {
                    vdir = -1;
                }
                tweenStart({obj_game: obj_game, prop: "strums." + num0 + ".pos"}, {x : l * 1.5 - woo}, 0.2, TweenEase.INOUT_QUAD);
                tweenStart({obj_game: obj_game, prop: "strums." + num3 + ".pos"}, {x : -l * 1.5 + woo}, 0.2, TweenEase.INOUT_QUAD);
                tweenStart({obj_game: obj_game, prop: "strums." + num1 + ".pos"}, {x : l / 2, y : woo * vdir}, 0.2, TweenEase.INOUT_QUAD);
                tweenStart({obj_game: obj_game, prop: "strums." + num2 + ".pos"}, {x : -l / 2, y : -woo * vdir}, 0.2, TweenEase.INOUT_QUAD);
            }
            tweenStart({obj_game: obj_game, prop: "field.1"}, {x : 380, y : centerY}, 0.3, TweenEase.INOUT_QUAD);
            tweenStart({obj_game: obj_game, prop: "field.1"}, {z : -100}, 0.5, TweenEase.INOUT_QUAD);
            tweenStart({obj_game: obj_game, prop: "field.0"}, {y : 380}, 1, TweenEase.INOUT_QUAD);

            var an:Array<Float> = [-90.0, 0.0, 180.0, 90.0];
            if (Sys.opt.downscroll) {
                an[1] = 180; // Index 1 corresponds to Lua index 2
                an[2] = 0;   // Index 2 corresponds to Lua index 3
            }
            for (i in 0...8) {
                // Lua: an[i % 4 + 1] -> Haxe: an[i % 4]
                tweenStart({obj_game: obj_game, prop: "strums." + i + ".dir"}, {z : an[i % 4]}, 0.2, TweenEase.INOUT_QUAD);
            }
        }
        else if (mod == 3) {
            tweenStart({obj_game: obj_game, prop: "field.1"}, {x : 380, y : centerY}, 0.8, TweenEase.OUT_QUAD);
            tweenStart({obj_game: obj_game, prop: "field.0"}, {x : -380, y : centerY}, 0.8, TweenEase.OUT_QUAD);
            for (i in 0...8) {
                tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0"}, {ay : -60, w : 0.9}, 0.11, TweenEase.INOUT_QUAD);
                prop_set(obj_game, "strums." + i + ".lines.0.p", [{x : 0.0, y : 200.0, z : 100.0}]);
                tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.1"}, {ay : -90}, 0.11, TweenEase.INOUT_QUAD);
                // Lua: cnt[i%4 + 1] -> Haxe: cnt[i%4]
                tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {x : cnt[i%4]}, 0.11, TweenEase.INOUT_QUAD);
            }
        }
        else if (mod == 4) {
            for (i in 0...8) {
                var w:Float = 80;
                if (i % 4 < 2) { w = w*-1; }
                tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0"}, {ay : -30}, 0.11, TweenEase.INOUT_QUAD);
                prop_set(obj_game, "strums." + i + ".lines.0.p", [{x : 0.0, y : 360.0, z : 40.0}]);
                // Lua: cnt[i%4 + 1] -> Haxe: cnt[i%4]
                tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {x : cnt[i%4] + w}, 0.11, TweenEase.INOUT_QUAD);
            }
        }
        else if (mod == 5) {
            for (i in 0...8) {
                tweenStart({obj_game: obj_game, prop: "strums." + i + ".dir"}, {x : 50}, 1, TweenEase.INOUT_QUAD);
                tweenStart({obj_game: obj_game, prop: "strums." + i + ".ang3D"}, {x : -50}, 1, TweenEase.INOUT_QUAD);
            }
        }
    }

    public static function update(elapsed:Float):Void
    {
        if (started) {
            if (mod == 0) {
                rot = rot + elapsed * 5;
                for (i in 0...8) {
                    prop_set(obj_game, "strums." + i + ".pos.z", Math.cos(rot + i) * 40);
                }

                if (subMod == 1) {
                    for (i in 0...8) {
                        prop_set(obj_game, "strums." + i + ".dir.z", Math.cos(rot + i) * 10);
                        prop_set(obj_game, "strums." + i + ".ang3D.z", Math.cos(rot + i) * 4);
                    }
                }
            }
            else if (mod == 3) {
                if (subMod == 2) {
                    rotspd = rotspd + elapsed;
                }
                else if (subMod == 3) {
                    rotspd = rotspd - elapsed * 1.21;
                    if (rotspd < 0) {
                        rotspd = 0;
                    }
                    else {
                        tweenStart({obj_game: obj_game, prop: "field.1"}, {x : 380 + randomInt(-4, 4), y : centerY + randomInt(-4, 4)}, 0.01, TweenEase.OUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "field.0"}, {x : -380 + randomInt(-4, 4), y : centerY + randomInt(-4, 4)}, 0.01, TweenEase.OUT_QUAD);
                    }
                }
                circAng = circAng + elapsed * rotspd;
                for (i in 0...8) {
                    var off:Float = -((i%4) - 2) / 2.5;
                    var len:Float = 300;
                    var xlen:Float = len;
                    if (subMod >= 1) { xlen = 500; }
                    var an:Float = circAng + off;
                    if (i < 4) { an = an + MathUtil.degToRad(180); }
                    // Lua: cnt[i%4 + 1] -> Haxe: cnt[i%4]
                    prop_set(obj_game, "strums." + i + ".pos.x", cnt[i%4] + Math.cos(an) * xlen);
                    prop_set(obj_game, "strums." + i + ".pos.y", -Math.sin(an) * len);

                    prop_set(obj_game, "strums." + i + ".dir.z", 270 + MathUtil.radToDeg(an - off));
                }
            }
            else if (mod == 5) {
                //[[
                //for i = 0, 7, 1 do
                //    prop_set(obj_game, "strums."..i..".pos.z", math.cos(rot + i) * 100);
                //end]]
                // Lua comment block translated
                /*
                for (i in 0...8) {
                    prop_set(obj_game, "strums." + i + ".pos.z", Math.cos(rot + i) * 100);
                }
                */
            }
        }
    }

    // Need to declare curSide, likely intended as a static variable based on usage
    static var curSide:Int = 1; // Initialized based on modInit(0) logic

    public static function onBeatHit(beat:Int):Void
    {
        //prop_set(obj_game, "strums.1.pos.x", -40);
        //obj_fnf.gf.prop.beatDance = 4; // Assuming obj_fnf is another external object
        //console_add(s.xscale); // Assuming console_add and s are external

        if (beat == 0) {
            started = true;
        }

        if (started) {
            // Update modBeat before using it in conditions
            modBeat = beat; // Assuming modBeat should track the current beat within the mod

            if (beat == 32) {
                subMod = 1;
            }
            else if (beat == 64) {
                modInit(1);
                modBeat = 0; // Reset modBeat when mod changes
            }
            else if (beat == 128) {
                modInit(2);
                modBeat = 0; // Reset modBeat when mod changes
            }
            else if (beat == 192) {
                modInit(3);
                modBeat = 0; // Reset modBeat when mod changes
            }
            else if (beat == 256) {
                modInit(4);
                modBeat = 0; // Reset modBeat when mod changes
            }
            else if (beat == 296) { // Note: Lua code has 296, but later uses 288 to set mod = -1. Check logic.
                modInit(0);
                modBeat = 0; // Reset modBeat when mod changes
            }
            else if (beat == 288) { // This comes *before* 296 in the sequence, might be intended order?
                mod = -1; // Setting mod to -1, but no logic handles mod == -1 later
                for (i in 0...8) {
                    tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {x : 0, y : 0, z : 0}, 3, TweenEase.INOUT_QUAD);
                }
                // Note: modBeat is not reset here, might be intentional or an oversight
            }
            else if (beat == 328) {
                modInit(5);
                modBeat = 0; // Reset modBeat when mod changes
            }
            else if (beat == 392) {
                modInit(3); // Re-init mod 3
                subMod = 1; // Set subMod immediately
                modBeat = 0; // Reset modBeat when mod changes
            }
            else if (beat == 456) {
                subMod = 2;
            }
            else if (beat == 464) {
                subMod = 3;
            }

            // Mod-specific beat logic (using the current mod value)
            if (mod == 0) {
                for (i in 0...8) {
                    var h:Float = 20;
                    if (beat % 2 == 0) { h = h * -1; }
                    if (i % 2 == 0) { h = h * -1; }
                    tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {y : 40 + h}, 0.2, TweenEase.OUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {y : 0}, 0.2, TweenEase.IN_QUAD, 0.2);

                    //prop_set(obj_game, "strums."..i..".lines.0.p.0.x", h); // Lua comment or old code?
                    h = 100;
                    if (beat % 2 == 0) { h = h * -1; }
                    // Assuming p is an array, accessing index 0
                    tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0.p.0"}, {x : h}, 0.2, TweenEase.OUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0.p.0"}, {x : 0}, 0.2, TweenEase.IN_QUAD, 0.2);
                }

                if (modBeat % 16 == 0) { // Using modBeat here, ensure it's updated correctly
                    var oSide:Int = (curSide + 1) % 2;
                    var w:Float = 200;
                    if (curSide == 0) {
                        w = w * -1;
                    }
                    tweenStart({obj_game: obj_game, prop: "field." + curSide}, {x : w, z : 0}, 1, TweenEase.OUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "field." + oSide}, {x : 0, z : -100}, 1, TweenEase.OUT_QUAD);
                    curSide = oSide;
                }
            }
            else if (mod == 1) {
                var a:Float = 30;
                if (beat % 2 == 1) { a = a * -1; }
                if (beat % 4 == 3) {
                    for (i in 0...2) {
                        tweenStart({obj_game: obj_game, prop: "field." + i}, {z : 100}, 0.3, TweenEase.OUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "field." + i}, {z : 0}, 0.3, TweenEase.IN_QUAD, 0.3);
                    }
                }
                for (i in 0...8) { //angle & horizontal bounce
                    if (beat % 4 == 3) {
                        prop_set(obj_game, "strums." + i + ".ang3D.z", 360.0); // Use Float
                    }
                    tweenStart({obj_game: obj_game, prop: "strums." + i + ".ang3D"}, {z : a / 7}, 0.18, TweenEase.INOUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "strums." + i + ".ang3D"}, {z : 0}, 0.18, TweenEase.INOUT_QUAD, 0.18);

                    if (i % 2 == 1) { a = a * -1; }

                    var sx:Float = (i % 4) - 2 * 50; // Calculation seems off, check original intent. (i%4) is 0..3, result is -100..-97? Maybe (i % 4 - 2) * 50? Assuming original Lua is correct.
                    tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {x : sx + a * 1.2}, 0.2, TweenEase.OUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {x : sx}, 0.2, TweenEase.IN_QUAD, 0.2);

                    if (beat % 4 == i % 4) {
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {z : -300}, 0.2, TweenEase.OUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {z : 0}, 0.2, TweenEase.IN_QUAD, 0.2);
                    }
                }

                var up:Float = 400;
                var shift:Float = 50;
                if (modBeat == 0) { //show opponent, hide player
                    tweenStart({obj_game: obj_game, prop: "field.1"}, {x : 300, y : shift}, 0.9, TweenEase.OUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "field.0"}, {y : -300}, 0.5, TweenEase.IN_QUAD);
                }
                else if (modBeat == 4) { //shift half receptors upwards (start moving field)
                    for (i in 4...8) { // Haxe range 4...8 means 4, 5, 6, 7
                       if (i % 2 == 0) { // Equivalent to Lua step 2 (4, 6)
                            tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {y : up}, 2, TweenEase.INOUT_QUAD);
                            tweenStart({obj_game: obj_game, prop: "strums." + i + ".dir"}, {x : -180}, 2, TweenEase.INOUT_QUAD);
                       }
                    }
                    tweenStart({obj_game: obj_game, prop: "field.1"}, {x : 500}, 8, TweenEase.LINEAR);
                }
                else if (modBeat == 12) { //the other half
                     for (i in 5...8) { // Haxe range 5...8 means 5, 6, 7
                       if (i % 2 != 0) { // Equivalent to Lua step 2 (5, 7)
                            tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {y : up}, 2, TweenEase.INOUT_QUAD);
                            tweenStart({obj_game: obj_game, prop: "strums." + i + ".dir"}, {x : -180}, 2, TweenEase.INOUT_QUAD);
                       }
                    }
                }
                else if (modBeat == 18) {
                    for (i in 4...8) {
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0.p.0"}, {x : 20}, 1, TweenEase.INOUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0"}, {w : 0.8, a : 270.0 - 30.0}, 1, TweenEase.INOUT_QUAD);
                    }
                }
                else if (modBeat == 26 || modBeat == 28) {
                    for (i in 4...8) {
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".ang3D"}, {x : -45}, 0.2, TweenEase.OUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".ang3D"}, {x : 0}, 0.2, TweenEase.IN_QUAD, 0.2);
                    }
                }
                else if (modBeat == 30) { //show player hide opponent
                    tweenStart({obj_game: obj_game, prop: "field.1"}, {x : 0, y : -300}, 0.9, TweenEase.IN_QUAD);
                    tweenStart({obj_game: obj_game, prop: "field.0"}, {x : -200, y : shift}, 0.5, TweenEase.OUT_QUAD);
                    for (i in 4...8) {
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {y : 0}, 1, TweenEase.INOUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".dir"}, {x : 0}, 1, TweenEase.INOUT_QUAD);
                    }
                }
                else if (modBeat == 36) { //movii (starts)
                    for (i in 0...4) { // Haxe range 0...4 means 0, 1, 2, 3
                       if (i % 2 == 0) { // Equivalent to Lua step 2 (0, 2)
                            tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {y : up}, 2, TweenEase.INOUT_QUAD);
                            tweenStart({obj_game: obj_game, prop: "strums." + i + ".dir"}, {x : -180}, 2, TweenEase.INOUT_QUAD);
                       }
                    }
                    tweenStart({obj_game: obj_game, prop: "field.0"}, {x : -400}, 8, TweenEase.LINEAR);
                }
                else if (modBeat == 44) { //the other half
                    for (i in 1...4) { // Haxe range 1...4 means 1, 2, 3
                       if (i % 2 != 0) { // Equivalent to Lua step 2 (1, 3)
                            tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {y : up}, 2, TweenEase.INOUT_QUAD);
                            tweenStart({obj_game: obj_game, prop: "strums." + i + ".dir"}, {x : -180}, 2, TweenEase.INOUT_QUAD);
                       }
                    }
                }
                else if (modBeat == 50) {
                    for (i in 0...4) {
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0.p.0"}, {x : -20}, 1, TweenEase.INOUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0"}, {w : 0.8, a : 270.0 + 30.0}, 1, TweenEase.INOUT_QUAD);
                    }
                }
                else if (modBeat == 58 || modBeat == 60) {
                    for (i in 0...4) {
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".ang3D"}, {x : -45}, 0.2, TweenEase.OUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".ang3D"}, {x : 0}, 0.2, TweenEase.IN_QUAD, 0.2);
                    }
                }
            }
            else if (mod == 2) {
                if (modBeat % 4 == 0) {
                    for (i in 0...8) {
                        // Assuming p is an array with at least 2 elements
                        prop_set(obj_game, "strums." + i + ".lines.0.p.0.z", 0.0);
                        prop_set(obj_game, "strums." + i + ".lines.0.p.1.z", 0.0);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0.p.0"}, {x : 300}, 0.05, TweenEase.OUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0.p.1"}, {x : -300}, 0.05, TweenEase.OUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0.p.0"}, {x : 0}, 0.3, TweenEase.IN_QUAD, 0.05);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0.p.1"}, {x : 0}, 0.3, TweenEase.IN_QUAD, 0.05);
                    }
                }
                if (modBeat % 4 == 3) {
                    for (i in 0...8) {
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0.p.0"}, {x : -300}, 0.3, TweenEase.INOUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0.p.1"}, {x : 300}, 0.3, TweenEase.INOUT_QUAD);
                    }
                    //[[
                    //for i = 0, 7, 1 do
                    //    tweenStart({obj_game, "strums."..i..".lines.0.p.0"}, {z = 1000}, 0.3, "in_quad");
                    //    tweenStart({obj_game, "strums."..i..".lines.0.p.1"}, {z = -1000}, 0.3, "in_quad");
                    //end]]
                    /*
                    for (i in 0...8) {
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0.p.0"}, {z : 1000}, 0.3, TweenEase.IN_QUAD);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0.p.1"}, {z : -1000}, 0.3, TweenEase.IN_QUAD);
                    }
                    */
                }

                var a:Float = 8;
                if (modBeat % 2 == 1) { a = a*-1; }
                for (i in 0...8) {
                    tweenStart({obj_game: obj_game, prop: "strums." + i + ".ang3D"}, {z : a}, 0.2, TweenEase.OUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "strums." + i + ".ang3D"}, {z : 0}, 0.2, TweenEase.IN_QUAD, 0.2);
                    var ind:Array<Int> = [3, 2, 0, 1]; // Lua: {3, 2, 0, 1}
                    // Lua: ind[i % 4 + 1] -> Haxe: ind[i % 4]
                    if (beat % 4 == ind[i % 4]) {
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".ang3D"}, {y : a * 4}, 0.2, TweenEase.OUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".ang3D"}, {y : 0}, 0.2, TweenEase.IN_QUAD, 0.2);
                    }
                }

                if (modBeat == 1) {
                    //tweenStart({obj_game, "field.1"}, {z = -200}, 7, "linear");
                }
                else if (modBeat == 14) {
                    tweenStart({obj_game: obj_game, prop: "field.0"}, {x : -380, y : centerY}, 0.3, TweenEase.INOUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "field.0"}, {z : -100}, 0.5, TweenEase.INOUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "field.1"}, {x : 0, z : -400}, 0.2, TweenEase.INOUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "field.1"}, {y : -400, z : 0}, 0.7, TweenEase.IN_ELASTIC);
                }
                else if (modBeat == 16) {
                    //tweenStart({obj_game, "field.0"}, {z = -200}, 7, "linear");
                    for (i in 4...8) {
                        prop_set(obj_game, "strums." + i + ".pos.x", 0.0);
                        prop_set(obj_game, "strums." + i + ".pos.y", 0.0);
                        prop_set(obj_game, "strums." + i + ".dir.z", -180.0);
                    }
                }
                else if (modBeat == 32) {
                    tweenStart({obj_game: obj_game, prop: "field.1"}, {y : 0}, 0.4, TweenEase.OUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "field.0"}, {x : 0}, 0.6, TweenEase.INOUT_QUAD);
                    for (i in 4...8) {
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".dir"}, {z : 0}, 0.4, TweenEase.OUT_QUAD);
                    }
                }
                else if (modBeat == 46) {
                    tweenStart({obj_game: obj_game, prop: "field.1"}, {y : -400, z : 0}, 0.7, TweenEase.IN_ELASTIC);
                    tweenStart({obj_game: obj_game, prop: "field.0"}, {x : -380}, 0.6, TweenEase.INOUT_QUAD);
                }
                else if (modBeat == 48) {
                    var l:Float = Sys.skin.sep;

                    tweenStart({obj_game: obj_game, prop: "strums.0.pos"}, {x : l * 1.5}, 6, TweenEase.INOUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "strums.3.pos"}, {x : -l * 1.5}, 6, TweenEase.INOUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "strums.1.pos"}, {x : l / 2, y : 0}, 6, TweenEase.INOUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "strums.2.pos"}, {x : -l / 2, y : 0}, 6, TweenEase.INOUT_QUAD);

                    for (i in 0...4) {
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.0"}, {a : 270.0 + 100.0}, 6, TweenEase.INOUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".lines.1"}, {a : 270.0 + 100.0}, 6, TweenEase.INOUT_QUAD);
                    }
                }
            }
            else if (mod == 3) {
                if (subMod < 3) {
                    for (i in 0...8) {
                        var h:Float = 20;
                        if (beat % 2 == 0) { h = h * -1; }
                        if (i % 2 == 0) { h = h * -1; }
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {z : 40 + h}, 0.2, TweenEase.OUT_QUAD);
                        tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {z : 0}, 0.2, TweenEase.IN_QUAD, 0.2);
                    }
                }

                if (modBeat == 12 || modBeat == 14) {
                    tweenStart({obj_game: obj_game, prop: "field.1"}, {z : -100}, 0.2, TweenEase.OUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "field.1"}, {z : 0}, 0.2, TweenEase.IN_QUAD, 0.2);

                    tweenStart({obj_game: obj_game, prop: "field.0"}, {z : 100}, 0.2, TweenEase.OUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "field.0"}, {z : 0}, 0.2, TweenEase.IN_QUAD, 0.2);
                }
                else if (modBeat == 44 || modBeat == 46) {
                    tweenStart({obj_game: obj_game, prop: "field.0"}, {z : -100}, 0.2, TweenEase.OUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "field.0"}, {z : 0}, 0.2, TweenEase.IN_QUAD, 0.2);

                    tweenStart({obj_game: obj_game, prop: "field.1"}, {z : 100}, 0.2, TweenEase.OUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "field.1"}, {z : 0}, 0.2, TweenEase.IN_QUAD, 0.2);
                }
            }
            else if (mod == 4) {
                for (i in 0...8) {
                    var h:Float = 20;
                    if (beat % 2 == 0) { h = h * -1; }
                    if (i % 4 >= 2) { h = h * -1; }
                    tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {y : h, z : -h}, 0.1, TweenEase.OUT_QUAD);
                    tweenStart({obj_game: obj_game, prop: "strums." + i + ".pos"}, {y : 0, z : 0}, 0.3, TweenEase.IN_QUAD, 0.1);
                }
            }
            else if (mod == 5) {
                var dumb:Int = (curSide + 1) % 2; // Assuming curSide is accessible and updated
                if (modBeat % 4 == 0) {
                    tweenStart({obj_game: obj_game, prop: "field." + dumb}, {y : 0}, 0.4, TweenEase.OUT_ELASTIC);
                }
                if (modBeat % 4 == 3) {
                    tweenStart({obj_game: obj_game, prop: "field." + dumb}, {y : 300}, 0.3, TweenEase.INOUT_QUAD);
                }
                if (modBeat % 32 == 0) {
                    var oSide:Int = (curSide + 1) % 2;
                    var w:Float = 200;
                    if (curSide == 0) {
                        w = w * -1;
                    }
                    tweenStart({obj_game: obj_game, prop: "field." + curSide}, {x : w, z : 0}, 1, TweenEase.OUT_QUAD);
                    // The last line in the Lua code was incomplete: tweenStart({obj_game, "field."..oSide}, {x = 0
                    // Assuming it intended to tween x to 0 and maybe z like the other field tween in mod 0.
                    // Translating the incomplete line as best as possible, assuming x=0 was the only property.
                    tweenStart({obj_game: obj_game, prop: "field." + oSide}, {x : 0}, 1, TweenEase.OUT_QUAD); // Duration and ease added based on context
                    // If more properties were intended, they need to be added here. Example: {x: 0, z: -100}
                    curSide = oSide; // Assuming curSide should be updated here as well
                }
            }
        }
    }
}
