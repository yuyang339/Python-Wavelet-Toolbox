function y = Comp(v,k)
%Comp takes a vector v or a matrix A and an integer index k and first computes the kth 
%largest element (in absolute value) in v.  If we call this value q, Comp then sets to 
%0 all values in v smaller (in absolute value) than q and returns this modified vector.  
%If k is larger than the number of elements in v or A, then k is reset to the number of 
%elements in v or A.  If k is 0 or negative, Comp converts all elements to 0.

if k~=floor(k)
    str=('Comp: The second argument must be a nonnegative integer.  Returning v.');
    disp(str);
    y=v;
    return;
end;

if k<0 
    str=('Comp: The second argument must be a nonnegative integer.  Returning v.');
    disp(str);
    y=v;
    return;
end;

[r c]=size(v);
t=sort(reshape(abs(v),1,r*c),'descend');
d=t(k);

y=v.*(abs(v)>=d);
