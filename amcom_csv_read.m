function [] = amcom_csv_read()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           American Community Bank and Trust Budgeting Program           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Description:
%   This MATLAB code organizes data from a CSV file and performs various
%   calculations and categorizations. It reads the data from the file,
%   processes it, and generates a pie chart and count display based on
%   different categories. The code also includes manual entry functionality
%   for categorizing data. The categorized data is then used to generate
%   visualizations and summary statistics.
%
%           THIS IS NO WAY ASSOCIATED WITH AMERICAN COMMUNITY BANK 
%                       AND TRUST ONLY FOR PERSONAL USE.
%
%   Notes:  
%           - Removed Line graph due to balance calculation bug.
%           - Enter 'help' during manual input sequence for valid entries.
%      
%
% Author: [bcrudele]
% Date: [05/27/2023]
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Array Organization

filename = 'test.csv';

data = readmatrix(filename, "NumHeaderLines", 1);

nanIndices = isnan(data); % replaces empty data with 0's
data(nanIndices) = 0;

debit = data(:, 3); % payments
credit = data(:, 4); % income
balance = data(:, 5); % current bal.

waterCompanies = list_water();          % water companies
utilityProviders = list_utilities();    % utility companies
streamingPlatforms = list_subscriptions();  % subscription / monthly payments
stores = list_stores();     % purchases at stores
services = list_services(); % service costs
schools = list_schools();   % school costs
cellProviders = list_phone();   % cell phone providers
paymentPlatforms = list_payments();     % payment platforms (Venmo etc.)
rentalPlatforms = list_housing();   % housing (rent, mortgage etc.)
healthProviders = list_health();    % health costs (hospital, insurance  etc.)
gasStations = list_gasStations();   % gas
food = list_foods();                % food (restaurants)
entertainment = list_entertainment();   % entertainment (movies, bowling etc.)
deposits = list_deposits();     % acct. deposits
cars = list_cars();         % cars (payment)
carInsuranceCompanies = list_carInsurance();    % car insurance
bankingTransfers = list_bankTransfers();        % bank account transfers
investing = list_investing();

data = readmatrix(filename, "NumHeaderLines", 1 ,'OutputType', 'string');
dates = data(:,6);  % purchase dates
descriptions = data(:, 7); % descriptions of purchases

%% Convert Dates to MMDDYYYY Codes
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
    codes{i} = datestr(dateNum, 'mmddyyyy');  % generates codes in mmddyyyy format
end

for i = 1:numel(codes)
    code = codes{i};
    month = str2double(code(1:2));  % Extract the month from the code
    year = str2double(code(5:8));   % Extract the year from the code
    % disp(['Index: ', num2str(i), ', Code: ', code, ', Month: ', num2str(month), ', Year: ', num2str(year)]);
end

%% Summation Machine

categories = 16; % number of categories (includes 'other')

dollars = zeros(1,categories); % vector for dollar values
counts = zeros(1,categories);  % vector for counted purchases
manualEntries = zeros(1,numel(codes)); % saving indices for manual overwrite
ct = 1;

for i = 1:numel(codes)

    if (contains(descriptions(i), food, 'IgnoreCase', true))
        counts(1) = counts(1) + 1;
        dollars(1) = dollars(1) + debit(i);
    elseif (contains(descriptions(i), utilityProviders, 'IgnoreCase', true))...
            || (contains(descriptions(i), waterCompanies, 'IgnoreCase', true))
        counts(2) = counts(2) + 1;
        dollars(2) = dollars(2) + debit(2);
    elseif (contains(descriptions(i), stores, 'IgnoreCase', true))
        counts(3) = counts(3) + 1;
        dollars(3) = dollars(3) + debit(i);
    elseif (contains(descriptions(i), cellProviders, 'IgnoreCase', true))
        counts(4) = counts(4) + 1;
        dollars(4) = dollars(4) + debit(i);
    elseif (contains(descriptions(i), healthProviders, 'IgnoreCase', true))
        counts(5) = counts(5) + 1;
        dollars(5) = dollars(5) + debit(i);
    elseif (contains(descriptions(i), cars, 'IgnoreCase', true)) || ...
            (contains(descriptions(i), carInsuranceCompanies, 'IgnoreCase', true))
        counts(6) = counts(6) + 1;
        dollars(6) = dollars(6) + debit(i);
    elseif (contains(descriptions(i), rentalPlatforms, 'IgnoreCase', true))
        counts(7) = counts(7) + 1;
        dollars(7) = dollars(7) + debit(i);
    elseif (contains(descriptions(i), streamingPlatforms, 'IgnoreCase', true))
        counts(8) = counts(8) + 1;
        dollars(8) = dollars(8) + debit(i);
    elseif (contains(descriptions(i), paymentPlatforms, 'IgnoreCase', true))
        counts(9) = counts(9) + 1;
        dollars(9) = dollars(9) + debit(i);
    elseif (contains(descriptions(i), gasStations, 'IgnoreCase', true))
        counts(10) = counts(10) + 1;
        dollars(10) = dollars(10) + debit(i);
    elseif (contains(descriptions(i), deposits, 'IgnoreCase', true))
        counts(11) = counts(11) + 1;
        dollars(11) = dollars(11) + credit(i);
    elseif (contains(descriptions(i), schools, 'IgnoreCase', true))
        counts(12) = counts(12) + 1;
        dollars(12) = dollars(12) + debit(i);
    elseif (contains(descriptions(i), entertainment, 'IgnoreCase', true))
        counts(13) = counts(13) + 1;
        dollars(13) = dollars(13) + debit(i);
    elseif (contains(descriptions(i), services, 'IgnoreCase', true))
        counts(14) = counts(14) + 1;
        dollars(14) = dollars(14) + debit(i);
    elseif (contains(descriptions(i), investing, 'IgnoreCase', true))
        counts(15) = counts(15) + 1;
        dollars(15) = dollars(15) + debit(i);
        % Banking Transfers
    elseif (contains(descriptions(i), bankingTransfers, 'IgnoreCase', true))
        %counts(x) = counts(x) + 1;
        %dollars(x) = dollars(x) + debit(i);
    else
        counts(16) = counts(16) + 1;
        dollars(16) = dollars(16) + debit(i);
        manualEntries(ct) = i;
        ct = ct + 1;
    end
end

%% Manual Entry
% For an executable, the manual entry must be re-evaluated

ct = 1;
validCategories = {'skip','Foods', 'Utilities', 'Stores', 'Phone', 'Health', 'Car', 'Housing', 'Subscriptions', 'Payments', 'Income','School','Gas','Entertainment','Services','Investing','Other'};
helpStrings = {'help', 'HELP', 'Help'};
skipStrings = {'skip'};
manualCategories = {};
manualEntries = manualEntries(manualEntries > 0); % remove non-valid indices

while ct <= numel(manualEntries)
    disp("=======")
    inputCategory = 'NULL';
    fprintf("Manual Input %.f/%.f\n",ct,numel(manualEntries));
    fprintf("\nPurchase Description: %s\n\n",descriptions(manualEntries(ct)));
    fprintf("Enter: 'help' to see available categories\n")
    while ~any(strcmpi(validCategories, inputCategory))
        inputCategory = input('Enter a category: ', 's');
        inputCategory = lower(inputCategory);
        if any(strcmpi(helpStrings, inputCategory))
            fprintf("\nFoods|Utilities|Stores|Phone|Health|Car|Housing|Subscriptions|Payments\nGas|Income|School|Entertainment|Services|Investing|Other\n");
            fprintf("Enter 'skip' to auto-fill remaining inputs to 'Other'\n");
        elseif ~any(strcmpi(validCategories, inputCategory))
            disp('Invalid category');
        end
        if any(strcmpi(skipStrings, inputCategory))
            fprintf('\nSkipped %.f descriptions\n\n',(numel(manualEntries) - ct + 1))
            ct = numel(manualEntries) + 99; % break
        end
    end
    manualCategories{ct} = inputCategory;
    ct = ct + 1;
end

% Set NaN indices to zero
nanIndices = cellfun(@(x) isequaln(x, NaN), manualCategories);
manualCategories(nanIndices) = {0};

for i = 1:numel(manualEntries)
    if (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'foods', 'IgnoreCase', true))
        counts(1) = counts(1) + 1;
        dollars(1) = dollars(1) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'utilities', 'IgnoreCase', true))
        counts(2) = counts(2) + 1;
        dollars(2) = dollars(2) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'stores', 'IgnoreCase', true))
        counts(3) = counts(3) + 1;
        dollars(3) = dollars(3) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'phone', 'IgnoreCase', true))
        counts(4) = counts(4) + 1;
        dollars(4) = dollars(4) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'health', 'IgnoreCase', true))
        counts(5) = counts(5) + 1;
        dollars(5) = dollars(5) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'car', 'IgnoreCase', true))
        counts(6) = counts(6) + 1;
        dollars(6) = dollars(6) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'housing', 'IgnoreCase', true))
        counts(7) = counts(7) + 1;
        dollars(7) = dollars(7) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'subscriptions', 'IgnoreCase', true))
        counts(8) = counts(8) + 1;
        dollars(8) = dollars(8) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'payments', 'IgnoreCase', true))
        counts(9) = counts(9) + 1;
        dollars(9) = dollars(9) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'gas', 'IgnoreCase', true))
        counts(10) = counts(10) + 1;
        dollars(10) = dollars(10) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'income', 'IgnoreCase', true))
        counts(11) = counts(11) + 1;
        dollars(11) = dollars(11) + credit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'school', 'IgnoreCase', true))
        counts(12) = counts(12) + 1;
        dollars(12) = dollars(12) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'entertainment', 'IgnoreCase', true))
        counts(13) = counts(13) + 1;
        dollars(13) = dollars(13) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'services', 'IgnoreCase', true))
        counts(14) = counts(14) + 1;
        dollars(14) = dollars(14) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'investing', 'IgnoreCase', true))
        counts(15) = counts(15) + 1;
        dollars(15) = dollars(15) + debit(manualEntries(i));
    elseif (ischar(manualCategories{i})) && (contains(manualCategories{i}, 'other', 'IgnoreCase', true))
        counts(16) = counts(16) + 1;
        dollars(16) = dollars(16) + debit(manualEntries(i));
    end
end

%% Pie Chart Output

% Foods|Utilities|Stores|Phone|Health|Car|Housing|Subscriptions|Payments|Gas|Income|School|Entertainment|Services|Other
labels = {'Foods', 'Utilities', 'Stores', 'Phones', 'Health', 'Car', 'Housing', 'Subscriptions', 'Payment Platforms', 'Gas', 'Income', 'School', 'Entertainment','Services','Investing','Other'};

% Remove zero'd values
pielabels = labels(dollars > 0);
piedollars = dollars(dollars > 0);

% Pie Chart
figure
p = pie(piedollars, pielabels);
legendLabels = strcat(pielabels, {' ($'}, string(piedollars), {')'});
legend(p(1:2:end), legendLabels, 'Location', 'bestoutside', 'FontSize', 10);

title('Spending Distribution');
xlabel('Categories');
set(gca, 'FontSize', 12);

image = 'spending.png'; % Specify the filename and extension
saveas(gcf, image); % Save the current figure to the specified file

%% Count Display
% Temporary terminal count display

for i = 1:categories
    fprintf('Category: %-20s Purchases: %-5d Dollars: %-8.2f\n', labels{i}, counts(i), dollars(i));
end