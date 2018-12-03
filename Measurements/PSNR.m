function y = PSNR(A,B)
%PSNR computes the Peak Signal-To-Noise ratio between the two input
%matrices.

[rA cA]=size(A);
[rB cB]=size(B);
d=sum([rA cA]-[rB cB]);

if d~=0
    str=('PSNR:  The dimensions of the input matrices must be identical - returning -1.');
    disp(str);
    y=-1;
    return;
else
    y=10*log10(255^2/MSE(A,B));
end;
