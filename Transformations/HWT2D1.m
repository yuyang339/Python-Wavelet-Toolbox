function B = HWT2D1(A)
%HWT2D1 takes as input a matrix A of even dimension M x N and returns 
%one iteration of the two-dimensional discrete Haar wavelet transformation.

[r c]=size(A);
if mod(r,2)==1 || mod(c,2)==1
    str=sprintf('HWT2D1: The dimensions of the input matrix must be even. Returning the input matrix.');
    disp(str);
    B=A;
    return;
end;

C=LeftHWT(A);
B=RightHWT(C);