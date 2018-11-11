%This class simulates a plane and will calculate cruise speed, takeoff
%distance, stall speed and the like. Unit system is kg,m,s
%
%By Jacob Regenstein

classdef Plane
    properties(Constant)
        %constants
        AIR_DENSITY = 1.225 ;%kg/m^3
        GRAVITY = 9.81; %m/s^2
    end
    properties
        mass %in kg, empty weight of the plane
        wing_area %in m^2, might switch to wingspan and MAC later
        airfoil %right now can only do NACA 4-digit airfoils
        thrust %in newtons
        fuse_CD %really the drag of everything that isn't the wing, right now this includes stores but that should change soon
        fuse_area %reference area of the fuselage in m^2
    end
    methods
        function s = get_cruise_speed(obj)% returns the cruise speed in m/s and the alpha for which level flight is achieved at this speed
            TIMESTEP = 10; %SECONDS
            last_s = -10;
            close_enough = 0.1; %the difference between the previous and current speed at which we will consider the solution converged
            %for each alpha within some reasonable range:
            while abs(obj.IAS - last_s) > close_enough %&& abs(obj.get_lift() - (Plane.GRAVITY * obj.mass)) > close_enough
                obj
                last_s = obj.IAS;
                %change the alpha to maintain 0 lift
                obj.alpha = obj.alpha + alpha_gain * (obj.get_lift() - (Plane.GRAVITY * obj.mass));
                obj.IAS = TIMESTEP * (obj.thrust - obj.get_drag())/obj.mass;
            end
            s = obj.IAS;
        end
        function s = get_cruise_speed_at_alpha(obj,alpha)
            %find the speed which produces lift=weight
            s = sqrt(2*obj.mass*obj.GRAVITY / (obj.AIR_DENSITY*obj.wing_area*obj.airfoil.get_CL(alpha)));
            %find the drag at that speed
            drag = obj.get_drag(alpha,s);
            %check that that drag isn't less than thrust
            if drag > obj.thrust
                %if it is greater than thrust we can't cruise at this speed
                s = 0;
            end
        end
        function d = get_drag(obj,alpha,IAS) %gets drag force in newtons at a given alpha          
            d = 0.5*(obj.wing_area*obj.airfoil.get_CD(alpha)+obj.fuse_area*obj.fuse_CD)*(IAS^2)*Plane.AIR_DENSITY; 
        end
        function l = get_lift(obj,alpha,IAS)%gets lift force in newtons at a given alpha
            l = 0.5*obj.wing_area*obj.airfoil.get_CL(alpha)*(IAS^2)*Plane.AIR_DENSITY; 
        end
    end
end
        
