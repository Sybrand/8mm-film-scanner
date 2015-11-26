$fn=180;

//  |              |
//  |              |
//--|              |
//  |              |
//  | --------     |
//  ||<-0.91->|0.51|
//  || ^      |    |
//  ||1.14    |    |--x
//  || v      |    |  ^
//  | --------     |  |
//  |<-   1.42   ->|  |
//  |              |  |   
//--|              | 4.23
//  |              |  |
//  | --------     |  |
//  ||<-0.91->|0.51|  |
//  || ^      |    |  v
//  ||1.14    |    |--x


// ==================
// Hole in the middle
// ==================
// Mechano screws have a diameter of 2.8mm
// The bearings I bought have a diameter of 14mm
// 14mm is too small, trying 14.2
// 14.2 is too small, upped to 14.4
hole_in_the_middle_diameter = 14.4;
hole_in_the_middle_radius = hole_in_the_middle_diameter / 2;
female_width = 4;
male_width = female_width - 0.2;

// =====
// Teath
// =====
// Each tooth has to be:
// - 4.23mm from centre to centre
// - 0.91 by 1.14
// - 0.51 from side of film
//
// the curcumference of the doodad, has to be a multiple of 4.23,
// 10 teath == 10 * 4.23
// 4.25 is too far apart
// 4.24 is also too far apart. 
// 4.23 is also too far apart
// 4.22 is ALMOST perfect.
// 4.21 soooooo close to perfece
tooth_to_tooth = 4.20;
num_teeth = 21;
circumference = num_teeth * tooth_to_tooth;
radius = circumference / (2 * PI);
peg_length = radius + 1;
film_sprocket_height = 1.14;
film_sprocket_width = 0.91;
sprocket_tolerance = 0.2;
sprocket_height = film_sprocket_height - sprocket_tolerance;
sprocket_width = film_sprocket_width - sprocket_tolerance;

half_sunken_section = 2.79;
tooth_section = 1.42;

base_radius = radius;
side = 2;

// DRAW TOP
translate([-radius*2.5, 0, 0]) 
    top(hole_in_the_middle_radius);
// DRAW BOTTOM
translate([radius*2.5, 0, 0]) 
    bottom(hole_in_the_middle_radius);
// DRAW MIDDLE
middle(hole_in_the_middle_radius);

module teeth(num_teeth, radius) {
    for (count = [1 : 1 : num_teeth]) {
        rotate(a=[0,0,360/num_teeth*count]) {
            //translate([-sprocket_height/2,radius-0.1,0]) {
            // we pull it back just a little (0.1) to ensure it's flush
            translate([0,radius-0.1,0]) {
                rotate(a=[0,0,0])
                    wedge(sprocket_height, 2, sprocket_width+0.2);
            }
        }
    }
}

module middle(hole_radius) {
    difference() {
        union() {
            //teeth(num_teeth, radius);              
            middle_drop = 0.5;
            base_height = 2;

            // bit for teeth
            cylinder(tooth_section, base_radius, base_radius);

            // sunken area to protect film
            translate([0, 0, tooth_section])
                cylinder(half_sunken_section, base_radius, base_radius-middle_drop);
            translate([0, 0, tooth_section+half_sunken_section])
                cylinder(half_sunken_section, base_radius-middle_drop, base_radius);
                
            // bit for other side of teeth
            translate([0, 0, tooth_section+half_sunken_section+half_sunken_section])
                cylinder(1, base_radius, base_radius);
        }
        // this should match the diameter of the bearings
        translate([0, 0, -1])
        cylinder(20, hole_radius+female_width, hole_radius+female_width);
    }
}



module bottom(hole_radius) {
    difference() {
        union() {
            // bottom guard
            cylinder(3, base_radius+side, base_radius+side);
            
            // bit for film
            translate([0, 0, 3])
                cylinder(0.51+sprocket_tolerance/2, base_radius, base_radius);
            
            // slot part (male)
            translate([0, 0, 3+0.51+sprocket_tolerance/2])
                cylinder(1.8, hole_radius+male_width, hole_radius+male_width);
            
            // photo interruptor
            /*
            difference() {
                cylinder(2, base_radius+side+5, base_radius+side+5);
                for (count = [1 : 1 : num_teeth]) {
                    rotate(a=[0,0,360/num_teeth*count]) {
                        translate([-0.5,radius,-1]) {
                            cube([1.5, 11+side, 4]);
                        }
                    }
                }
            }
            */
        }
        translate([0, 0, -1])
            cylinder(10, hole_radius, hole_radius);
        
    }
}

module top(hole_radius) {
    difference() {
        union() {
            // top guard
            cylinder(3, base_radius+side, base_radius+side);
                        
            // slot part (male)
            translate([0, 0, 3])
                cylinder(1.8, hole_radius+male_width, hole_radius+male_width);
            
        }
        translate([0, 0, -1])
            cylinder(10, hole_radius, hole_radius);       
    }
}

module wedge(x=10,y=10,z=10) {
    x = x / 2;
    y = y / 2;
    
    polyhedron(
        points=[
            // three points at base
            [x,0,0], [-x, 0,0], [0,y,0], // base
            [x,0,z], [-x, 0,z], [0,y,z]
            //[0,y,z], [x,0,z], [-x,0,z]
        ],
        faces=[
            [1,0,2], //bottom,
            [3,4,5], // top
            [0,1,3], [1,4,3], // front
            [1,2,4], [4,2,5], // left
            [2,0,5], [0,3,5] // right
        ]
    );
}