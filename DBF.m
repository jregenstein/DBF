plane = Plane;
plane.mass = 10;
plane.wing_area = 0.5;
plane.airfoil = Airfoil('NACA6412');
plane.thrust = 20;
plane.fuse_CD = 0.2;
plane.fuse_area = 0.01;
%plane.get_cruise_speed_at_alpha(3)

%plane.get_wing_cd();