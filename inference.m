
clear; clc;

modelMay   = load("Maynet.mat", 'Nets', 'inputps', 'outputps');
modelJune  = load("Junnet.mat", 'Nets', 'inputps', 'outputps');
modelJuly  = load("Julnet.mat", 'Nets', 'inputps', 'outputps');
modelAug   = load("Augnet.mat", 'Nets', 'inputps', 'outputps');
modelSep   = load("Sepnet.mat", 'Nets', 'inputps', 'outputps');
models = containers.Map('KeyType','double','ValueType','any');
models(5) = modelMay; models(6) = modelJune; models(7) = modelJuly; models(8) = modelAug; models(9) = modelSep;

lonFile = '';
[lonData, ~] = geotiffread(lonFile);
lon = double(reshape(lonData, [], 1));
latFile = '';
[latData, ~] = geotiffread(latFile);
lat = double(reshape(latData, [], 1));

yearsToRun       = 2000:2024;
tb    = "";         
sicBase          = "";
szaBase          = "";
outputBase       = "";


for yy = yearsToRun
    fprintf('========== Start processing：%d ==========\n', yy);

    outputYearDir = fullfile(outputBase, sprintf('%d', yy));
    if ~isfolder(outputYearDir); mkdir(outputYearDir); end

    startDate = datetime(yy,5,1);
    endDate   = datetime(yy,9,30);
    dateList  = startDate:endDate;

    for d = dateList
        dateStr = datestr(d, 'yyyymmdd');

        tbFile = fullfile(tbDir, [dateStr, '.tif']);

        info = geotiffinfo(tbFile);
        [Tbdata, R] = geotiffread(tbFile);
        sicFile = fullfile(sicBase, [dateStr, '_.tif']);
        sic = double(geotiffread(sicFile));
        sic = reshape(sic, [], 1);
        SZAFile = fullfile(szaBase, [dateStr, '_SZA.tif']);
        SZAband = geotiffread(SZAFile);
        sza = double(SZAband) ;
        sza = reshape(sza, [], 1);

        h19 = double(Tbdata(:,:,1)) / 10.0; h19 = reshape(h19, [], 1);
        v19 = double(Tbdata(:,:,2)) / 10.0; v19 = reshape(v19, [], 1);
        v22 = double(Tbdata(:,:,3)) / 10.0; v22 = reshape(v22, [], 1);
        h37 = double(Tbdata(:,:,4)) / 10.0; h37 = reshape(h37, [], 1);
        v37 = double(Tbdata(:,:,5)) / 10.0; v37 = reshape(v37, [], 1);

        diff  = [h19-v19, h19-v22, h19-h37, h19-v37, v19-v22, v19-h37, v19-v37, v22-h37, v22-v37, h37-v37];
        pr19  = (v19-h19) ./ (v19+h19);
        pr37  = (v37-h37) ./ (v37+h37);
        grv   = (v37-v19) ./ (v37+v19);

        doy = day(d, 'dayofyear');
        Doy = double(ones(numel(h19),1) * doy);
        sintau = sin(Doy/365*360/180*pi);
        costau = cos(Doy/365*360/180*pi);

        input = [h19, v19, v22, h37, v37, diff, pr19, pr37, grv, lon, lat, sintau, costau, sic, sza];
        input = double(input);

        currentModel = models(m);
        Nets    = currentModel.Nets;
        inputps = currentModel.inputps;
        outputps= currentModel.outputps;

        inputn = mapminmax('apply', input', inputps);

        alb = [];
        for iNet = 1:length(Nets)
            net = Nets{iNet};
            ann = sim(net, inputn);
            BPoutput = mapminmax('reverse', ann, outputps);
            alb = [alb; BPoutput]; %#ok<AGROW>
        end
        Ealb = mean(alb);  
        Ealb = Ealb';      


        Ealb = reshape(Ealb, R.RasterSize);

        outputFile = fullfile(outputYearDir, ['Albedo_', dateStr, '_.tif']);
        geotiffwrite(outputFile, Ealb, R, 'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
    end
end

fprintf('=== Processing completed ===\n');
