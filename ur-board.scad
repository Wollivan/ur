squareWidth = 40;
height = 30;
boardX = squareWidth * 8;
boardY = squareWidth * 3;
lineThickness = 1;
radius = 3;
wall = 4;

// rotate as per a, v, but around point pt
module rotate_about_pt(z, y, pt) {
    translate(pt)
        rotate([0, y, z]) // CHANGE HERE
            translate(-pt)
                children();   
}

module shell(w, h) {
  hull () {
    translate ([radius,radius,0])
      cylinder(r=radius, h=h);

    translate ([w-radius,0,0])
      cube([radius, radius, h]);
    
    translate ([0,w-radius,0])
      cube([radius, radius, h]);
    
    translate ([w-radius,w-radius,0])
      cube([radius, radius, h]);
  }
}

module outline() {
  translate([0, 0, height-lineThickness])
    difference() {
      translate([lineThickness, lineThickness, 0])
        cube([squareWidth-lineThickness*2, squareWidth-lineThickness*2, lineThickness+1]);

      translate([lineThickness*2, lineThickness*2, -1])
        cube([squareWidth - lineThickness*4, squareWidth - lineThickness*4, lineThickness+1]);

    }
}

module cornerOutline() {
  translate([0, 0, height-lineThickness])
    difference() {
      translate([lineThickness, lineThickness, 0])
       shell(squareWidth-lineThickness*2, lineThickness+1);  

      translate([lineThickness*2, lineThickness*2, 0])
       shell(squareWidth-lineThickness*4, lineThickness+1);  

    }
}

module tile() {
  difference() {
      // Base square
      cube([squareWidth, squareWidth, height]);
      
      outline();
  }
  
}

module cornerTile() {
  difference () {
   shell(squareWidth, height);
    cornerOutline();
  }
}

module sectionOne() {
  union() {
    // 4x3 grid of tiles
    for (x = [0 : 3]) {
      for (y = [0 : 2]) {
        if(x==0 && y ==0){
          // bottm left corner
          rotate_about_pt(0,0,[squareWidth/2+1.5, squareWidth/2+1.5,0]) cornerTile();
        }else if(x==3 && y ==0){
          // bottom right corner
          translate([x * squareWidth, y * squareWidth, 0])
            rotate_about_pt(90,0,[squareWidth/2, squareWidth/2,0]) cornerTile();
        }else if(x==0 && y ==2){
          // top left corner
          translate([x * squareWidth, y * squareWidth, 0])
            rotate_about_pt(-90,0,[squareWidth/2, squareWidth/2,0]) cornerTile();
        }else if(x==3 && y ==2){
          // top right corner
          translate([x * squareWidth, y * squareWidth, 0])
            rotate_about_pt(180,0,[squareWidth/2, squareWidth/2,0]) cornerTile();
        }else{
          translate([x * squareWidth, y * squareWidth, 0]) tile();
        }
      }
    }
  }
}

module sectionTwo() {
  translate([squareWidth * 4, squareWidth, 0])
    union() {
      // 2x1 grid of tiles
      for (x = [0 : 1]) {
        for (y = [0 : 0]) {
         translate([x * squareWidth, y * squareWidth, 0]) tile();
        }
      }
    }
}

module sectionThree() {
  translate([squareWidth * 6, 0, 0])
    union() {
      // 2x3 grid of tiles
      for (x = [0 : 1]) {
        for (y = [0 : 2]) {
          if(x==0 && y ==0){
            // bottm left corner
            rotate_about_pt(0,0,[squareWidth/2+1.5, squareWidth/2+1.5,0]) cornerTile();
          }else if(x==1 && y ==0){
            // bottom right corner
            translate([x * squareWidth, y * squareWidth, 0])
              rotate_about_pt(90,0,[squareWidth/2, squareWidth/2,0]) cornerTile();
          }else if(x==0 && y ==2){
            // top left corner
            translate([x * squareWidth, y * squareWidth, 0])
              rotate_about_pt(-90,0,[squareWidth/2, squareWidth/2,0]) cornerTile();
          }else if(x==1 && y ==2){
            // top right corner
            translate([x * squareWidth, y * squareWidth, 0])
              rotate_about_pt(180,0,[squareWidth/2, squareWidth/2,0]) cornerTile();
          }else{
            translate([x * squareWidth, y * squareWidth, 0]) tile();
          }
        }
      }
    }
}

module topOfItem() {
  difference() {
    children();
    translate([-1, -1, -1])
      cube([squareWidth*8+2, squareWidth*3+2, height-wall]);
  } 
}

module bottomOfItem() {
  difference() {
    children();
    translate([-1, -1, height-wall])
      cube([squareWidth*8+2, squareWidth*3+2, height]);
  } 
}

module sectionThreeHollow() {
  difference() {
    sectionThree();
    translate([squareWidth * 6 + wall, wall, wall])
      cube([squareWidth * 2 - wall*2, squareWidth * 3 - wall*2, height - wall]);
  }
}
module sectionThreeLid() {
  topOfItem() sectionThree();

  // pressure fit portion of lid that fits into the hollow section
  translate([squareWidth * 6 + wall, wall, height-wall*2])
    cube([squareWidth * 2 - wall*2, squareWidth * 3 - wall*2, wall]);
}

module gamePieces() {
  // 7 game pieces
  for (i = [0 : 6]) {
    translate([i * (squareWidth/2+2), 0, 0])
      cylinder(r=squareWidth/4, h=wall*2);
  }
}

module urDice() {
 // a cube with a pattern on one side
  difference() {
    cube([squareWidth/2, squareWidth/6, squareWidth/6]);
    
    // pattern of 4 intersection circles on the side
    for (i = [0 : 1]) {
      translate([squareWidth/6, (-squareWidth/6*i) + squareWidth/12, (squareWidth/12)/100])
      for (x = [0: 3]) {
          translate([squareWidth/16 * x, squareWidth/12+0.5,squareWidth/12])
            rotate([90, 0, 0])
              cylinder(r=squareWidth/24, h=1, $fn=30);
        }
    }
  }

}

module fourDice() {
 // 4 dice in a row
  for (i = [0 : 3]) {
    translate([i * (squareWidth/2+2), 0, 0])
      urDice();
  }
}

module board() {
  sectionOne();
  sectionTwo();
  bottomOfItem() sectionThreeHollow();
}


board();

translate([0, boardY + 10, 0])
sectionThreeLid();

translate([0, - (squareWidth/2 + 10), 0])
gamePieces();
translate([boardX - (squareWidth * 4), - (squareWidth/2 + 10), 0])
fourDice();