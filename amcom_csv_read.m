%% Array Organization

filename = 'test.csv';

data = readmatrix(filename, "NumHeaderLines", 1);

nanIndices = isnan(data);
data(nanIndices) = 0;

debit = data(:, 3); % payments
credit = data(:, 4); % income
balance = data(:, 5); % current bal.

% For future reference, import type purchase

dates = readmatrix(filename, "NumHeaderLines", 1 ,'OutputType', 'string');
dates = dates(:,6);

%% Convert dates to MMDDYYYY codes
codes = cell(size(dates));

for i = 1:numel(dates)
    dateStr = char(dates(i));
    try
        dateNum = datetime(dateStr, 'InputFormat', 'MM/dd/yyyy', 'Format', 'MMddyyyy');
    catch
        try
            dateNum = datetime(dateStr, 'InputFormat', 'MM/dd/yyyy', 'Format', 'MMddyyyy');
        catch
            disp(['Unable to convert date: ', dateStr]);
            continue;
        end
    end
    codes{i} = datestr(dateNum, 'mmddyyyy');
end

for i = 1:numel(codes)
    code = codes{i};
    month = str2double(code(1:2));  % Extract the month from the code
    year = str2double(code(5:8));   % Extract the year from the code
    disp(['Index: ', num2str(i), ', Code: ', code, ', Month: ', num2str(month), ', Year: ', num2str(year)]);
end

%% Balance Calculator

dates = datetime(dates);

uniqueCodes = unique(codes, "stable");
uniqueDates = unique(dates, "stable");
newbalance = 1:numel(unique(dates));
uniquebal =  1:numel(uniqueCodes);

ct = 1;
compfactor = numel(codes) - numel(uniqueCodes); % supplement factor for indexing

for i = numel(uniqueCodes):-1:1

    logicalIndex = strcmp(codes, uniqueCodes{i}); % finds # of occurance of code
    ct = sum(logicalIndex);

    fprintf("Day Purchases: %.f\n", ct)

    for j = 1:ct
        if i ~= numel(uniqueCodes)
            newbalance(i) = credit(i+compfactor) - debit(i+compfactor);
             uniquebal(i) = newbalance(i) + uniquebal(i + 1);
        else
            uniquebal(i) = credit(i+compfactor) - debit(i+compfactor);
        end
    end

    disp(['Index: ', num2str(i), ', Balance: ', uniquebal(i), ', Code: ', uniqueCodes{i}]);
end

%% Linegraph Account Bal.

figure;
plot(uniqueDates, uniquebal, 'b-', 'LineWidth', 1);

xtickangle(45)
yTickLength = 100; 
yticks(0:yTickLength:max(uniquebal));
axis padded

title('Account Balance');
xlabel('Time');
ylabel('USD $');
grid on;