% =================== Train Monthly Neural Network Models ===================
% =================== Albedo-Tb-relationship-model ===================

clear;
clc;

monthList = {'May', 'Jun', 'Jul', 'Aug', 'Sep'};

for h = 1:length(monthList)
    disp(['Processing ' monthList{h} ' data...']);
    load(['Data path' monthList{h} '.mat']);
    trainingData = eval(monthList{h});
    
    % Data columns:
    % 1:doy, 2:sic, 3~7:Tb (h19, v19, v22, h37, v37),
    % 8:alb, 9:lon, 10:lat, 11:sza
    
    h19 = trainingData(:,3);
    v19 = trainingData(:,4);
    v22 = trainingData(:,5);
    h37 = trainingData(:,6);
    v37 = trainingData(:,7);
    sic = trainingData(:,2);
    output = trainingData(:,8);
    lon = trainingData(:,9);
    lat = trainingData(:,10);
    sza = trainingData(:,11);
    doy = trainingData(:,1);
    

    diff = [h19 - v19, h19 - v22, h19 - h37, h19 - v37, ...
            v19 - v22, v19 - h37, v19 - v37, v22 - h37, v22 - v37, h37 - v37];

    pr19 = (v19 - h19) ./ (v19 + h19);
    pr37 = (v37 - h37) ./ (v37 + h37);
    grv  = (v37 - v19) ./ (v37 + v19);
    
    sintau = sin(doy/365 * 360/180 * pi);
    costau = cos(doy/365 * 360/180 * pi);
    
    input = [h19, v19, v22, h37, v37, diff, pr19, pr37, grv, lon, lat, sintau, costau, sic, sza];
    
    [inputn, inputps] = mapminmax(input');
    [outputn, outputps] = mapminmax(output');
    
    numSamples = size(trainingData, 1);
    k = rand(1, numSamples);
    [~, nIdx] = sort(k);
    numTrain = min(30000, numSamples);
    train_input  = input(nIdx(1:numTrain), :)';
    train_output = output(nIdx(1:numTrain), :)';
    train_inputn  = mapminmax('apply', train_input, inputps);
    train_outputn = mapminmax('apply', train_output, outputps);
    
    RMSE_total = [];
    Nets_total = cell(100, 1);
    
    for i = 1:100
        disp(['  Training model ' num2str(i) ' ...']);
        net = newff(train_inputn, train_outputn, [30, 20, 10]);
        net.trainParam.epochs = 200;
        net.trainParam.lr = 0.1;
        net.trainParam.goal = 0.00004;
        net.trainParam.showWindow = false;
        net.trainParam.showCommandLine = false;
        
        net = train(net, train_inputn, train_outputn);
        Nets_total{i} = net;
        
        ann = sim(net, train_inputn);
        BPoutput = mapminmax('reverse', ann, outputps);
        RMSE = sqrt(mean((train_output - BPoutput).^2));
        RMSE_total = [RMSE_total; RMSE];
    end
    
    [~, index] = sort(RMSE_total);
    if length(index) >= 90
        Nets = Nets_total(index(11:90));
    else
        Nets = Nets_total; 
    end
    
    filename = ['Output model path' monthList{h} 'net.mat'];
    save(filename, 'Nets', 'inputps', 'outputps');
    disp([monthList{h} ' model saved!']);
end

disp('All monthly models have been trained!');
