function y = FiniteFourier(w,h,idx)
%FiniteFourier creates a finite Fourier series from independent variable w, a finite length list v, and a starting index.

s=0;
n=length(h);
for k=0:n-1
    s=s+h(k+1)*exp(i*w*(k-idx));
end
y=s;