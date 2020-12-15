function Ms0 = CalculateMs0(Tc)
% Calculates the spontaneous magnetization at room temperature Ms0 for the
% titanomagnetite TM_x with a titaniumcontent x such that its Curie
% temperature is Tc. The calculation is based on empirical data by Dunlop. 
%
% Tc - Curie temperature (scalar or vector), used to calculate Ms0 based on
% fitting of data by Dunlop for Titanomagnetite with Ti-content x [K]
%
% OUTPUT: 
% Ms0 - spontaneous magnetization at room temperature for the given Tc
% (scalar or vector) [Am2] 

    Ms0m = 480e3; 
    Ms0t = 125e3;
    Tcm = 580+273;
    a = 280; 
    b = 500; 

    x = - b/(2*a) + sqrt((Tcm-Tc)/a+b^2/(4*a^2)); 

    Ms0 = Ms0m - 1/0.6*(Ms0m - Ms0t)*x; 
end