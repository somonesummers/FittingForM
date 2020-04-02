%%  Messing around to see if this even makes sense
clear
%% Make m ~ 3 data
m = 3;
a = 10;
n = 1000;

u = abs(logspace(0,3.5,n)' +  10*randn(n,1)); 
a_noise = a + 1*randn(n,1);
m_noise = m + .2*randn(n,1);
tau = a_noise.*u.^(1./m_noise);

figure(1)
clf;
subplot(221)
scatter(u,tau,[],'.')
xlabel('speed')
ylabel('\tau')
hold on
plot(0:10:5000,a*(0:10:5000).^(1/m))
title("Sliding Law");

%% Divide to find m = 1 fit
a_1 = tau./u;

subplot(222)
scatter(u,tau,[],log(a_1),'.')
set(gca,'xscale','log','yscale','log')
xlabel('speed')
ylabel('\tau')
colorbar
title("log(a_1) for linear sliding law (loglog)");

%% Invert by Least Squares
G = [log(u) ones(size(u))];
b = -log(a_1);

x = G\b;

m_fit = (-x(1)+1)^(-1);
a_fit = exp(-x(2));
res = G*x - b;

disp("m fit to: " + m_fit + " with \alpha_m: " + a_fit + ". Residual: " + norm(res)/n);
subplot(212)
scatter(u,tau,[],'.')
xlabel('speed')
ylabel('\tau')
hold on
plot(0:10:5000,a*(0:10:5000).^(1/m),'k--')
plot(0:10:5000,a_fit*(0:10:5000).^(1/m_fit),'r')
legend('Data','True','Fit','Location','SouthEast');
title("Sliding Law");
