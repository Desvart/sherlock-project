% CREATE TEMPLATES
%
%


%% Load digit templates

templateArrayImage  = imread('.\digit_template_10_11_8_2.tif');
nTemplates          = 10;
templateImageWidth  = 8;
templateImageHeight = 11;
templateImageBorder = 2;

%% Split template

templateImageLastXIdx = 0;
templateImageLastYIdx = 0;
digitImageCellArray = cell(1, nTemplates);

for iDigit = 1 : nTemplates,
    templateImageFirstXIdx = 1 + templateImageBorder + templateImageLastXIdx;
    templateImageLastXIdx  = templateImageFirstXIdx + templateImageWidth - 1;
    templateImageFirstYIdx = 1 + templateImageBorder;
    templateImageLastYIdx  = templateImageFirstYIdx + templateImageHeight - 1;
    digitImageCellArray{iDigit} = templateArrayImage(templateImageFirstYIdx:templateImageLastYIdx, ...
                                                    templateImageFirstXIdx:templateImageLastXIdx);
end


% character = [one, two, three, four, five, six, seven, eight, nine, zero];



%% Store templates in a cell matrix

% [templateHeight, templateWidth] = size(zero);
% nTemplates     = length(character)/templateWidth;
% templateArray  = mat2cell(character, templateHeight, templateWidth(ones(1, nTemplates)));



%% Save templates in matfile

% Add template size

save ('digitTemplates_2.mat', 'digitImageCellArray');

% eof
