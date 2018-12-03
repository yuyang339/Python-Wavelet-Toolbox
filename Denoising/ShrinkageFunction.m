function y=ShrinkageFunction(t,lambda)
%ShrinkageFunction takes as input a real number, vector, or a matrix, and a tolerance 
%lambda, and either returns 0 or shrink the value lambda units closer 
%to the t-axis.

y=(abs(t)>=lambda).*sign(t).*(abs(t)-lambda);
