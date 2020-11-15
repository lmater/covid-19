function [linearCoef, expCoef, f0]=covid_sigma()

[J0, NCases, TCases, fullcases]=covid_Data();
plotModel=0;

NVectSize=size(NCases);days=NVectSize(2);
x= linspace(1,days-J0,days-J0);
for n  = 1:days-J0
	I_t=0;
	for i  = 1:J0 I_t=I_t+NCases(n+i); end
	sigma(n)=NCases(n+J0)/I_t;
end

[linearCoef,stats] =  polyfit(x,sigma,1);
R=sqrt(1 - (stats.normr/norm(sigma - mean(sigma)))^2)

expCoef=polyfit(x,log(sigma+1/J0),1);
a=expCoef(2);
b=expCoef(1);

linearCoef_001 =  polyfit(x,exp(a)*0.99.^x,1);

% in case of need
y1=transpose(sigma);y2=transpose(x);
g = fittype('a-b*exp(-c*x)');
f0 = fit(y2,y1,g,'StartPoint',[[ones(size(y2)), -exp(-y2)]\y1; 1])

if plotModel==1
figure
plot( x, sigma, x, exp(a)*exp(x*b)-1/J0,x,linearCoef(1)*x+linearCoef(2),x,f0(x),'r--')
xlabel('days'); ylabel('sigma');
end