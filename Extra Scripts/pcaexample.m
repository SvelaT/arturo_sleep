%generate points
n_points = 200;
points = zeros(2,n_points);
stds = [2;0.5];

theta = pi/6;

R = [cos(theta) -sin(theta);
    sin(theta) cos(theta)];

points = R*diag(stds)*randn(2,n_points);

%Original Data
f1 = figure;
scatter(points(1,:),points(2,:));

for i = 1:1:n_points
    disp(['(' num2str(points(1,i)) ',' num2str(points(2,i)) ')']);
end

[coeff,score,latent,tsquared,explained,mu] = pca(points');
score = score';

points2 = coeff*points;

%PCA Components
f3 = figure;
scatter(score(1,:),score(2,:));

f4 = figure;
scatter(points2(1,:),points2(2,:));

pca1inc = coeff(2,1)/coeff(1,1);
pca2inc = coeff(2,2)/coeff(1,2);

