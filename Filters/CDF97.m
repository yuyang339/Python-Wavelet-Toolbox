function [h,ht] = CDF97()
%CDF94 returns the Cohen-Daubechies-Feauveau biorthogonal filter pair.

%Find the roots of the polynomial and split into real and complex.
t=roots([20 10 4 1]);
cr=[];
for k=1:length(t)
    if isreal(t(k))
        r=t(k); %here is the real root.
    else
        cr=[cr t(k)];
    end
end

%Assign a value to a.
a=-1/r;

%We first find the Fourier series for filter ht:

%sin^2(w/2) and cos^2(w/2) as trig polynomials
s2=[-.25 .5 -.25];
c2=[0 1 0]-s2;

%cos^4(w/2) can be obtained by convolving c2 with itself
c4=conv(c2,c2);

%Now multiply cos^4(w/2) and sin^2(w/2)-r and scale by sqrt(2)*a

ht=sqrt(2)*a*conv(c4,s2-[0 r 0])';

%Next we compute the Fourier series for filter h:

%First multiply polynomials sin^2(w/2)-cr(1) and sin^2(w/2)-cr(2)

h=conv(s2-[0 cr(1) 0],s2-[0 cr(2) 0]);

%Multiply this by cos^4(w/2) and scale by 20*sqrt(2)/a

h=(conv(c4,h)*20*sqrt(2)/a)';
