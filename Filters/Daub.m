function y = Daub(n)
%Daub takes an even integer n and returns the Daubechies orthogonal filter
%of length n.  This routine is only valid for eveen integers 2<=n<=14.

global DAUBLENGTH;

if round(n)~=n
    str=sprintf('Daub: The input must be an integer - returning [0 0].');
    disp(str);
    y=[0; 0];
    return;
end;

if mod(n,2)~=0
    str=sprintf('Daub: The input must be an even integer - returning [0; 0].');
    disp(str);
    y=[0; 0];
    return;
end;

if n<0
    str=sprintf('Daub: The input must be a nonnegative integer - returning [0; 0].');
    disp(str);
    y=[0; 0];
    return;
end;

if n>=16
    str=sprintf('Daub: This module does not work for n>=16 - returning [0;0].');
    disp(str);
    y=[0; 0];
    return;
end;
    
DAUBLENGTH=n;

if n==2
    y=sqrt(2)*[1;1]/2;
    return;
end

if n==4
    r2=4*sqrt(2);
    r3=sqrt(3);
    y=[1+r3;3+r3;3-r3;1-r3]/r2;
    return;
end

if n==6
    r=sqrt(5+2*sqrt(10));
    r10=sqrt(10);
    y=sqrt(2)*[1+r10+r; 5+r10+3*r; 10-2*r10+2*r; 10-2*r10-2*r; 5+r10-3*r; 1+r10-r]/32;
    return;
end
    

guess=zeros(n,1);
guess(n)=1;
options=optimset('NonlEqnAlgorithm','gn');
y=flipud(fsolve(@Daubfun,guess,options));

