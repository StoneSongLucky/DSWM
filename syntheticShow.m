%% Note
%%% code to show the synthetic data and horizon
clc;
clear;
close all;
%% load data
load synDataSection.mat
load bottomHorizon.txt
load topHorizon.txt
%% show data
showSeiData(seiData(1:3:end,:)); hold on;
plot(topHorizon(1:3:end), 'LineWidth',2); hold on;
plot(bottomHorizon(1:3:end), 'LineWidth',2);