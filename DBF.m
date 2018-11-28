plane = Plane;
plane.mass = 5;
plane.wing_area = 1;
plane.airfoil = Airfoil('NACA2412');
plane.thrust = 20;
plane.fuse_CD = 0.2;
plane.fuse_area = 0.1;


plane.size_wing();

plane.get_cruise_speed()
