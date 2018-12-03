function y = MSE(A,B)
%MSE takes two matrices as input and returns the mean squared error between
%the two matrices.

[rA cA]=size(A);
[rB cB]=size(B);
d=sum([rA cA]-[rB cB]);

if d~=0
    str=('MSE:  The dimensions of the input matrices must be identical - returning -1.');
    disp(str);
    y=-1;
    return;
else
    y=sum(sum((A-B).^2))/(rA*cA);
end;
