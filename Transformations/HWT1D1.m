function y = HWT1D1(v)
%HWT1D1 takes as input a vector of even length and returns one iteration of
%the discrete Haar wavelet transformation.

N=length(v);
if mod(N,2)==1
    str=sprintf('HWT1D1: The length of the input vector must be even. Returning the input vector.');
    disp(str);
    y=v;
    return;
end;

h=[1;1];
g=[-1;1];
x=reshape(v,2,N/2)';
y=sqrt(2)*[x*h;x*g]/2;