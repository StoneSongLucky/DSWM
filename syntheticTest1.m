%% Note
%%% synthetic data test with only amplitude noise
clc;
clear;
close all;
%% Load data
load seiData3DNoise8dB
load bottomHorizon.txt
load topHorizon.txt
[sampleNum,crosslineNum,inlineNum] = size(seiData3DNoise);
%% Show data
showData = squeeze(seiData3DNoise(:,1,:))';
showSeiData(showData(1:3:end,:)); hold on;
plot(topHorizon(1:3:end), 'LineWidth',2); hold on;
plot(bottomHorizon(1:3:end), 'LineWidth',2);
%% Constract 2D horizon for 3D synthetic data
hori2DTop = repmat(topHorizon,1,crosslineNum)';
hori2DBottom = repmat(bottomHorizon,1,crosslineNum)';
%% Label data
class1InlineIndex = 20;
class2InlineIndex = 60;
class3InlineIndex = 100;
faceTrue = zeros(crosslineNum, inlineNum);
faceTrue(:,1:40) = 1;
faceTrue(:,41:80) = 2;
faceTrue(:,81:120) = 3;
%% KNN using top horizon
horiUp = 20; horiDown = 20;
class1Traces = seiData3DNoise(hori2DTop(21,class1InlineIndex)-horiUp:hori2DTop(21,class1InlineIndex)+horiDown,21,class1InlineIndex);
class2Traces = seiData3DNoise(hori2DTop(21,class2InlineIndex)-horiUp:hori2DTop(21,class2InlineIndex)+horiDown,21,class2InlineIndex);
class3Traces = seiData3DNoise(hori2DTop(21,class3InlineIndex)-horiUp:hori2DTop(21,class3InlineIndex)+horiDown,21,class3InlineIndex);
% showSeiData(class1Traces');showSeiData(class2Traces');showSeiData(class3Traces');
faceMap = zeros(crosslineNum, inlineNum);
for indexCrossline = 1:crosslineNum
    for indexInline = 1:inlineNum
        traces = seiData3DNoise(hori2DTop(indexCrossline,indexInline)-horiUp:hori2DTop(indexCrossline,indexInline)+horiDown,indexCrossline,indexInline);
        disToClass1 = norm(traces-class1Traces);
        disToClass2 = norm(traces-class2Traces);
        disToClass3 = norm(traces-class3Traces);
        [~, classIndex] = min([disToClass1,disToClass2,disToClass3]);
        faceMap(indexCrossline,indexInline) = classIndex;
    end
end
figure;imagesc(faceMap);colormap(jet(3));
temp = faceMap == faceTrue;
acc = 100*sum(temp(:))/(crosslineNum*inlineNum);
fprintf('The up horizon accuracy: %f%%\n', acc);
%% KNN using bottom horizon
horiUp = 20; horiDown = 20;
class1Traces = seiData3DNoise(hori2DBottom(21,class1InlineIndex)-horiUp:hori2DBottom(21,class1InlineIndex)+horiDown,21,class1InlineIndex);
class2Traces = seiData3DNoise(hori2DBottom(21,class2InlineIndex)-horiUp:hori2DBottom(21,class2InlineIndex)+horiDown,21,class2InlineIndex);
class3Traces = seiData3DNoise(hori2DBottom(21,class3InlineIndex)-horiUp:hori2DBottom(21,class3InlineIndex)+horiDown,21,class3InlineIndex);
faceMap = zeros(crosslineNum, inlineNum);
for indexCrossline = 1:crosslineNum
    for indexInline = 1:inlineNum
        traces = seiData3DNoise(hori2DBottom(indexCrossline,indexInline)-horiUp:hori2DBottom(indexCrossline,indexInline)+horiDown,indexCrossline,indexInline);
        disToClass1 = norm(traces-class1Traces);
        disToClass2 = norm(traces-class2Traces);
        disToClass3 = norm(traces-class3Traces);
        [~, classIndex] = min([disToClass1,disToClass2,disToClass3]);
        faceMap(indexCrossline,indexInline) = classIndex;
    end
end
figure;imagesc(faceMap);colormap(jet(3));
temp = faceMap == faceTrue;
acc = 100*sum(temp(:))/(crosslineNum*inlineNum);
fprintf('The bottom horizon accuracy: %f%%\n', acc);
%% KNN-DSWM using top horizon
sizeLocalWin = 20;
Off = 8; Display = 0;
Step = 5; stepQY = 3;
horiUp = 20; horiDown = 20;
class1Traces = seiData3DNoise(hori2DTop(21,class1InlineIndex)-horiUp:hori2DTop(21,class1InlineIndex)+horiDown,21,class1InlineIndex);
class2Traces = seiData3DNoise(hori2DTop(21,class2InlineIndex)-horiUp:hori2DTop(21,class2InlineIndex)+horiDown,21,class2InlineIndex);
class3Traces = seiData3DNoise(hori2DTop(21,class3InlineIndex)-horiUp:hori2DTop(21,class3InlineIndex)+horiDown,21,class3InlineIndex);
% showSeiData(class1Traces');showSeiData(class2Traces');showSeiData(class3Traces');
faceMap = zeros(crosslineNum, inlineNum);
for indexCrossline = 1:crosslineNum
    for indexInline = 1:inlineNum
        traces = seiData3DNoise(hori2DTop(indexCrossline,indexInline)-horiUp:hori2DTop(indexCrossline,indexInline)+horiDown,indexCrossline,indexInline);
        currentTraceWin = zeros(size(traces)) + sizeLocalWin;
        disToClass1 = clcDistanceVarianceWin(traces, class1Traces,Step,Off,currentTraceWin,Display,stepQY);
        disToClass2 = clcDistanceVarianceWin(traces, class2Traces,Step,Off,currentTraceWin,Display,stepQY);
        disToClass3 = clcDistanceVarianceWin(traces, class3Traces,Step,Off,currentTraceWin,Display,stepQY);
        [~, classIndex] = min([disToClass1,disToClass2,disToClass3]);
        faceMap(indexCrossline,indexInline) = classIndex;
    end
end
figure;imagesc(faceMap);colormap(jet(3));
temp = faceMap == faceTrue;
acc = 100*sum(temp(:))/(crosslineNum*inlineNum);
fprintf('The up horizon using DSWM accuracy: %f%%\n', acc);
%% KNN-DSWM using bottom horizon
sizeLocalWin = 20;
Off = 8; Display = 0;
Step = 5; stepQY = 3;
horiUp = 20; horiDown = 20;
class1Traces = seiData3DNoise(hori2DBottom(21,class1InlineIndex)-horiUp:hori2DBottom(21,class1InlineIndex)+horiDown,21,class1InlineIndex);
class2Traces = seiData3DNoise(hori2DBottom(21,class2InlineIndex)-horiUp:hori2DBottom(21,class2InlineIndex)+horiDown,21,class2InlineIndex);
class3Traces = seiData3DNoise(hori2DBottom(21,class3InlineIndex)-horiUp:hori2DBottom(21,class3InlineIndex)+horiDown,21,class3InlineIndex);
% showSeiData(class1Traces');showSeiData(class2Traces');showSeiData(class3Traces');
faceMap = zeros(crosslineNum, inlineNum);
for indexCrossline = 1:crosslineNum
    for indexInline = 1:inlineNum
        traces = seiData3DNoise(hori2DBottom(indexCrossline,indexInline)-horiUp:hori2DBottom(indexCrossline,indexInline)+horiDown,indexCrossline,indexInline);
        currentTraceWin = zeros(size(traces)) + sizeLocalWin;
        disToClass1 = clcDistanceVarianceWin(traces, class1Traces,Step,Off,currentTraceWin,Display,stepQY);
        disToClass2 = clcDistanceVarianceWin(traces, class2Traces,Step,Off,currentTraceWin,Display,stepQY);
        disToClass3 = clcDistanceVarianceWin(traces, class3Traces,Step,Off,currentTraceWin,Display,stepQY);
        [~, classIndex] = min([disToClass1,disToClass2,disToClass3]);
        faceMap(indexCrossline,indexInline) = classIndex;
    end
end
figure;imagesc(faceMap);colormap(jet(3));
temp = faceMap == faceTrue;
acc = 100*sum(temp(:))/(crosslineNum*inlineNum);
fprintf('The bottom horizon using DSWM accuracy: %f%%\n', acc);
%% KNN-DSWM using both horizons
sizeLocalWin = 20;
Off = 8; Display = 0;
Step = 5; stepQY = 3;
horiUp = 20; horiDown = 20;
class1Traces = seiData3DNoise(hori2DTop(21,class1InlineIndex)-horiUp:hori2DBottom(21,class1InlineIndex)+horiDown,21,class1InlineIndex);
class2Traces = seiData3DNoise(hori2DTop(21,class2InlineIndex)-horiUp:hori2DBottom(21,class2InlineIndex)+horiDown,21,class2InlineIndex);
class3Traces = seiData3DNoise(hori2DTop(21,class3InlineIndex)-horiUp:hori2DBottom(21,class3InlineIndex)+horiDown,21,class3InlineIndex);
% showSeiData(class1Traces');showSeiData(class2Traces');showSeiData(class3Traces');
faceMap = zeros(crosslineNum, inlineNum);
for indexCrossline = 1:crosslineNum
    for indexInline = 1:inlineNum
        traces = seiData3DNoise(hori2DTop(indexCrossline,indexInline)-horiUp:hori2DBottom(indexCrossline,indexInline)+horiDown,indexCrossline,indexInline);
        currentTraceWin = zeros(size(traces)) + sizeLocalWin;
        disToClass1 = clcDistanceVarianceWin(traces,class1Traces,Step,Off,currentTraceWin,Display,stepQY);
        disToClass2 = clcDistanceVarianceWin(traces,class2Traces,Step,Off,currentTraceWin,Display,stepQY);
        disToClass3 = clcDistanceVarianceWin(traces,class3Traces,Step,Off,currentTraceWin,Display,stepQY);
        [~, classIndex] = min([disToClass1,disToClass2,disToClass3]);
        faceMap(indexCrossline,indexInline) = classIndex;
    end
end
figure;imagesc(faceMap);colormap(jet(3));

temp = faceMap == faceTrue;
acc = 100*sum(temp(:))/(crosslineNum*inlineNum);
fprintf('The two horizon accuracy: %f%%\n', acc);