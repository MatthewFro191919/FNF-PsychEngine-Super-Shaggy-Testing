package states.stages;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.geom.Point;
import shaggymodchart.ModScript;
import states.stages.objects.*;

class CaveStage extends BaseStage
{

override function create()
{
    var bg = sprite_load("cavebg/bg");
    offset_setby_fraction(bg, 0.5, 0.5);
    var super_bg = sprite_load("cavebg/super_bg");
    offset_setby_fraction(super_bg, 0.5, 0.5);
    var es1 = sprite_load("cavebg/es1");
    offset_setby_fraction(es1, 0.5, 0.5);
    var cal1 = sprite_load("cavebg/cal1");
    offset_setby_fraction(cal1, 0.5, 0.5);
    var cal2 = sprite_load("cavebg/cal2");
    offset_setby_fraction(cal2, 0.5, 0.5);

    var ground = sprite_load("cavebg/ground");
    offset_setby_fraction(ground, 0.5, 0.35);
    var ceil = sprite_load("cavebg/ceil");
    offset_setby_fraction(ceil, 0.5, 1 - 0.1);

    obj_fnf.bf.x = 750;
    obj_fnf.dad.x = -750;
    prop_set(obj_fnf.bf, "prop.cam.0", obj_fnf.bf.prop.cam[1] - 300);
    prop_set(obj_fnf.bf, "prop.cam.1", obj_fnf.bf.prop.cam[2] - 50);
    obj_fnf.gf.x = 80;
    obj_fnf.camZoom = 0.55;
    obj_fnf.camToZoom = obj_fnf.camZoom;
}

function drawBG() {
    draw_set_color(c_black);
    draw_rectangle(-4000, -4000, 4000, 4000, false);
    draw_set_color(c_white);

    draw_sprite_scrolled(super_bg, 0, 0, -400, 0.1, 0.1);
    draw_sprite_scrolled(bg, 0, 0, 300, 0.3, 0.3);
    var gp = scroll_get_pos(0, -200, 0.1);
    draw_floor(ceil, 0, 0, -1200, gp[1], gp[2], true);

    draw_sprite_scrolled(cal2, 0, -70, -350, 0.5, 0.5);
    draw_sprite_scrolled(es1, 0, 0, 0, 0.6, 0.6);
    draw_sprite_scrolled(cal1, 0, -70, -600, 0.7, 0.7);
    var gp = scroll_get_pos(0, -100, 0.8);
    draw_floor(ground, 0, 0, 0, gp[1], gp[2]);
}
}
