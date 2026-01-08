use <fonts/Quicksand-VariableFont_wght.ttf>

// parameters
$fn=100;
wall=4;


squareWidth = 25;

boxHeight = 7 + wall*2;
boxLength = squareWidth * 8 +wall*2; // x
boxWidth = squareWidth * 3 +wall*2; // y



lidHeight = boxHeight*0.4;
lidLength = boxLength+wall*2;
lidWidth = boxWidth+wall*2;

line1 = "";
line2 = "";


box_radius_out=5;
box_radius_in=3;

pieceWidth = squareWidth / 3;
lineThickness = 1;

// modules
module box_cylinder (radius, height) {
  cylinder (r=radius,h=height);
}

module box_cylinderRounded (radius, height) {
  $fa = 1; $fs = 0.5;

    hull() {
      translate([0, 0, height-1])
        cylinder(r=radius);

      rotate_extrude()
        translate([radius-2, 2])
          circle(r=2);
    }
}

module block (width, length, radius, height) {
  difference () {
    hull () {
      translate ([radius,radius,0])
        box_cylinder(radius, height);
      translate ([radius,width-radius,0])
        box_cylinder(radius, height);
      translate ([length-radius,width-radius,0])
        box_cylinder(radius, height);
      translate ([length-radius,radius,0])
        box_cylinder(radius, height);
    }
  }
}
module blockRounded (width, length, radius, height) {
  difference () {
    hull () {
      translate ([radius,radius,0])
        box_cylinderRounded(radius, height);
      translate ([radius,width-radius,0])
        box_cylinderRounded(radius, height);
      translate ([length-radius,width-radius,0])
        box_cylinderRounded(radius, height);
      translate ([length-radius,radius,0])
        box_cylinderRounded(radius, height);
    }
  }
}

module shell(w, l, h) {
  difference() {
    blockRounded(w,l,box_radius_out, h);

    translate([wall,wall,wall])
      block(w-wall*2,l-wall*2,box_radius_in, h);
  }
}

module squareCutout() {
  translate([0,0,-wall/2])
    difference() {
      translate([lineThickness, lineThickness, 0])
        cube([squareWidth-lineThickness*2, squareWidth-lineThickness*2, wall]);

      translate([lineThickness*2, lineThickness*2, -1])
        cube([squareWidth - lineThickness*4, squareWidth - lineThickness*4, wall+2]);

    }
}

module rosetteCutout() {
  linear_extrude(wall)
    text("*",40,font="Quicksand");
}

module squares() {
  for (x = [0 : 3]) {
    for (y = [0 : 2]) {
      translate([wall + x * squareWidth, wall + y * squareWidth,0])
        squareCutout();        
    }
  }

  translate([squareWidth * 4, squareWidth, 0])
    for (x = [0 : 1]) {
      for (y = [0 : 0]) {
        translate([wall + x * squareWidth, wall + y * squareWidth, 0])
          squareCutout();
      }
    }

  translate([squareWidth * 6, 0, 0])
    for (x = [0 : 1]) {
      for (y = [0 : 2]) {
        translate([wall + x * squareWidth, wall + y * squareWidth, 0])
          squareCutout();
      }
    }

    translate([wall*2,-wall*3.5,-wall/2])
    union(){
      rosetteCutout();
        translate([0, squareWidth*2, 0])
          rosetteCutout();

        translate([squareWidth*3, squareWidth, 0])
          rosetteCutout();

        translate([squareWidth*6, 0, 0])
          rosetteCutout();
        translate([squareWidth*6, squareWidth*2, 0])
          rosetteCutout();
    }
}

module lidDesign() {
  squares();
  
  translate([lidLength-wall-squareWidth*2, lidWidth/4, wall*2.1])
    rotate([0,0,180]) 
      linear_extrude(height = wall)
        text(line1,  valign="top", size=6);
  translate([lidLength-wall-squareWidth*2, lidWidth/2, wall*2.1])
    rotate([0,0,180]) 
      linear_extrude(height = wall)
        text(line2,  valign="top", size=6);
}

module box() {
    shell(boxWidth, boxLength, boxHeight);
}
module lid() {
    difference() {
        blockRounded(boxWidth,boxLength,box_radius_out, wall*2);


        lidDesign();
    }
    difference () {
    translate([wall,wall,wall*2])
      block(boxWidth-wall*2,boxLength-wall*2,box_radius_in, wall);

      lidDesign();
    }
}


module piece(){
  difference() {
    hull() {
      translate([0,0,wall/2])
      rotate_extrude()
        translate([squareWidth/3-2, 2])
          circle(r=2);

      translate([0, 0, wall-1])
        cylinder(r=squareWidth/3);

      rotate_extrude()
        translate([squareWidth/3-2, 2])
          circle(r=2);
    }
    translate([-5,-18.5,wall*1.4])
      scale([0.6,0.6,0.51])
        rosetteCutout();
  }
}

module piece(){
  difference() {
    hull() {
      translate([0,0,wall/2])
      rotate_extrude()
        translate([pieceWidth-2, 2])
          circle(r=2);


      rotate_extrude()
        translate([pieceWidth-2, 2])
          circle(r=2);
    }
    translate([-5.15,-18.5,wall*1.4])
      scale([0.6,0.6,0.51])
        rosetteCutout();
  }
}

// output
box();
translate([0, boxWidth+10,0])
// translate([boxLength, boxWidth,0])
//  rotate ([0,180,0])
 lid();


// 7 pieces
translate([0,boxLength,0])
  for (i = [0 : 6]) {
    translate([i * (pieceWidth * 2), 0, 0])
      piece();
  } 