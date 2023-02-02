function [trainingFilePath, testingFilePath] = generateFeature1()

%     close all;
%     clear all;
%     clc;

    dataClass1 = mvnrnd([ 0, 0],[4,0,;0,1],1000)';
	dataClass2 = mvnrnd([10,10],[1,0;0,1],1000)';
	
    
%     figure;
%     hold on;
%     plot3(dataClass1(1,:),dataClass1(2,:),dataClass1(3,:), '.k');
%     plot3(dataClass2(1,:),dataClass2(2,:),dataClass2(3,:), '.b');
%     grid on;
    
    trainingFilePath.data = [dataClass1, dataClass2];
    trainingFilePath.target = [ones(1, 1e3), 2*ones(1, 1e3)];
    
    testingFilePath.data = [[0 0]', [10 10]'];
    testingFilePath.target = [1, 1];
    
%     plot3(testingFilePath.data(1,:),testingFilePath.data(2,:),testingFilePath.data(3,:), '+r');
    
end
