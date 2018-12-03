function y = Coif(K)
%Coif takes an integer K and returns the Coiflet filter
%of length 6*K.  This routine is only works for K=1,2,3.  For K=1 and K=3,
%the routine returns the filter coefficients.  For K=2, the module does
%solve the system of quadratic and linear equations described in Section
%8.3 of the book.

global COIFLENGTH;

if round(K)~=K
    str=sprintf('Coif: The input must be an integer - returning [0 0].');
    disp(str);
    y=[0; 0];
    return;
end;

if K<1 || K>3 
    str=sprintf('Coif: This module does not work for K<1 or K>3 - returning [0;0].');
    disp(str);
    y=[0; 0];
    return;
end;

COIFLENGTH=6*K;

if K==1
    r7=sqrt(7);
    d=16*sqrt(2);
    y=[1-r7; 5+r7; 2*(7+r7); 2*(7-r7); 1-r7; -3+r7]/d;
    return;
end;

if K==2
    guess=[1/sqrt(2);1/sqrt(2);zeros(COIFLENGTH-2,1)];
%    guess(1)=1/sqrt(2);
%    guess(2)=guess(1);
end;

if K==3
   y=[-0.0037935128643808; 0.007782596425673; 0.023452696142077;-0.06577191128147;-0.06112339000297;0.40517690240912;
       0.7937772226261;0.42848347637737;-0.071799821619155;-0.08230192710630;0.034555027573298;0.015880544863669;
       -0.009007976136731;-0.0025745176881368;0.00111751877083063;0.0004662169598204;-0.00007098330250638;-0.0000345997731972728];
   return;
end;

options=optimset('NonlEqnAlgorithm','gn','MaxFunEvals',1e8,'Tolfun',1e-16,'TolX',1e-16,'MaxIter',1e3);
y=fsolve(@Coiffun,guess,options);

