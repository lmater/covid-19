function [Dpd ,fullTcases ]=DelayedTime_predict()
plotModel=1;
[linearCoef, expCoef, f0]=DelayedTime_Model();
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
Is(n0-J0)=dPrime(n0);
Dp(n0)=D(n0);
ndeconf=55+10000 %morocco
% ndeconf=36+700 %belgium
for n  = n0-1:Maxdays-1
if n>=ndeconf
	sigma=0.2918* 0.9872^(n+1)-gamma;% 0.99^n morocco
	% sigma=0.3244* 0.9596^(n+1)-gamma;% 0.99^n belgium
else sigma=exp(expCoef(2))*exp((n)*expCoef(1))-gamma;
end
	Ip(n+1)=round((1+sigma)*Ip(n));
	Dp(n+2)=Dp(n+1)+round(gamma*Ip(n+1));
	dPrimep(n+2)=Dp(n+2)-Dp(n+1);
	
end
ParamexpCoef_1=exp(expCoef(1))
ParamexpCoef_2=exp(expCoef(2))
for n  = 2:n0-1
if n>=ndeconf
	sigma=0.3031* 0.9868^(n+1)-gamma;% 0.99^n morocco
	% sigma=0.3244* 0.9596^(n+1)-gamma;% 0.99^n belgium
else sigma=exp(expCoef(2))*exp((n0-n+1)*expCoef(1))-gamma;
end
	Ip(n0-n)=round(Ip(n0-n+1)/(1+sigma));
	Dp(n0-n+1)=Dp(n0-n+2)-round(gamma*Ip(n0-n+1));
	dPrimep(n0-n+2)=Dp(n0-n+2)-Dp(n0-n+1);
end

J0=0;
for n  = 1+J0:Maxdays-1+J0
	Dpd(n)=Dp(n-J0);
	dPrimepd(n)=dPrimep(n-J0);
end
for n  = 1:days
	Dpd(n)=0;
	dPrimepd(n)=0;
end

if plotModel==1
xDpd=linspace(1,Maxdays-1+J0,Maxdays-1+J0);
xDp0=linspace(1,Maxdays-1+J0,Maxdays-1+J0);
figure
plot(xDp0,Dpd,xFullcases,fullTcases)
xlabel('days'); ylabel('D');
figure
plot(xDp0,dPrimepd,xFullcases,fullcases)
xlabel('days'); ylabel('cases');
end