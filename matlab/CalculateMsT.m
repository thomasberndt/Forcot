function Ms = CalculateMsT(T, Tc)
% Calculates the spontaneous magnetization Ms at temperature T for the
% titanomagnetite TM_x with a titaniumcontent x such that its Curie
% temperature is Tc. The calculation of the titanium content 
% is based on empirical data by Dunlop. The calculation of the temperature
% dependence of Ms(T) is based on the analytical approximation 
% Ms(T) = Ms(0C)*sqrt(1-T[C]/Tc[C]). 
% Below 0C, Ms(T) is set equal to Ms(0C). 
%
% T - temperature (scalar or vector) [K]
% Tc - Curie temperature (scalar or vector), used to calculate Ms0 based on
% fitting of data by Dunlop for Titanomagnetite with Ti-content x [K]
%
% OUTPUT: 
% Ms0 - spontaneous magnetization at room temperature for the given Tc
% (scalar or vector) [Am2] 
    if nargin < 2
        Tc = 580+273;
    end
    Ms0 = CalculateMs0(Tc);
    a = 1 - ((T-273)./(Tc-273)); 
    a = a .* (1-(a<0)) .* (T>273) + (T<=273); 
    Ms = Ms0 .* sqrt(a); 
end