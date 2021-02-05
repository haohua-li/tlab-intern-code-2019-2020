clear; clc; 
% specify the filename and load data 
filename = 'sleep_period_middle_sleep_S12_night2_EEGL_N.mat'; 
load(filename)
%-------------------------------------------------------------------------
% plot the PCA trajactory 
%------------------------------------------------------------------------- 
% Each row is an observation or sample, Each column is a predictor variable 
data = middle_sleep_data;  
pointsColor = middle_sleep_cluster_color; 
% centralize the distribution to zero 
for i = 1:size(data, 2)
    data(:,i) = data(:,i) - mean(data(:,i)); 
end 
% start the PCA 
[coeff,score,latent,tsquared,explained] = pca(data); 
% 3D plotting 
figure 
x = score(:,1); 
y = score(:,2); 
z = score(:,3); 
hold on
scatter3(x, y, z, 15, pointsColor, 'filled')
title(['PCA to dataset: ' filename])
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')
lh = plot3(x, y, z, '-');           % add line-connection to the Matlab figure  
lh.Color = [0.6, 0.6, 0.6, 0.3]; 
view(3)

sk = 10; 
tx = x(1:sk:end, 1); 
ty = y(1:sk:end, 1); 
tz = z(1:sk:end, 1); 
str = strsplit(num2str(1:sk:size(data, 1))); 
text(tx, ty, tz,str)
grid on 
hold off

