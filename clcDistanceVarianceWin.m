function Distance = clcDistanceVarianceWin(A, B, Step, Off, AWin, Display, stepQY)
% A : input traces
% B : input traces
% Off : off control
% Step：win step
% AWin : win size for A
% Display : display alignment
% stepQY：step for dynamic programming

LengthA = size(A,1);
LengthB = size(B,1);
Off = Off + abs(LengthA-LengthB);
%%%%%%%%%%%% window setting %%%%%%
AWin = round(AWin/2);
ASelect = 10:Step:LengthA-10; %% win step
ASelectWin = AWin(ASelect);
AWinNum = length(ASelect);
%% error matrix
SM = zeros(AWinNum, LengthB) + realmax;
for indexAWin = 1:AWinNum
    indexA = ASelect(indexAWin);
    win = ASelectWin(indexAWin);
    win = min([win, indexA-1, LengthA-indexA]);
    AWinData = A(indexA + (-1*win:win),:);
    for indexB = (win+1):(LengthB-win)
        if abs(indexA - indexB) <= Off
            BWinData = B(indexB + (-1*win:win),:);
            diff = AWinData' - BWinData';
            SM(indexAWin, indexB) = sum(diff(:) .^ 2) / length(diff);
        end
    end
end
%% dynamic programming
%%%%%%%%%%%%%% cost matrix %%%%%%%%%%%%
D = zeros(size(SM)+1);
D(1:end-1,1:end-1) = SM;
D(end,:) = realmax;
D(:,end) = realmax;
D(end,end) = 0;
phi = zeros(size(D)); %  path
%%%%%%%%%%%%% traceback %%%%%%%%%%%%%%
for i = 2:AWinNum
    ValueLast = D(i-1,:);
    if i == 2
        ValueLastIndex = find(ValueLast ~= realmax);
    else
        ValueLastIndex = find(ValueLast ~= realmax & phi(i-1,:) ~= 0); 
    end
    Value = D(i,:);
    ValueIndex = find(Value ~= realmax);
    for j = ValueIndex
        ValueLastIndexValid = min(ValueLastIndex):min((j-stepQY), max(ValueLastIndex)); % 上一步的有效索引
        if ~isempty(ValueLastIndexValid)
            [dmax, tb] = min(ValueLast(ValueLastIndexValid));  
            D(i,j) = D(i,j) + dmax;
            phi(i,j) = ValueLastIndexValid(tb);
        end
    end
end
Value = D(AWinNum,:);
ValueIndex = find(Value ~= realmax & phi(AWinNum,:) ~= 0);
[dmax, tb] = min(Value(ValueIndex));  
D(end,end) = D(end,end) + dmax;
phi(end,end) = ValueIndex(tb);
%%%%%%%%%%%% Traceback from top left %%%%%%
Path = zeros(AWinNum, 1);
Path(end) = phi(end,end);
for index = (AWinNum-1):-1:1
    temp = Path(index+1); % last index
    Path(index) = phi(index+1,temp);
end
%%%%%%%%%%% last distance %%%%%%%%%%%%%%
Distance = D(end,end) / length(ASelect);
%% show alignment
if Display == 1
    p = ASelect;
    q = Path;
    ALarge = A+max(B(:))+2;
    figure; hold on;
    plot(ALarge);
    plot(B);
    pointPairsLength = length(p);
    for indexPlot = 1:pointPairsLength
        pointIndex = [p(indexPlot), q(indexPlot)];
        plot([pointIndex(1), pointIndex(2)], ...
            [ALarge(pointIndex(1)), B(pointIndex(2))], ...
            'r');
    end
end
end