function y = nCE(v,p)
%nCE takes as input a vector consisting of elements in the interval [0,1] and a value
%0 <= p <= 1 and returns the number of elements in v whose values are less
%than or equal to p.

if ~isvector(v)
     str=('nCE: The first input must be a vector.  Returning -1.');
    disp(str);
    y=0;
    return;   
end;

d=length(find(v<0));

if d~=0
    str=('nCE: The elements of v must be in the interval [0,1].  Returning -1.');
    disp(str);
    y=0;
    return;
end;

d=length(find(round(v)>1));

if d~=0
    str=('nCE: The elements of v must be in the interval [0,1].  Returning -1.');
    disp(str);
    y=0;
    return;
end;

if p<0 || p>1
    str=('nCE: The input p must be in the interval [0,1].  Returning -1.');
    disp(str);
    y=0;
    return;
end;

y=length(find(v<=p));