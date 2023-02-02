close all;
clear all;
clc;

% generate some data

 feature = mvnrnd([0,0,0,0]', eye(4), 2000)';
 feature(4,:) = sqrt(feature(1,:).^2 + feature(2,:).^2 + feature(3,:).^2);
% i = rand(1,100)*200;

% specify the indexed color for each point
icolor = ceil((feature(4, :)/max(feature(4, :)))*256);

figure;
% scatter3(feature(1, :),feature(2, :),feature(3, :),10, icolor,'filled');
scatter3(feature(1, :),feature(2, :),feature(3, :),10, feature(4, :),'filled');
% scatter3(x,y,z,i,icolor);
% scatter3(x,y,z,i,1, 'voltage');
% figure;
% scatter3(x,y,z,i,icolor,'filled');

% patch(isosurface(x,y,z,i,isovalue));



% X,Y,Z iz the meshgrid and V is my function evaluated at each meshpoint
% figure;
% hold on;
% for a = 10.^(1:4) % 'a' defines the isosurface limits
%     p = patch(isosurface(feature(1, :),feature(2, :),feature(3, :),feature(4, :), max(max(max((feature(4, :))))/a))); % isosurfaces at max(V)/a
%     isonormals(feature(1, :),feature(2, :),feature(3, :),feature(4, :),p); % plot the surfaces
%     set(p,'FaceColor','red','EdgeColor','none'); % set colors
% end
% alpha(.1); % set the transparency for the isosurfaces
% daspect([1 1 1]); box on; axis tight;