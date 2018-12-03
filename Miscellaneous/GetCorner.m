function B = GetCorner(A,m,n)
%GetCorner takes as input a matrix A and positive integers m and n (where m
%is less than or equal to the number of rows of A and n is less than or
%equal to the number of columns of A) and returns the upper left m x n
%submatrix of A.

B=A(1:m,1:n);