
$fn=180;

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
//
// ==================
// Hole in the middle
// ==================
// Mechano screws have a diameter of 2.8mm
// The bearings I'm looking at buying, have a diameter of 9mm
hole_in_the_middle_diameter = 2.8;
hole_in_the_middle_radius = hole_in_the_middle_diameter / 2;

tooth_to_tooth = 4.23;
sprockets = 15;
circumference = sprockets * tooth_to_tooth;
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
translate([-30, 0, 0]) top(hole_in_the_middle_radius);
// DRAW BOTTOM
translate([30, 0, 0]) bottom(hole_in_the_middle_radius);
// DRAW MIDDLE
middle(hole_in_the_middle_radius);
//teeth(sprockets, radius);


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

//rotate(a=[90,0,0])
//    triangle(sprocket_height, sprocket_width+0.2, 1);

module middle(hole_radius) {

difference() {
difference() {
difference() {
difference() {

union() {
   teeth(sprockets, radius); 
    /*
    for (sprocket = [1 : 1 : sprockets])
        rotate(a=[0,0,360/sprockets*sprocket]) {
            translate([-sprocket_height/2,radius-1,0]) {
                color([0,1,0])
                // adding +0.2 to sprocket_width, to make it a bit higher
                cube(size = [sprocket_height,2,sprocket_width+0.2], center=false);
                
                triangle(sprocket_height, sprocket_width+0.2, 1);
            }
        }
    */
                
        middle_drop = 0.5;
        base_height = 2;
        
        

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
cylinder(20, hole_radius, hole_radius);
}
// subtract space in the bottom
translate([0, 0, -1])
cylinder(3, 6.5, 6.5);
}
// smoothly transition subtraction in bottom
translate([0, 0, 1.999])
cylinder(2, 6.5, 4.5);
}
// subtract from top
translate([0, 0, tooth_section+half_sunken_section+half_sunken_section+1-2])
cylinder(3, 6.5, 6.5);
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
            
            // slot part
            translate([0, 0, 3+0.51+sprocket_tolerance/2])
                // 6.4 is too small
                // 6.3 goes in with some pressure
                cylinder(1.8, 6.3, 6.3);
            
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
                        
            // slot part
            translate([0, 0, 3])
                // 6.4 is too small
                // 6.3 goes in with some pressure
                cylinder(1.8, 6.3, 6.3);
            
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
            [0,y,z], [x,0,z], [-x,0,z]
        ],
        faces=[
            [0,1,2], //bottom,
            [3,4,5], // top
            [0,1,5], [0,5,4], // front
            [1,5,2], [2,5,3], // left
            [0,4,2], [4,3,2] // right
        ]
    );
}