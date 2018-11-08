plane = Plane;
plane.mass = 10;
plane.wing_area = 0.5;
plane.airfoil = 'NACA6412';
plane.thrust = 50;
plane.fuse_CD = 0.2;
plane.fuse_area = 0.01;
plane.alpha = 3;
plane.IAS = 15;

plane.get_cruise_speed()

%plane.get_wing_cd()