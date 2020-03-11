%%THIS FILE FOR GENERATING THE HERMITE POLYNOMIALS SO THAT THE
%%DIFFERENTIATION IS NOT REQUIRED IN EACH CALCULATIONS!
function output=HERMITEPOLY(KK,x)
if KK==0;
    output=1.0;
elseif KK==1;
    output=x;
elseif KK==2;
    output=x.^2 - 1.0;
elseif KK==3;
    output=x.^3 - 3.0*x;
elseif KK==4;
    output=x.^4 - 6.0*x.^2 + 3.0;
elseif KK==5;
    output=x.*(x.^4 - 10.0*x.^2 + 15.0);
elseif KK==6;
    output=x.^6 - 15.0*x.^4 + 45.0*x.^2 - 15.0;
elseif KK==7;
    output=x.*(x.^6 - 21.0*x.^4 + 105.0*x.^2 - 105.0);
elseif KK==8;
    output=x.^8 - 28.0*x.^6 + 210.0*x.^4 - 420.0*x.^2 + 105.0;
elseif KK==9;
    output=x.^9 - 36.0*x.^7 + 378.0*x.^5 - 1260.0*x.^3 + 945.0*x;
elseif KK==10;
    output=x.^10 - 45.0*x.^8 + 630.0*x.^6 - 3150.0*x.^4 + 4725.0*x.^2 - 945.0;
elseif KK==11;
    output=x.^11 - 55.0*x.^9 + 990.0*x.^7 - 6930.0*x.^5 + 17325.0*x.^3 - 10395.0*x;
elseif KK==12;
    output=x.^12 - 66.0*x.^10 + 1485.0*x.^8 - 13860.0*x.^6 + 51975.0*x.^4 - 62370.0*x.^2 + 10395.0;
elseif KK==13;
    output=x.^13 - 78.0*x.^11 + 2145.0*x.^9 - 25740.0*x.^7 + 135135.0*x.^5 - 270270.0*x.^3 + 135135.0*x;
end
end