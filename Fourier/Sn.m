function y = Sn()
%Sn is a vector whose components are the Fourier coefficients for the
%Fourier series of sin(t) = (e^(it) - e^(-it))/2i.

y=[1; 0; -1]/(2*i);