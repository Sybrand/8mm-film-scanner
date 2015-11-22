$fn=180;

outside_diameter = 12.95;
outside_radius = outside_diameter/2;
tooth_part_height = 11.6;

hole_in_the_middle_diameter = 14;
hole_in_the_middle_radius = hole_in_the_middle_diameter / 2;
tooth_length = 3;
tooth_width = 1.5;

bottom();
translate([0, outside_diameter*1.5, 0])
    middle(outside_diameter);
translate([0, -outside_diameter*2.0, 0])
    bottom();

module bottom() {
    difference() {
        difference() {
            cylinder(8, 12, 12);
            translate([0,0,-1])
                cylinder(10, hole_in_the_middle_radius, hole_in_the_middle_radius);
        }
        female_tooth_width = tooth_width + 0.2;
        for (count = [1 : 1 : 3]) {
            rotate(a=[0,0,360/3*count]) {
                translate([-female_tooth_width/2,0,4]) {
                    cube([female_tooth_width, outside_radius+tooth_length, tooth_part_height]);
                }
            }
        }
    }
}

module middle() {
    
    inside_diameter = 8;
    inside_radius = inside_diameter/2;

    difference() {
        union() {
            cylinder(tooth_part_height+8, outside_radius, outside_radius);
            for (count = [1 : 1 : 3]) {
                rotate(a=[0,0,360/3*count]) {
                    translate([-tooth_width/2,0,0]) {
                        cube([tooth_width, outside_radius+tooth_length, tooth_part_height+8]);
                    }
                }
            }
            //cylinder(4, hole_in_the_middle_radius, hole_in_the_middle_radius);
        }
        translate([0,0,-1])
            cylinder(tooth_part_height+10, inside_radius, inside_radius);
    }
}
