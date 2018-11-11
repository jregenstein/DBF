%This class will interface with xfoil, and store all the airfoil data so we
%won't need to launch xfoil from code so many times. It should do xfoil
%calculations over a range of alpha's in a constructor, and then store that
%data as a lookup table, where it can interpolate for values that didn't
%converge
classdef Airfoil
    properties
        type; %type of airfoil, to start with it will just be a NACA 4-digit
             %but we will want to include the whole UIUC library of
             %airfoils 1st
        data;%array that stores the airfoil data. 
        %add iteration number as a constant
    end
    methods
        %make a constructor that takes in an airfoil type and sweeps over
        %range of alphas
        function obj = Airfoil(type)
            obj.type = type;
            obj.data = xfoil(obj.type,-5:0.5:30,200000,0,Plane.XFOIL_ITERATIONS);
        end
        %make functions to lookup Cl and Cd as a function of alpha, nice to
        %haves would be functions that give the max Cl, max Cl/Cd, and
        %functions that give the respective alphas for both of those points
        function cl = get_CL(obj,alpha)
            %gets the index associated with the alpha. Could do this in one
            %line but I think it's more readable this way
            i = obj.get_index(alpha);
            cl = obj.data.CL(i);
        end
        function cd = get_CD(obj,alpha)
            i = obj.get_index(alpha);
            cd = obj.data.CD(i);
        end
        %gets the index corresponding to the given AoA in the data array.
        %To start with it will just give the index, but eventually we will
        %want to set it to find the nearest alpha values and interpolate
        %between them
        function i = get_index(obj, alpha)
            i = 1;
            %if there is an array index out of bounds issue with the
            %following line, it's most likely because the client code
            %requested an AoA that was outside of the tested range. This
            %isn't a good way to do this, the correct way is to learn how
            %to throw and catch errors in matlab, but that's a task for
            %another day. Hopefully once the code is able to interpolate,
            %we'll also be able to get it to extrapolate
            while(obj.data.alpha(i)<alpha)
                i = i + 1;
            end
        end
    end
end