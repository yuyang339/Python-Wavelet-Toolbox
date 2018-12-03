function [h,ht] = SplineFilters(N,Nt)
%SplineFilters takes two positive integers N and Nt who have the same parity and
%returns spline filters h and ht of lengths  2N + Nt -1 and Nt+1, respectively.

if round(N)~=N || round(Nt)~=Nt
    str='SplineFilters: The input values must be integers - returning 0 filters.';
    disp(str);
    h=[0;0];
    ht=h;
    return;
end

if N<=0 || Nt<=0
    str='SplineFilters: The input values must be positive integers - returning 0 filters.';
    disp(str);
    h=[0;0];
    ht=h;
    return;
end

if mod(N+Nt,2)~=0
    str='SplineFilters: The input values have the same parity - returning 0 filters.';
    disp(str);
    h=[0;0];
    ht=h;
    return;
end


%Creating ht is simple.

for k=0:Nt
    ht(k+1)=nchoosek(Nt,k);
end;

ht=sqrt(2)*ht'/2^Nt;

%Now we form the filter h.

if mod(N,2)==0
    l=N/2; lt=Nt/2;
else
    l=(N-1)/2; lt=(Nt-1)/2;
end

%First we construct the trig polynomial in sin^(2j)(w/2):

if mod(N,2)==0
    p=PolySin2j(l+lt);
else
    p=PolySin2j(l+lt+1);
end

%Next build cos^2(w/2) and raise it to the l power.

s2=[-.25 .5 -.25];
c2=[0 1 0]-s2;
cN=c2;
for k=2:l
    cN=conv(cN,c2);
end

%Finally multiply the polynomials and scale by sqrt(2).  

h=sqrt(2)*conv(cN,p)';

%In the case where N is odd, we have to multiply by the polynomial .5 + .5*e^(Iw)
if mod(N,2)==1
    h=conv([.5 .5],h);
end
