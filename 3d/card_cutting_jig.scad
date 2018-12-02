


id_card_width = 53.98;
id_card_length = 85.60;
id_card_thickness = 0.8;

height = 0.8;
padding = 0.5;
slit_thickness = 0.5;

jig_thickness = 2;
jig_width = id_card_width + ( 2 * (jig_thickness + padding) );
jig_length = id_card_length + ( 2 * (jig_thickness + padding) );

extension_width = 20;

display_card = false;
card_half = false;


module ID_card() {
    if (card_half) {
        cube([id_card_width, id_card_length / 2, id_card_thickness]);
    } else {
        cube([id_card_width, id_card_length, id_card_thickness]);
    }
}

module jig_base() {
    difference() {
        cube([jig_width, jig_length, jig_thickness]);
        
        translate([0 , (jig_length - slit_thickness) / 2, 0]) {
            cube([jig_width, slit_thickness, 10]);
        }
        
        translate([10, 10, 0]) {
            cube([jig_width - 20, 25, 10]);
        }
        
        translate([10, 55, 0]) {
            cube([jig_width - 20, 25, 10]);
        }
    }
    
    
        slit_extension();
    
}

module slit_extension() {
    difference() {
        translate([-10, jig_length / 2 - extension_width / 2, 0]) {
            cube([jig_width + extension_width, extension_width, jig_thickness]);
        }
        
        translate([0, jig_length / 2 - extension_width / 2, 0]) {
            cube([jig_width, 20, 10]);
        }
        
        translate([-5 , (jig_length-slit_thickness ) /2, -5]) {
            cube([jig_width+10, slit_thickness, 10]);
        }
    }
}

module jig_top() {
    cube([jig_width, jig_thickness, height]);
}

module jig_side() {
    difference() {
        cube([jig_thickness, jig_length, height]);
        
        translate([0, 35, 0]) {
            cube([10, 20, 10]);
        }
    }
}




module jig() {
    translate([0,0,0]) {
        jig_base();
    }
    
    if (display_card) {
        translate([jig_thickness + padding,jig_thickness + padding ,jig_thickness]) {
            ID_card();
        }
}
    
    translate([0,0,jig_thickness]) {
        jig_top();
    }
    
    translate([0, jig_length - jig_thickness, jig_thickness]) {
        jig_top();
    }
    
    translate([0,0,jig_thickness]) {
       jig_side();
    }
    
    translate([id_card_width + jig_thickness + (2 * padding), 0, jig_thickness]) {
        jig_side();
    }
}

jig();