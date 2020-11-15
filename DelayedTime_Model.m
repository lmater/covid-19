function [linearCoef, expCoef, f0]=DelayedTime_Model()

[J0, NCases, TCases, fullcases]=covid_Data();
plotModel=1;
gamma=1/J0;
NVectSize=size(NCases);days=NVectSize(2);
% x= linspace(1,days-J0-1,days-J0-1);%old
x= linspace(1,days-J0-1,days-J0-1);%old
xp= linspace(1,5*(days-1),9*(days-1));

for n  = 2:days-J0

it=TCases(n-1+J0)-TCases(n-1); 
iPrime_i(n-1)=NCases(n+J0)/it;

% iPrime_i(n-1)=NCases(n+J0)/TCases(n-1+J0);

end

[linearCoef,stats] =  polyfit(x,iPrime_i+gamma,1);
Rlin=sqrt(1 - (stats.normr/norm(iPrime_i - mean(iPrime_i)))^2);

[expCoef,stats]=polyfit(x,log(iPrime_i+gamma),1)
Rexp=sqrt(1 - (stats.normr/norm(iPrime_i - mean(iPrime_i)))^2);
a=expCoef(2);
b=expCoef(1);

% in case of need
y1=transpose(iPrime_i+gamma);y2=transpose(x);
g = fittype('a-b*exp(-c*x)');
f0 = 0;%fit(y2,y1,g,'StartPoint',[[ones(size(y2)), -exp(-y2)]\y1; 1])

if plotModel==1
figure
plot( x, iPrime_i+gamma, xp, exp(a)*exp(xp*b),'r--')
xlabel('days'); ylabel('iPrime_i+gamma');
end