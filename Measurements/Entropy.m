function y = Entropy(v)
%Entropy takes as input a vector or a matrix and returns the entropy associated with the input.

%n=length(v);
%if mod(n,2)==1
%    str=sprintf('HWT1D1: The length of the input vector must be even. Returning the input vector.');
%    disp(str);
%    y=v;
%    return;
%end;

if ~isvector(v)
       [r,c]=size(v);
       a=reshape(v,1,r*c);
else
        a=reshape(v,1,length(v));
end;

a=histc(a,unique(a))/length(a);

y=-a*log2(a)';