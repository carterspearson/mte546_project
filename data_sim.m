clear all;
clc;

dt = 1;
%4hrs in seconds
Tf = 14400;
%Tf = 30;
T = 0:dt:Tf;
len = length(T);

resist1 = zeros(1,len);
temp1 = zeros(1,len);

normal =  0.2216;
flushed = 0.4722;

resist2 = zeros(1,len);
temp2 = zeros(1,len);

intensity = zeros(1,len);
Q = 0.08;
R = 0.05;
S = 0.003;

img1 = imread('white_face.png');
img2 = imread('flushed_face.png');
meanInt1 = mean(img1(1,:));
meanInt2 = mean(img2(:));

%% Simulate the sensor model 
for i=1:len
    %Simulating Object Motion and Sensors
    
    v = R*randn(1);
    w = Q*randn(1);
    u = S*randn(1);
    
    resist1(i) = r(i*dt)+w;
    temp1(i) = t(resist1(i))+v;
    
    resist2(i) = 6850+u;
    temp2(i) = t(resist2(i))+v;
    
    intensity(i) = e(i*dt)+u;
end

%{
yy = [.22 .27 .30 .35 0.38 0.45 0.42 0.37 0.33 0.250 0.25];
xx = [1 3600 4500 6000 7500 9000 10000 11200 13000 14000 14400];
xx2 =[0 0 0 0 0 0 0 0 0 0 0];
plot(xx,yy);
p = polyfit(xx,yy,3);
%}
% subplot(4,1,1)
% plot(T,temp1)
% ylabel('temp sensor 1')
% %xlim([5000 Tf])
% 
% subplot(4,1,2)
% plot(T,temp2)
% ylabel('temp sensor 2')
% test = r(2);
% 
% subplot(4,1,3)
% plot(T,temp1-temp2)
% ylabel('temp diff')
% xlabel('time (s)')
% 
% 
% subplot(4,1,4)
% plot(T,intensity)
% ylabel('Skin Intensity')
% xlabel('time (s)')

%% Run fuzzy model

fis = readfis('fuzzy_model')
fuzzy_logic_output = zeros(1,len);

for i=1:len
    fuzzy_logic_output(i) = evalfis(fis, [temp1(i), intensity(i)]);
end

subplot(3,1,1)
plot(T, temp1)
ylabel('temp sensor 1')

subplot(3,1,2)
plot(T, intensity)
ylabel('Intensity')

subplot(3,1,3)
plot(T, fuzzy_logic_output)
ylabel('Risk level')

%% Functions

function T = r(X)
    x = X;
    %W = 0.0000334*x^4+0.0570*x^3-2.0703*x^2-27.2507*x+6500;
    T = 1.3963e-17*x^5-1.3575e-12*x^4+3.5235e-08*x^3-3.1909e-04*x^2+0.7443*x+6850;

    
end 

function W = e(X)
    
    x = X;
    %W = 0.0000334*x^4+0.0570*x^3-2.0703*x^2-27.2507*x+6500;
    %W = -1.5063e-20*x^5+4.8325e-16*x^4+-5.5818e-12*x^3-2.9553e-08*x^2-5.4620e-05*x+0.2206;
    W = -4.4365e-13*x^3+6.5367e-09*x^2-1.1781e-06*x+0.2170;
end
function Y = t(X)
    x = X;
    Y = -22.67*log(x)+234.43;
end
