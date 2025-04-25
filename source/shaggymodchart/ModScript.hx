package shaggymodchart;

import Math;
import Std;

// Assumed engine/framework imports (replace with actual paths if known)
import Sys; // Assuming access to Sys.skin.sep, Sys.options.downscroll
import MathUtil; // Assuming access to MathUtil.degreesToRadians, MathUtil.radiansToDegrees
import Engine.*; // Assuming access to obj_game, prop_set, tweenStart

class ModScript {
    public static var mod:Int = 0;
    public static var subMod:Int = 0;
    public static var modBeat:Int = 0;
    public static var modStep:Int = 0; // Initialized but never used in original code
    public static var started:Bool = false;

    // Global variables from Lua script, initialized in create() or statically
    static var l:Float;
    public static var cnt:Array<Float>;
    public static var centerY:Float = 270;
    public static var curSide:Int = 1; // Needs to persist across calls

    public static var rot:Float = 0;
    public static var rotspd:Float = 1;
    public static var circAng:Float; // Initialized in create()

    // create() function: Called once at the start
    public static function create():Void {
        // Initialize variables that depend on engine state potentially not ready at static init
        l = Sys.skin.sep; // Assumes Sys.skin.sep is available here
        cnt = [l * 1.5, l / 2, -l / 2, -l * 1.5];
        circAng = MathUtil.degreesToRadians(180); // Assumes MathUtil exists

        modInit(0);
    }

    // modInit function: Initializes or changes the mod state
    public static function modInit(Mod:Int):Void {
        mod = Mod;
        subMod = 0;
        modBeat = 0;
        modStep = 0; // Resetting the unused variable as in original
        tweenStart([obj_game, "field.0"], {x : 0., y : 0., z : 0.}, 0.1, "inout_quad");
        tweenStart([obj_game, "field.1"], {x : 0., y : 0., z : 0.}, 0.1, "inout_quad");
        for (i in 0...8) {
            prop_set(obj_game, "strums." + i + ".lines.0.p", []); // Set to empty array (equivalent to Lua {})
            tweenStart([obj_game, "strums." + i + ".lines.0"], {a : 270., ax : 0., ay : 0., w : 1.}, 0.1, "inout_quad");
            tweenStart([obj_game, "strums." + i + ".lines.1"], {a : 270., ax : 0., ay : 0., w : 1.}, 0.1, "inout_quad");
            tweenStart([obj_game, "strums." + i + ".pos"], {x : 0., y : 0., z : 0.}, 0.1, "inout_quad");
            tweenStart([obj_game, "strums." + i + ".ang3D"], {x : 0., y : 0., z : 0.}, 0.1, "inout_quad");
            tweenStart([obj_game, "strums." + i + ".dir"], {x : 0., y : 0., z : 0.}, 0.1, "inout_quad");
        }
        if (mod == 0) {
            curSide = 1; // Initialize/reset curSide
            for (i in 0...8) {
                prop_set(obj_game, "strums." + i + ".lines.0.p", [{x : 0., y : 360., z : 0.}]);
            }
        } else if (mod == 1) {
            for (i in 0...8) {
                prop_set(obj_game, "strums." + i + ".lines.0.p", [{x : 0., y : 360., z : 0.}]);
            }
        } else if (mod == 2) {
            for (i in 0...8) {
                prop_set(obj_game, "strums." + i + ".lines.0.p", [{x : 0., y : 720. / 4., z : 0.}, {x : 0., y : 720. / 4. * 3., z : 0.}]);
            }

            var l:Float = Sys.skin.sep; // Local variable 'l', shadows static 'l'
            var woo:Float = l * 0.8;
            for (i in 0...2) {
                //idk
                var num0:Int = i * 4;
                var num1:Int = i * 4 + 1;
                var num2:Int = i * 4 + 2;
                var num3:Int = i * 4 + 3;

                var vdir:Float = 1;

                if (Sys.options.downscroll) { // Assumes Sys.options.downscroll exists
                    vdir = -1;
                }
                tweenStart([obj_game, "strums." + num0 + ".pos"], {x : l * 1.5 - woo}, 0.2, "inout_quad");
                tweenStart([obj_game, "strums." + num3 + ".pos"], {x : -l * 1.5 + woo}, 0.2, "inout_quad");
                tweenStart([obj_game, "strums." + num1 + ".pos"], {x : l / 2, y : woo * vdir}, 0.2, "inout_quad");
                tweenStart([obj_game, "strums." + num2 + ".pos"], {x : -l / 2, y : -woo * vdir}, 0.2, "inout_quad");
            }
            tweenStart([obj_game, "field.1"], {x : 380., y : centerY}, 0.3, "inout_quad");
            tweenStart([obj_game, "field.1"], {z : -100.}, 0.5, "inout_quad");
            tweenStart([obj_game, "field.0"], {y : 380.}, 1, "inout_quad");

            var an:Array<Float> = [-90, 0, 180, 90];
            if (Sys.options.downscroll) {
                an[1] = 180; // Haxe array index 1 (second element)
                an[2] = 0;   // Haxe array index 2 (third element)
            }
            for (i in 0...8) {
                tweenStart([obj_game, "strums." + i + ".dir"], {z : an[i % 4]}, 0.2, "inout_quad"); // Use Haxe 0-based index
            }
        } else if (mod == 3) {
            tweenStart([obj_game, "field.1"], {x : 380., y : centerY}, 0.8, "out_quad");
            tweenStart([obj_game, "field.0"], {x : -380., y : centerY}, 0.8, "out_quad");
            for (i in 0...8) {
                tweenStart([obj_game, "strums." + i + ".lines.0"], {ay : -60., w : 0.9}, 0.11, "inout_quad");
                prop_set(obj_game, "strums." + i + ".lines.0.p", [{x : 0., y : 200., z : 100.}]);
                tweenStart([obj_game, "strums." + i + ".lines.1"], {ay : -90.}, 0.11, "inout_quad");
                tweenStart([obj_game, "strums." + i + ".pos"], {x : cnt[i % 4]}, 0.11, "inout_quad"); // Use Haxe 0-based index
            }
        } else if (mod == 4) {
            for (i in 0...8) {
                var w:Float = 80;
                if (i % 4 < 2) { w = w * -1; }
                tweenStart([obj_game, "strums." + i + ".lines.0"], {ay : -30.}, 0.11, "inout_quad");
                prop_set(obj_game, "strums." + i + ".lines.0.p", [{x : 0., y : 360., z : 40.}]);
                tweenStart([obj_game, "strums." + i + ".pos"], {x : cnt[i % 4] + w}, 0.11, "inout_quad"); // Use Haxe 0-based index
            }
        } else if (mod == 5) {
            for (i in 0...8) {
                tweenStart([obj_game, "strums." + i + ".dir"], {x : 50.}, 1, "inout_quad");
                tweenStart([obj_game, "strums." + i + ".ang3D"], {x : -50.}, 1, "inout_quad");
            }
        }
    }

    // update function: Called every frame
    public static function update(elapsed:Float):Void {
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
            } else if (mod == 3) {
                if (subMod == 2) {
                    rotspd = rotspd + elapsed;
                } else if (subMod == 3) {
                    rotspd = rotspd - elapsed * 1.21;
                    if (rotspd < 0) {
                        rotspd = 0;
                    } else {
                        // Lua: math.random(-4, 4) -> Haxe: Std.random(9) - 4 for integers
                        tweenStart([obj_game, "field.1"], {x : 380. + (Std.random(9) - 4), y : centerY + (Std.random(9) - 4)}, 0.01, "out_quad");
                        tweenStart([obj_game, "field.0"], {x : -380. + (Std.random(9) - 4), y : centerY + (Std.random(9) - 4)}, 0.01, "out_quad");
                    }
                }
                circAng = circAng + elapsed * rotspd;
                for (i in 0...8) {
                    var off:Float = -((i % 4) - 2) / 2.5;
                    var len:Float = 300;
                    var xlen:Float = len;
                    if (subMod >= 1) { xlen = 500; }
                    var an:Float = circAng + off;
                    if (i < 4) { an = an + MathUtil.degreesToRadians(180); } // Assumes MathUtil exists
                    prop_set(obj_game, "strums." + i + ".pos.x", cnt[i % 4] + Math.cos(an) * xlen); // Use Haxe 0-based index
                    prop_set(obj_game, "strums." + i + ".pos.y", -Math.sin(an) * len);

                    prop_set(obj_game, "strums." + i + ".dir.z", 270 + MathUtil.radiansToDegrees(an - off)); // Assumes MathUtil exists
                }
            } else if (mod == 5) {
                //[[ -- Preserving Lua block comment style
                //for i = 0, 7, 1 do
                //    prop_set(obj_game, "strums."..i..".pos.z", math.cos(rot + i) * 100);
                //end]]
            }
        }
    }

    // onBeatHit function: Called on each beat
    public static function onBeatHit(beat:Int):Void {
        //prop_set(obj_game, "strums.1.pos.x", -40);
        //obj_fnf.gf.prop.beatDance = 4; // Assuming obj_fnf is another engine object if uncommented
        //console_add(s.xscale); // Assuming console_add and 's' exist if uncommented

        if (beat == 0) {
            started = true;
        }

        if (started) {
            // Update mod/subMod based on beat
            if (beat == 32) {
                subMod = 1;
            } else if (beat == 64) {
                modInit(1);
            } else if (beat == 128) {
                modInit(2);
            } else if (beat == 192) {
                modInit(3);
            } else if (beat == 256) {
                modInit(4);
            } else if (beat == 296) {
                modInit(0);
            } else if (beat == 288) {
                mod = -1; // Special state?
                for (i in 0...8) {
                    tweenStart([obj_game, "strums." + i + ".pos"], {x : 0., y : 0., z : 0.}, 3, "inout_quad");
                }
            } else if (beat == 328) {
                modInit(5);
            } else if (beat == 392) {
                modInit(3);
                subMod = 1;
            } else if (beat == 456) {
                subMod = 2;
            } else if (beat == 464) {
                subMod = 3;
            }

            // Beat-based animations per mod
            if (mod == 0) {
                for (i in 0...8) {
                    var h:Float = 20;
                    if (beat % 2 == 0) { h = h * -1; }
                    if (i % 2 == 0) { h = h * -1; }
                    tweenStart([obj_game, "strums." + i + ".pos"], {y : 40. + h}, 0.2, "out_quad");
                    tweenStart([obj_game, "strums." + i + ".pos"], {y : 0.}, 0.2, "in_quad", 0.2);

                    //prop_set(obj_game, "strums."..i..".lines.0.p.0.x", h); // Original commented out? No, this was active. Needs prop_set
                    // Assuming "strums."..i..".lines.0.p.0" refers to the first point in the 'p' array.
                    // prop_set might not support direct indexing into array elements via path string.
                    // This requires clarification on how prop_set works. Assuming it does for now.
                    // If not, manual property access would be needed:
                    // var lineP = Reflect.getProperty(Reflect.getProperty(Reflect.getProperty(obj_game, "strums."+i), "lines.0"), "p");
                    // if (lineP != null && lineP[0] != null) lineP[0].x = h; // This is non-trivial
                    // Sticking to direct prop_set translation as requested.

                    h = 100; // Reassign h
                    if (beat % 2 == 0) { h = h * -1; }
                    tweenStart([obj_game, "strums." + i + ".lines.0.p.0"], {x : h}, 0.2, "out_quad"); // Assumes tweenStart can target sub-properties like this
                    tweenStart([obj_game, "strums." + i + ".lines.0.p.0"], {x : 0.}, 0.2, "in_quad", 0.2);
                }

                if (modBeat % 16 == 0) {
                    var oSide:Int = (curSide + 1) % 2;
                    var w:Float = 200;
                    if (curSide == 0) {
                        w = w * -1;
                    }
                    tweenStart([obj_game, "field." + curSide], {x : w, z : 0.}, 1, "out_quad");
                    tweenStart([obj_game, "field." + oSide], {x : 0., z : -100.}, 1, "out_quad");
                    curSide = oSide;
                }
            } else if (mod == 1) {
                var a:Float = 30;
                if (beat % 2 == 1) { a = a * -1; }
                if (beat % 4 == 3) {
                    for (i in 0...2) {
                        tweenStart([obj_game, "field." + i], {z : 100.}, 0.3, "out_quad");
                        tweenStart([obj_game, "field." + i], {z : 0.}, 0.3, "in_quad", 0.3);
                    }
                }
                for (i in 0...8) { //angle & horizontal bounce
                    if (beat % 4 == 3) {
                        prop_set(obj_game, "strums." + i + ".ang3D.z", 360.);
                    }
                    tweenStart([obj_game, "strums." + i + ".ang3D"], {z : a / 7}, 0.18, "inout_quad");
                    tweenStart([obj_game, "strums." + i + ".ang3D"], {z : 0.}, 0.18, "inout_quad", 0.18);

                    if (i % 2 == 1) { a = a * -1; } // 'a' changes mid-loop

                    var sx:Float = (i % 4) - 2 * 50; // Calculation seems off vs Lua? Lua: (i % 4) - 2 * 50 = -100, -50, 0, 50 ? No, Lua precedence: (i%4) - (2*50). Let's assume that.
                    // If it meant ((i % 4) - 2) * 50, the result would be different. Assuming Lua precedence: (i%4) - 100.
                    sx = (i % 4) - 100.;
                    tweenStart([obj_game, "strums." + i + ".pos"], {x : sx + a * 1.2}, 0.2, "out_quad");
                    tweenStart([obj_game, "strums." + i + ".pos"], {x : sx}, 0.2, "in_quad", 0.2);

                    if (beat % 4 == i % 4) {
                        tweenStart([obj_game, "strums." + i + ".pos"], {z : -300.}, 0.2, "out_quad");
                        tweenStart([obj_game, "strums." + i + ".pos"], {z : 0.}, 0.2, "in_quad", 0.2);
                    }
                }

                var up:Float = 400;
                var shift:Float = 50;
                if (modBeat == 0) { //show opponent, hide player
                    tweenStart([obj_game, "field.1"], {x : 300., y : shift}, 0.9, "out_quad");
                    tweenStart([obj_game, "field.0"], {y : -300.}, 0.5, "in_quad");
                } else if (modBeat == 4) { //shift half receptors upwards (start moving field)
                    for (i in 4...8) { // Haxe range 4...8 -> 4, 5, 6, 7
                       if (i % 2 == 0) { // Lua: 4, 7, 2 -> 4, 6
                            tweenStart([obj_game, "strums." + i + ".pos"], {y : up}, 2, "inout_quad");
                            tweenStart([obj_game, "strums." + i + ".dir"], {x : -180.}, 2, "inout_quad");
                       }
                    }
                    tweenStart([obj_game, "field.1"], {x : 500.}, 8, "linear");
                } else if (modBeat == 12) { //the other half
                     for (i in 5...8) { // Haxe range 5...8 -> 5, 6, 7
                       if (i % 2 != 0) { // Lua: 5, 7, 2 -> 5, 7
                            tweenStart([obj_game, "strums." + i + ".pos"], {y : up}, 2, "inout_quad");
                            tweenStart([obj_game, "strums." + i + ".dir"], {x : -180.}, 2, "inout_quad");
                       }
                    }
                } else if (modBeat == 18) {
                    for (i in 4...8) {
                        tweenStart([obj_game, "strums." + i + ".lines.0.p.0"], {x : 20.}, 1, "inout_quad"); // Assumes tween target works
                        tweenStart([obj_game, "strums." + i + ".lines.0"], {w : 0.8, a : 270. - 30.}, 1, "inout_quad");
                    }
                } else if (modBeat == 26 || modBeat == 28) {
                    for (i in 4...8) {
                        tweenStart([obj_game, "strums." + i + ".ang3D"], {x : -45.}, 0.2, "out_quad");
                        tweenStart([obj_game, "strums." + i + ".ang3D"], {x : 0.}, 0.2, "in_quad", 0.2);
                    }
                } else if (modBeat == 30) { //show player hide opponent
                    tweenStart([obj_game, "field.1"], {x : 0., y : -300.}, 0.9, "in_quad");
                    tweenStart([obj_game, "field.0"], {x : -200., y : shift}, 0.5, "out_quad");
                    for (i in 4...8) {
                        tweenStart([obj_game, "strums." + i + ".pos"], {y : 0.}, 1, "inout_quad");
                        tweenStart([obj_game, "strums." + i + ".dir"], {x : 0.}, 1, "inout_quad");
                    }
                } else if (modBeat == 36) { //movii (starts)
                    for (i in 0...4) { // Haxe range 0...4 -> 0, 1, 2, 3
                       if (i % 2 == 0) { // Lua: 0, 3, 2 -> 0, 2
                            tweenStart([obj_game, "strums." + i + ".pos"], {y : up}, 2, "inout_quad");
                            tweenStart([obj_game, "strums." + i + ".dir"], {x : -180.}, 2, "inout_quad");
                       }
                    }
                    tweenStart([obj_game, "field.0"], {x : -400.}, 8, "linear");
                } else if (modBeat == 44) { //the other half
                    for (i in 1...4) { // Haxe range 1...4 -> 1, 2, 3
                       if (i % 2 != 0) { // Lua: 1, 3, 2 -> 1, 3
                            tweenStart([obj_game, "strums." + i + ".pos"], {y : up}, 2, "inout_quad");
                            tweenStart([obj_game, "strums." + i + ".dir"], {x : -180.}, 2, "inout_quad");
                       }
                    }
                } else if (modBeat == 50) {
                    for (i in 0...4) {
                        tweenStart([obj_game, "strums." + i + ".lines.0.p.0"], {x : -20.}, 1, "inout_quad"); // Assumes tween target works
                        tweenStart([obj_game, "strums." + i + ".lines.0"], {w : 0.8, a : 270. + 30.}, 1, "inout_quad");
                    }
                } else if (modBeat == 58 || modBeat == 60) {
                    for (i in 0...4) {
                        tweenStart([obj_game, "strums." + i + ".ang3D"], {x : -45.}, 0.2, "out_quad");
                        tweenStart([obj_game, "strums." + i + ".ang3D"], {x : 0.}, 0.2, "in_quad", 0.2);
                    }
                }
            } else if (mod == 2) {
                if (modBeat % 4 == 0) {
                    for (i in 0...8) {
                        // Assuming prop_set can target sub-properties like this
                        prop_set(obj_game, "strums." + i + ".lines.0.p.0.z", 0.);
                        prop_set(obj_game, "strums." + i + ".lines.0.p.1.z", 0.);
                        tweenStart([obj_game, "strums." + i + ".lines.0.p.0"], {x : 300.}, 0.05, "out_quad"); // Assumes tween target works
                        tweenStart([obj_game, "strums." + i + ".lines.0.p.1"], {x : -300.}, 0.05, "out_quad"); // Assumes tween target works
                        tweenStart([obj_game, "strums." + i + ".lines.0.p.0"], {x : 0.}, 0.3, "in_quad", 0.05); // Assumes tween target works
                        tweenStart([obj_game, "strums." + i + ".lines.0.p.1"], {x : 0.}, 0.3, "in_quad", 0.05); // Assumes tween target works
                    }
                }
                if (modBeat % 4 == 3) {
                    for (i in 0...8) {
                        tweenStart([obj_game, "strums." + i + ".lines.0.p.0"], {x : -300.}, 0.3, "inout_quad"); // Assumes tween target works
                        tweenStart([obj_game, "strums." + i + ".lines.0.p.1"], {x : 300.}, 0.3, "inout_quad"); // Assumes tween target works
                    }
                    //[[ -- Preserving Lua block comment style
                    //for i = 0, 7, 1 do
                    //    tweenStart({obj_game, "strums."..i..".lines.0.p.0"}, {z = 1000}, 0.3, "in_quad");
                    //    tweenStart({obj_game, "strums."..i..".lines.0.p.1"}, {z = -1000}, 0.3, "in_quad");
                    //end]]
                }

                var a:Float = 8;
                if (modBeat % 2 == 1) { a = a * -1; }
                for (i in 0...8) {
                    tweenStart([obj_game, "strums." + i + ".ang3D"], {z : a}, 0.2, "out_quad");
                    tweenStart([obj_game, "strums." + i + ".ang3D"], {z : 0.}, 0.2, "in_quad", 0.2);
                    var ind:Array<Int> = [3, 2, 0, 1]; // Lua: {3, 2, 0, 1}
                    if (beat % 4 == ind[i % 4]) { // Use Haxe 0-based index
                        tweenStart([obj_game, "strums." + i + ".ang3D"], {y : a * 4}, 0.2, "out_quad");
                        tweenStart([obj_game, "strums." + i + ".ang3D"], {y : 0.}, 0.2, "in_quad", 0.2);
                    }
                }

                if (modBeat == 1) {
                    //tweenStart({obj_game, "field.1"}, {z = -200}, 7, "linear");
                } else if (modBeat == 14) {
                    tweenStart([obj_game, "field.0"], {x : -380., y : centerY}, 0.3, "inout_quad");
                    tweenStart([obj_game, "field.0"], {z : -100.}, 0.5, "inout_quad");
                    tweenStart([obj_game, "field.1"], {x : 0., z : -400.}, 0.2, "inout_quad");
                    tweenStart([obj_game, "field.1"], {y : -400., z : 0.}, 0.7, "in_elastic");
                } else if (modBeat == 16) {
                    //tweenStart({obj_game, "field.0"}, {z = -200}, 7, "linear");
                    for (i in 4...8) {
                        prop_set(obj_game, "strums." + i + ".pos.x", 0.);
                        prop_set(obj_game, "strums." + i + ".pos.y", 0.);
                        prop_set(obj_game, "strums." + i + ".dir.z", -180.);
                    }
                } else if (modBeat == 32) {
                    tweenStart([obj_game, "field.1"], {y : 0.}, 0.4, "out_quad");
                    tweenStart([obj_game, "field.0"], {x : 0.}, 0.6, "inout_quad");
                    for (i in 4...8) {
                        tweenStart([obj_game, "strums." + i + ".dir"], {z : 0.}, 0.4, "out_quad");
                    }
                } else if (modBeat == 46) {
                    tweenStart([obj_game, "field.1"], {y : -400., z : 0.}, 0.7, "in_elastic");
                    tweenStart([obj_game, "field.0"], {x : -380.}, 0.6, "inout_quad");
                } else if (modBeat == 48) {
                    var l:Float = Sys.skin.sep; // Local variable 'l', shadows static 'l'

                    tweenStart([obj_game, "strums.0.pos"], {x : l * 1.5}, 6, "inout_quad");
                    tweenStart([obj_game, "strums.3.pos"], {x : -l * 1.5}, 6, "inout_quad");
                    tweenStart([obj_game, "strums.1.pos"], {x : l / 2, y : 0.}, 6, "inout_quad");
                    tweenStart([obj_game, "strums.2.pos"], {x : -l / 2, y : 0.}, 6, "inout_quad");

                    for (i in 0...4) {
                        tweenStart([obj_game, "strums." + i + ".lines.0"], {a : 270. + 100.}, 6, "inout_quad");
                        tweenStart([obj_game, "strums." + i + ".lines.1"], {a : 270. + 100.}, 6, "inout_quad");
                    }
                }
            } else if (mod == 3) {
                if (subMod < 3) {
                    for (i in 0...8) {
                        var h:Float = 20;
                        if (beat % 2 == 0) { h = h * -1; }
                        if (i % 2 == 0) { h = h * -1; }
                        tweenStart([obj_game, "strums." + i + ".pos"], {z : 40. + h}, 0.2, "out_quad");
                        tweenStart([obj_game, "strums." + i + ".pos"], {z : 0.}, 0.2, "in_quad", 0.2);
                    }
                }

                if (modBeat == 12 || modBeat == 14) {
                    tweenStart([obj_game, "field.1"], {z : -100.}, 0.2, "out_quad");
                    tweenStart([obj_game, "field.1"], {z : 0.}, 0.2, "in_quad", 0.2);

                    tweenStart([obj_game, "field.0"], {z : 100.}, 0.2, "out_quad");
                    tweenStart([obj_game, "field.0"], {z : 0.}, 0.2, "in_quad", 0.2);
                } else if (modBeat == 44 || modBeat == 46) {
                    tweenStart([obj_game, "field.0"], {z : -100.}, 0.2, "out_quad");
                    tweenStart([obj_game, "field.0"], {z : 0.}, 0.2, "in_quad", 0.2);

                    tweenStart([obj_game, "field.1"], {z : 100.}, 0.2, "out_quad");
                    tweenStart([obj_game, "field.1"], {z : 0.}, 0.2, "in_quad", 0.2);
                }
            } else if (mod == 4) {
                for (i in 0...8) {
                    var h:Float = 20;
                    if (beat % 2 == 0) { h = h * -1; }
                    if (i % 4 >= 2) { h = h * -1; }
                    tweenStart([obj_game, "strums." + i + ".pos"], {y : h, z : -h}, 0.1, "out_quad");
                    tweenStart([obj_game, "strums." + i + ".pos"], {y : 0., z : 0.}, 0.3, "in_quad", 0.1);
                }
            } else if (mod == 5) {
                var dumb:Int = (curSide + 1) % 2;
                if (modBeat % 4 == 0) {
                    tweenStart([obj_game, "field." + dumb], {y : 0.}, 0.4, "out_elastic");
                }
                if (modBeat % 4 == 3) {
                    tweenStart([obj_game, "field." + dumb], {y : 300.}, 0.3, "inout_quad");
                }
                if (modBeat % 32 == 0) {
                    var oSide:Int = (curSide + 1) % 2;
                    var w:Float = 200;
                    if (curSide == 0) {
                        w = w * -1;
                    }
                    tweenStart([obj_game, "field." + curSide], {x : w, z : 0.}, 1, "out_quad");
                    tweenStart([obj_game, "field." + oSide], {x : 0.}, 1, "out_quad"); 

            modBeat = modBeat + 1; // Increment modBeat AFTER using its value for the current beat
        }
    } // End of onBeatHit
} // End of class ModScript

// Helper classes/typedefs assumed to be defined elsewhere or provided by the engine:
// - Sys: Provides Sys.skin.sep, Sys.options.downscroll
// - MathUtil: Provides MathUtil.degreesToRadians, MathUtil.radiansToDegrees
// - Engine: Provides obj_game, prop_set, tweenStart
// - Ease functions (e.g., "inout_quad") are assumed to be handled by tweenStart

// Example stubs for assumed external functions/variables (replace with actual implementations)
class Sys {
    public static var skin = { sep: 160.0 }; // Example value
    public static var options = { downscroll: false }; // Example value
}

class MathUtil {
    public static inline function degreesToRadians(degrees:Float):Float {
        return degrees * Math.PI / 180;
    }
    public static inline function radiansToDegrees(radians:Float):Float {
        return radians * 180 / Math.PI;
    }
}

// Global object placeholder
@:expose("obj_game") // Example of exposing if needed globally
var obj_game:Dynamic = { }; // Placeholder, should be the actual game object reference

// Global function placeholders
function prop_set(target:Dynamic, propertyPath:String, value:Dynamic):Void {
    // Placeholder implementation - requires actual engine function
    // This is complex to implement generically for paths like "strums.0.lines.0.p.0.x"
    //trace('prop_set: ${propertyPath} = ${value}');
    var parts = propertyPath.split(".");
    var obj = target;
    for (i in 0...parts.length - 1) {
        if (obj == null) return;
        var part = parts[i];
        // Handle array indexing like "lines.0" if necessary
        var num = Std.parseInt(part);
        if (Math.isNaN(num)) { // Check if it's not a number
             obj = Reflect.getProperty(obj, part);
        } else {
             // Assume array access if it's a number
             if (obj != null && Reflect.hasField(obj, "length") && num < Reflect.getProperty(obj, "length")) {
                 obj = obj[num];
             } else {
                 obj = null; // Path doesn't exist
             }
        }

    }
    if (obj != null) {
         var finalPart = parts[parts.length - 1];
         var num = Std.parseInt(finalPart);
         if (Math.isNaN(num)) {
            Reflect.setField(obj, finalPart, value);
         } else {
            // Assume array access
             if (obj != null && Reflect.hasField(obj, "length") && num < Reflect.getProperty(obj, "length")) {
                 obj[num] = value;
             }
         }
    }
}

function tweenStart(target:Dynamic, properties:Dynamic, duration:Float, ease:String, ?delay:Float):Void {
    // Placeholder implementation - requires actual engine tweening library
    var targetObject:Dynamic = null;
    var propertyPath:String = null;

    if (Std.isOfType(target, Array) && (target : Array<Dynamic>).length == 2) {
        targetObject = target[0];
        propertyPath = target[1];
        // Need to tween the property at propertyPath on targetObject
        // This requires integration with a tween library that supports dynamic property setting or reflection.
        // trace('tweenStart complex target: ${propertyPath} on ${targetObject} with props ${properties}');

    } else {
         // Assume target is the object itself if not the array format
         targetObject = target;
         // trace('tweenStart simple target: ${targetObject} with props ${properties}');
    }

    // Actual tweening logic using a library like Actuate, Tweener, etc. would go here.
    // Example using trace:
    var delayStr = (delay == null) ? "" : ' delay: ${delay}';
    //trace('tweenStart: Target: ${targetObject} Path: ${propertyPath} Props: ${properties} Duration: ${duration} Ease: ${ease}${delayStr}');

     // Handle the incomplete call from the original Lua code gracefully if possible
     if (properties == null) {
         // trace("Warning: tweenStart called with null properties (likely from incomplete translated code)");
         return;
     }
}

// Dummy Engine class if needed
class Engine {
    public static var obj_game(get, never):Dynamic; // Make obj_game accessible via Engine.obj_game
    static function get_obj_game():Dynamic { return obj_game; } // Access global obj_game

    public static function prop_set(target:Dynamic, propertyPath:String, value:Dynamic):Void {
        prop_set(target, propertyPath, value); // Call global placeholder
    }
     public static function tweenStart(target:Dynamic, properties:Dynamic, duration:Float, ease:String, ?delay:Float):Void {
        tweenStart(target, properties, duration, ease, delay); // Call global placeholder
    }
}
