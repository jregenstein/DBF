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
        %returns the max cruise speed of the aircraft
        function max = get_cruise_speed(obj)
            %this variable will keep track of the highest cruise speed we've
            %managed so far
            max = 0;
            for a =  Airfoil.ALPHA_RANGE
                %find the cruise speed at this AoA
                temp = obj.get_cruise_speed_at_alpha(a);
                if temp > max
                    %if it's higher than the previous max then it's the new
                    %max
                    max = temp;
                end
            end
        end
        
        %gets the cruise speed at a given AoA (finds the speed at which
        %lift=weight). 
        function s = get_cruise_speed_at_alpha(obj,alpha)
            %find the speed which produces lift=weight
            s = sqrt(2*obj.mass*obj.GRAVITY / (obj.AIR_DENSITY*obj.wing_area*obj.airfoil.get_CL(alpha)));
            %find the drag at that speed
            drag = obj.get_drag(alpha,s);
            %check that that drag is less than thrust
            if drag > obj.thrust
                %if it is greater than thrust we can't cruise at this AoA
                %(or at least not while maintaining altitude)
                s = 0;
            end
        end
        
        %gets drag force in newtons at a given alpha
        function d = get_drag(obj,alpha,IAS)           
            d = 0.5*(obj.wing_area*obj.airfoil.get_CD(alpha)+obj.fuse_area*obj.fuse_CD)*(IAS^2)*Plane.AIR_DENSITY; 
        end
        
        %gets lift force in newtons at a given alpha
        function l = get_lift(obj,alpha,IAS)
            l = 0.5*obj.wing_area*obj.airfoil.get_CL(alpha)*(IAS^2)*Plane.AIR_DENSITY; 
        end
    end
end
        
