%This class will interface with xfoil, and store all the airfoil data so we
%won't need to launch xfoil from code so many times. It should do xfoil
%calculations over a range of alpha's in a constructor, and then store that
%data as a lookup table, where it can interpolate for values that didn't
%converge
classdef Airfoil
    properties
        type %type of airfoil, to start with it will just be a NACA 4-digit
             %but we will want to include the whole UIUC library of
             %airfoils 1st
    end
    methods
        %make a constructor that takes in an airfoil type and sweeps over
        %range of alphas
        
        %make functions to lookup Cl and Cd as a function of alpha, nice to
        %haves would be functions that give the max Cl, max Cl/Cd, and
        %functions that give the respective alphas for both of those points
    end
end