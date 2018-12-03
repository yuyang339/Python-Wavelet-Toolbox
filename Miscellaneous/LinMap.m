function y = LinMap(A,a,b)
%LinMap takes a vector or matrix and maps the minimum value to a and the
%maximum value to b.

[r c]=size(A);

if isvector(A)
    m=min(a);
    M=max(a);
else
    m=min(reshape(A,1,r*c));
    M=max(reshape(A,1,r*c));
end

if m==M
    y=zeros(r,c);
else
    y=(b-a)*(A-m)/(M-m) + a;
end