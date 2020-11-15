function [Dp,D, dPrimep, dPrime]=covid_predict()

[linearCoef, expCoef, f0]=covid_sigma();
[J0, NCases, TCases, fullcases]=covid_Data();
NVectSize=size(NCases);days=NVectSize(2); xData=linspace(1,days,days);
NVectSize=size(fullcases); xFullcases=linspace(1,NVectSize(2),NVectSize(2));
fullTcases(1)=fullcases(1);
for n  = 2:NVectSize(2)
	fullTcases(n)=fullTcases(n-1)+fullcases(n);
end
Maxdays=100; gamma=1/J0; D=TCases; dPrime=NCases; xp=linspace(1,Maxdays,Maxdays);

for n  = 1:days-J0-1
	% I(n)=0; for i  = 1:J0 I(n)=I(n)+NCases(n+i); end
	I(n)=dPrime(J0+n+1)/gamma;
end
xI=linspace(1,days-J0-1,days-J0-1);

n0=days-J0;
% n0=25;
Ip(n0-1)=I(n0-1);
Dp(n0)=D(n0+J0);
for n  = n0:Maxdays-1
	% sigma=exp(expCoef(2))*exp(n*expCoef(1))-gamma;
	% sigma=f0(1)-f0(2)*exp(-f0(3)*n);
	sigma=linearCoef(1)*n+linearCoef(2);
	Ip(n)=round((1+sigma)*Ip(n-1));
	Dp(n+1)=Dp(n)+round(gamma*Ip(n));
	dPrimep(n+1)=Dp(n+1)-Dp(n);
end
for n  = n0:Maxdays-1
	Dpd(n)=Dp(n-J0);
end

for n  = 2:n0
	sigma=linearCoef(1)*(n0-n+1)+linearCoef(2);
	Ip(n0-n+1)=round(Ip(n0-n+2)/(1+sigma));
	Dp(n0-n+1)=Dp(n0-n+2)-round(gamma*Ip(n0-n+1));
	Dpd(n0-n+1+J0)=Dpd(n0-n+2+J0)-round(gamma*Ip(n0-n+1));
end

dPrimep(n+1)=Dpd(n+1)-Dpd(n);

xDpd=linspace(1,Maxdays-1,Maxdays-1);
xIp=linspace(1,Maxdays-1,Maxdays-1);
xdPrimep=linspace(1,Maxdays,Maxdays);
figure
plot(xData,D, xDpd,Dpd, xdPrimep,Dp,xFullcases,fullTcases)
xlabel('days'); ylabel('D');
figure
plot(xData,dPrime, xdPrimep,dPrimep,xFullcases,fullcases)
xlabel('days'); ylabel('D');