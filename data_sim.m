clear all;
clc;

dt = 0.01;
Tf = 14400;
%Tf = 30;
T = 0:dt:Tf;
len = length(T);

x = zeros(1,len);
y = zeros(1,len);
Q = 0.08;
R = 0.05;
%% Simulate the sensor model 
for i=1:len
    %Simulating Object Motion and Sensors
    
    v = R*randn(1);
    w = Q*randn(1);
    
    x(i) = r(i*dt)+w;
    y(i) = t(x(i))+v;
    
end
%{
yy = [9000 9000 8500 8000 7500 7500 7500 8000 8500 9000 9000];
xx = [1 3600 4500 6000 7500 9000 10000 11200 13000 14000 14400];
xx2 =[0 0 0 0 0 0 0 0 0 0 0];
plot(xx,yy);
p = polyfit(xx,yy,5);
%}
plot(T,y)
xlim([5000 Tf])

test = r(2);

function W = r(X)
    x = X;
    %W = 0.0000334*x^4+0.0570*x^3-2.0703*x^2-27.2507*x+6500;
    W = 1.3963e-17*x^5-1.3575e-12*x^4+3.5235e-08*x^3-3.1909e-04*x^2+0.7443*x+6000;

    
end 
function Y = t(X)
    x = X;
    Y = -22.67*log(x)+234.43;
end