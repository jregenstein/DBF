
classdef Plane
    properties(Constant)
        %constants
        AIR_DENSITY = 1.225 ;%kg/m^3
        XFOIL_ITERATIONS = 'oper iter 200'; %number of times to iterate in xfoil
        GRAVITY = 9.81; %m/s^2
    end
    properties
        mass %in kg, empty weight of the plane
        wing_area %in m^2, might switch to wingspan and MAC later
        airfoil %right now can only do NACA 4-digit airfoils
        thrust %in newtons
        fuse_CD %really the drag of everything that isn't the wing, right now this includes stores but that should change soon
        fuse_area %reference area of the fuselage in m^2
        alpha %angle of attack
        IAS %in m/s, the indicated airspeed of the aircraft
        wing_cl
        wing_cd
    end
    methods
        function s = get_cruise_speed(obj)% gets the cruise speed in m/s, and configures the aircraft for cruise
            TIMESTEP = 10; %SECONDS
            last_s = -10;
            close_enough = 0.1; %the difference between the previous and current speed at which we will consider the solution converged
            alpha_gain = -0.5; %the factor we multiply excess lift by in order to vary alpha
            while abs(obj.IAS - last_s) > close_enough %&& abs(obj.get_lift() - (Plane.GRAVITY * obj.mass)) > close_enough
                obj
                last_s = obj.IAS;
                %change the alpha to maintain 0 lift
                obj.alpha = obj.alpha + alpha_gain * (obj.get_lift() - (Plane.GRAVITY * obj.mass));
                obj.IAS = TIMESTEP * (obj.thrust - obj.get_drag())/obj.mass;
            end
            s = obj.IAS;
        end
        function d = get_drag(obj) %gets drag force in newtons           
            d = 0.5.*obj.wing_area.*(obj.IAS^2).*obj.get_wing_cd().*Plane.AIR_DENSITY;
        end
        function l = get_lift(obj)%gets lift force in newtons
            l = 0.5.*obj.wing_area.*(obj.IAS^2).*obj.get_wing_cl().*Plane.AIR_DENSITY;
        end
        function cd = get_wing_cd(obj)%gets the Cd at the objects alpha (for the wing only)
            [pol,foil] = xfoil(obj.airfoil,obj.alpha,200000,0,Plane.XFOIL_ITERATIONS);
            cd = pol.CD;
        end
        function cl = get_wing_cl(obj)%gets the CL at the objects alpha
            [pol,foil] = xfoil(obj.airfoil,obj.alpha,200000,0,Plane.XFOIL_ITERATIONS);
            cl = pol.CL;
        end
    end
end
        
%helper funcitons
           
%{
function L = find_max_L(airfoil)
    [pol,foil] = xfoil(airfoil,[0:1:30],200000,0,'oper iter 200');
    L = max(pol.CL);
end

function LD = find_max_LD(airfoil)
    max_LD = 0;
    LD_temp = 0;
    [pol,foil] = xfoil(airfoil,-5:1:25,200000,0,'oper iter 200');
    for i = 1:1:30;
        LD_temp = pol.CL(i) / pol.CD(i);
        if LD_temp > max_LD
            max_LD = LD_temp;
        end
    end
    LD = max_LD;
end
%}
