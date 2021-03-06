$fn=180;

// 12.95 is too large to fit into film canister
// 12.8 might also be just a bit too snug
outside_diameter = 12.5;
outside_radius = outside_diameter/2;
tooth_part_height = 11.6;

// 14mm not big enough
// upped it to 14.2
// 14.2 not enough, upped to 14.4
hole_in_the_middle_diameter = 14.4;
hole_in_the_middle_radius = hole_in_the_middle_diameter / 2;
tooth_length = 3;
// 1.5 is a bit too wide for tooth width - it's a very snug fit, that might damage the plastic canisters
tooth_width = 1.2;


//translate([0, outside_diameter*2.0, 0])
//    bottom();
middle(outside_diameter);
//translate([0, -outside_diameter*2.0, 0])
//    bottom();

module bottom() {
    difference() {
        difference() {
            cylinder(8, 12, 12);
            translate([0,0,-1])
                cylinder(10, hole_in_the_middle_radius, hole_in_the_middle_radius);
        }
        // 0.2 is juuuuust a bit tight
        female_tooth_width = tooth_width + 0.3;
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
    // Inside diameter has to be big enough to allow 5mm thread through.
    // If we make it only 5mm however, the plastic gets so hot (on this small print)
    // that everything just mushes on the inside. So instead, we give the wall a width
    // of 1.2mm, which should be strong enough.
    inside_diameter = outside_diameter-2.4;
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
