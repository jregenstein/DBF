plane = Plane;
plane.mass = 5;
plane.wing_area = 0.4;
plane.airfoil = Airfoil('NACA2412');
plane.thrust = 20;
plane.fuse_CD = 0.2;
plane.fuse_area = 0.1;
%plane.get_cruise_speed_at_alpha(3)

%plane.get_wing_cd();