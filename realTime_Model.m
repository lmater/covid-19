function [linearCoef, expCoef, f0]=realTime_Model()

[J0, NCases, TCases, fullcases]=covid_Data();
plotModel=1;
gamma=1/J0;
NVectSize=size(NCases);days=NVectSize(2);
x= linspace(1,days,days);%old
xp= linspace(1,2*(days-1),9*(days-1));

for n  = 1:days
	iPrime_i(n)=NCases(n)/TCases(n);
end


[linearCoef,stats] =  polyfit(x,iPrime_i+gamma,1);
R=sqrt(1 - (stats.normr/norm(iPrime_i - mean(iPrime_i)))^2)

expCoef=polyfit(x,log(iPrime_i+gamma),1);
a=expCoef(2);
b=expCoef(1);

% in case of need
y1=transpose(iPrime_i+gamma);y2=transpose(x);
g = fittype('a-b*exp(-c*x)');
f0 = 0;%fit(y2,y1,g,'StartPoint',[[ones(size(y2)), -exp(-y2)]\y1; 1])

if plotModel==1
figure
plot( x, iPrime_i+gamma, xp, exp(a)*exp(xp*b),'r--', xp, linearCoef(1)*xp+linearCoef(2),'b--')
xlabel('days'); ylabel('iPrime_i+gamma');
end