function y = IHWT1D1(v)
%IHWT1D1 takes as input a vector of even length and returns one iteration of
%the discrete inverse Haar wavelet transformation.

N=length(v);
if mod(N,2)==1
    str=sprintf('IHWT1D1: The length of the input vector must be even. Returning the input vector.');
    disp(str);
    y=v;
    return;
end;
h=[1;1];
g=[1;-1];
x=reshape(v,N/2,2);
lp=x*h;
hp=x*g;
y=(sqrt(2)*reshape([hp lp]',1,N)/2)';