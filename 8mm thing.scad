
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
film_sprocket_height = 1.14;
film_sprocket_width = 0.91;
sprocket_tolerance = 0.2;
sprocket_height = film_sprocket_height - sprocket_tolerance;
sprocket_width = film_sprocket_width - sprocket_tolerance;

half_sunken_section = 2.79;
tooth_section = 1.42;

base_radius = radius;
side = 2;

difference() {
difference() {
difference() {
difference() {

union() {
    
        for (sprocket = [1 : 1 : sprockets])
            rotate(a=[0,0,360/sprockets*sprocket])
                translate([-sprocket_height/2,radius-1,0])
                    color([0,1,0])
                    // adding +1 to sprocket_width, to make it a bit higher
                    cube(size = [sprocket_height,2,sprocket_width+0.1], center=false);
                
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
            
        // top guard
        /*
        translate([0, 0, tooth_section+half_sunken_section+half_sunken_section+1])
            cylinder(base_height, base_radius, base_radius+side);
            
        translate([0, 0, tooth_section+half_sunken_section+half_sunken_section+1+base_height])
            cylinder(1, base_radius+side, base_radius+side);
        */
        }
        
 
// this should match the diameter of the bearings
translate([0, 0, -1])
cylinder(20, 4.5, 4.5);
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


translate([30, 0, 0]) {
    
    difference() {
        union() {
            // bottom guard
            cylinder(3, base_radius+side, base_radius+side);
            
            // but for film
            translate([0, 0, 3])
                cylinder(0.51+sprocket_tolerance/2, base_radius, base_radius);
            
            // slot part
            translate([0, 0, 3+0.51+sprocket_tolerance/2])
                // 6.4 is too small
                // 6.3 goes in with some pressure
                cylinder(1.8, 6.3, 6.3);
            
        }
        translate([0, 0, -1])
            cylinder(10, 4.5, 4.5);
        
}
}


translate([-30, 0, 0]) {
    
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
            cylinder(10, 4.5, 4.5);
        
}
}