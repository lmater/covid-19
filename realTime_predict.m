function []=realTime_predict()
plotModel=1;
[linearCoef, expCoef, f0]=realTime_Model();
[J0, NCases, TCases, fullcases]=covid_Data();
NVectSize=size(NCases);days=NVectSize(2); xData=linspace(1,days,days);
NVectSize=size(fullcases); xFullcases=linspace(1,NVectSize(2),NVectSize(2));
fullTcases(1)=fullcases(1);
for n  = 2:NVectSize(2)
	fullTcases(n)=fullTcases(n-1)+fullcases(n);
end
Maxdays=350; gamma=1/J0; D=TCases; dPrime=NCases; xp=linspace(1,Maxdays,Maxdays);

for n  = 1:days-1
	I(n)=dPrime(n+1)/gamma;
end

n0=days;
% n0=25;
Ip(n0-1)=I(n0-1);
Dp(n0)=D(n0);
for n  = n0-1:Maxdays-1
	% sigma=linearCoef(1)*(n+1)+linearCoef(2)-gamma;
	sigma=exp(expCoef(2))*exp((n+1)*expCoef(1))-gamma;
	% sigma=f0(1)-f0(2)*exp(-f0(3)*n)-gamma;
	Ip(n+1)=round((1+sigma)*Ip(n));
	Dp(n+2)=Dp(n+1)+round(gamma*Ip(n+1));
	dPrimep(n+2)=Dp(n+2)-Dp(n+1);
end

for n  = 2:n0-1
	% sigma=linearCoef(1)*(n0-n+1)+linearCoef(2)-gamma;
	sigma=exp(expCoef(2))*exp((n0-n+1)*expCoef(1))-gamma;
	% sigma=f0(1)-f0(2)*exp(-f0(3)*(n0-n))-gamma;
	Ip(n0-n)=round(Ip(n0-n+1)/(1+sigma));
	Dp(n0-n+1)=Dp(n0-n+2)-round(gamma*Ip(n0-n+1));
	dPrimep(n0-n+2)=Dp(n0-n+2)-Dp(n0-n+1);
end

% Dp0(1)=28;%morocco
% Ip0(1)=14;%morroco
Dp0(1)=1400;%belgium
Ip0(1)=340;%belgium
% Dp0(1)=0;%italy
% Ip0(1)=1550;%italy

for n  = 2:Maxdays-1
	% sigma=linearCoef(1)*(n)+linearCoef(2)-gamma;
	sigma=exp(expCoef(2))*exp((n)*expCoef(1))-gamma;
	% sigma=f0(1)-f0(2)*exp(-f0(3)*(n0-n))-gamma;
	Ip0(n)=round((1+sigma)*Ip0(n-1));
	Dp0(n)=Dp0(n-1)+round(gamma*Ip0(n-1));
	dPrimep0(n)=Dp0(n)-Dp0(n-1);
end

for n  = 1+J0:Maxdays-1+J0
	Ipd0(n)=0;%Ip0(n-J0);
	Dpd(n)=Dp(n-J0);
	dPrimepd(n)=dPrimep(n-J0);
	Dpd0(n)=0;%Dp0(n-J0);
	dPrimepd0(n)=0;%dPrimep0(n-J0);
end
for n  = 1:days
	Dpd0(n)=0;
	dPrimepd0(n)=0;
	Dpd(n)=0;
	dPrimepd(n)=0;
end


if plotModel==1
xDpd=linspace(1,Maxdays-1+J0,Maxdays-1+J0);
xDp0=linspace(1,Maxdays-1+J0,Maxdays-1+J0);
figure
plot(xDpd,Dpd0,xDp0,Dpd,xFullcases,fullTcases)
xlabel('days'); ylabel('D');
figure
plot(xDpd,dPrimepd0,xDp0,dPrimepd,xFullcases,fullcases)
xlabel('days'); ylabel('cases');
end