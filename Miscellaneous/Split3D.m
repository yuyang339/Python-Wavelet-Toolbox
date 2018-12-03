function [R,G,B] = Split3D(A)
%Split3D takes a three-dimensional A whose dimensions are r x c x 3 and
%returns three r x c matrices.  

t=size(A);
if length(t)~=3
    str=sprintf('Split3D: The input must be a three-dimensional array - returning 0 matrices.');
    disp(str);
    R=zeros(2,2); G=R; B=R;
    return;
end

if t(3)~=3
    str=sprintf('Split3D: The third dimension must be 3 - returning 0 matrices.');
    disp(str);
    R=zeros(2,2);
    G=R; B=R;
    return;
end

R=A(:,:,1); G=A(:,:,2); B=A(:,:,3);
