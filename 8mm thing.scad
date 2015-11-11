
$fn=180;

// each peg has to be
// - 4.23mm from centre to centre
// - 0.91 by 1.14
// - 0.51 from side of film
//
// the curcumference of the doodad, has to be a multiple of 4.23
// 10 sprockets == 10 * 4.23

peg_to_peg = 4.23;
sprockets = 15;
circumference = sprockets * peg_to_peg;
radius = circumference / (2 * PI);
peg_length = radius + 1;
sprocket_height = 1.14;
sprocket_width = 0.91;

for (sprocket = [0 : 1 : sprockets])
    rotate(a=[0,0,360/sprockets*sprocket])
        translate([-sprocket_height/2,radius,2.51])
            color([0,1,0])
            cube(size = [sprocket_height,1,sprocket_width], center=false);

translate([0, 0, 0])
difference() {

union() {
        // bottom guard
        base_radius = radius;
        side = 2;
        middle_drop = 0.5;
        base_height = 2;
        tooth_section = 1.42;
        half_sunken_section = 2.79;

        cylinder(base_height, base_radius+side, base_radius+side);

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
        
        translate([0, 0, base_height])
            cylinder(tooth_section, base_radius, base_radius);
        
        // sunken area to protect film
        translate([0, 0, tooth_section+base_height])
            cylinder(half_sunken_section, base_radius, base_radius-middle_drop);
        translate([0, 0, tooth_section+base_height+half_sunken_section])
            cylinder(half_sunken_section, base_radius-middle_drop, base_radius);
            
        // bit for other side of teeth
        translate([0, 0, tooth_section+base_height+half_sunken_section+half_sunken_section])
            cylinder(1, base_radius, base_radius);
            
        // top guard
        translate([0, 0, tooth_section+base_height+half_sunken_section+half_sunken_section+1])
            cylinder(base_height, base_radius, base_radius+side);
            
        translate([0, 0, tooth_section+base_height+half_sunken_section+half_sunken_section+1+base_height])
            cylinder(1, base_radius+side, base_radius+side);
            
        }
 
        // this should match the diameter of the bearings
        translate([0, 0, -1])
            cylinder(20, 4.5, 4.5);
    }
    