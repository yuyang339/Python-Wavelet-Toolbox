function B = PutCorner(A,M)
%PutCorner takes as input a matrix A and a matrix M (whose dimensions are
%less than or equal to those of A) and returns a matrix where M is inserted
%into the upper left-hand corner of A.

[Ar Ac]=size(A);
[Mr Mc]=size(M);

if Mr>Ar || Mc>Ac
    str='PutCorner: The dimensions of M must be less than or equal to those of A - returning A';
    disp(str);
    B=A;
    return;
end

bottom=A(Mr+1:end,:);
upperleft=A(1:Mr,Mc+1:end);
top = [M upperleft];
B=[top; bottom];