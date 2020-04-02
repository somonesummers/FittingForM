clear; close all

load("x2dThwaites.mat",'x2dThwaites','y2dThwaites','BasalDragThwaites');
uB = scatteredInterpolant(x2dThwaites,y2dThwaites,BasalDragThwaites);
%% clear out 0s
x2dThwaites = x2dThwaites(BasalDragThwaites~=0);
y2dThwaites = y2dThwaites(BasalDragThwaites~=0);
BasalDragThwaites = BasalDragThwaites(BasalDragThwaites~=0);
spd = measures_interp('speed',x2dThwaites,y2dThwaites);


%% Plot the field, do some stuff
figure(1)
subplot(231)
scatter(x2dThwaites,y2dThwaites,[],BasalDragThwaites,'filled')
c_scale = caxis();
colorbar
subplot(234)
histogram(BasalDragThwaites,20)

alpha = BasalDragThwaites./spd;

subplot(232)
scatter(x2dThwaites,y2dThwaites,[],alpha,'filled')
colorbar
hold on
subplot(235)
histogram(alpha,20)


G = [log(spd) ones(size(spd))];
b = -log(alpha);

x = G\b;

m_fit = (-x(1)+1)^(-1);
alpha_fit = exp(-x(2));
res = G*x - b;

subplot(233)
scatter(x2dThwaites,y2dThwaites,[],alpha_fit.*spd.^(1/m_fit),'filled')
colorbar
caxis(c_scale)
subplot(236)
histogram(alpha_fit.*spd.^m_fit,20)

figure(2)
clf
scatter(spd,BasalDragThwaites,'b.')
hold on
plot(0:10:5000,alpha_fit*(0:10:5000).^(1/m_fit),'r--')
