function y = CE(v)
%CE takes as input a vector or a matrix and returns the cumulative energy
%vector associated with the input.

if ~isvector(v)
       [r,c]=size(v);
       a=reshape(v,1,r*c);
else
        a=v;
end;

y=cumsum(sort(a.^2,'descend')/norm(a)^2)';