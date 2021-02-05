%-------------------------------------------------------------------------
% RUN kmeans_clustering.m before running this
%------------------------------------------------------------------------- 

% Each row is an observation or sample, Each column is a predictor variable 
X = TS_DataMat; 
% centralize to zero
for i = 1:size(X, 2)
    X(:,i) = X(:,i) - mean(X(:,i)); 
end 

% start the PCA 
[coeff,score,latent,tsquared,explained] = pca(X); 

% 3D plotting 
figure 
x = score(:,1); 
y = score(:,2); 
z = score(:,3); 
pointsColor = zeros(size(x, 1), 3); 
for i = 1:size(x, 1)
    pointsColor(i, :) = c(idx(i),:); 
end 
%% 
figure 
hold on
scatter3(x, y, z, 15, pointsColor, 'filled')
title(['PCA to dataset: ', subjectId, ' ', nightId, ' ', channelId])
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')

lh = plot3(x, y, z, '-'); 
lh.Color = [0.6, 0.6, 0.6, 0.3]; 

view(3)
grid on 
hold off



