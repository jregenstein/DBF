%This class simulates a plane and will calculate cruise speed, takeoff
%distance, stall speed and the like. Unit system is kg,m,s
%
%By Jacob Regenstein

classdef Plane < handle %this apparently allows methods to assign property values?
    properties(Constant)
        %constants
        AIR_DENSITY = 1.225 ;%kg/m^3
        GRAVITY = 9.81; %m/s^2
        TAKEOFF_DISTANCE_DESIRED = 3.3; %meters
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
        %sizes the wing for the takeoff distance
        function s = size_wing(obj)
            %gain to set how quickly the function will converge on the wing
            %size
            gain = 0.1;
            %once it's this close to the takeoff distance we'll consider
            %the solution converged
            close_enough = 0.005;
            td = obj.get_takeoff_distance(); %takeoff distance in meters
            while abs(td - Plane.TAKEOFF_DISTANCE_DESIRED) > close_enough
                %make the wing bigger if the takeoff roll is too long or
                %smaller if it's too short
                obj.wing_area = obj.wing_area - gain*(Plane.TAKEOFF_DISTANCE_DESIRED - td)
                %recalculate the takeoff distance
                td = obj.get_takeoff_distance()
            end 
            s = obj.wing_area
        end
        %gives the takeoff distance in meters. for now assuming AoA = 0
        %until rotation
        function d = get_takeoff_distance(obj)
            %calculate stall speed in m/s
            Vs = sqrt(2*obj.mass*obj.GRAVITY / (obj.AIR_DENSITY*obj.wing_area*obj.airfoil.get_CL_max()));
            %start with 0 indicated airspeed (assuming IAT=TAS for now),
            %also in m/s
            IAS = 0;
            d = 0; %takeoff distance, in meters
            timestep = 0.001; %in seconds, 0.1 is too high
            while IAS < Vs
                net_force = obj.thrust - obj.get_drag(0,IAS);
                %TODO: include rolling resistance
                IAS = IAS + (net_force/obj.mass)*timestep;
                d = d + IAS*timestep;
            end
        end
        
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
        
