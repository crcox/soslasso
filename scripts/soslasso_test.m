if exist('TESTENV', 'var')
  if ~strcmp(TESTENV,{'lab','home'})
    error('TESTENV must be set to either "lab" or "home".');
  end
else
  error('TESTENV is unset. Set to either "lab" or "home"');
end

switch TESTENV
  case 'home'
    datadir = 'C:\Users\chris\Documents\FacePlaceObject\TR5';
    scriptdir = 'C:\Users\chris\Documents\soslasso\scripts';
  case 'lab'
    datadir = '~/data/FacePlaceObject/data/mat/handmade/TR5';
    scriptdir = '~/src/soslasso/scripts';
end

WholeBrain_MVPA( ...
  'debug', false, ...
  'Gtype' , 'soslasso', ...
  'filters',{'rowfilter','colfilter'},'target', 'TrueFaces',...
  'data', ...
    {fullfile(datadir,'jlp01.mat'),...
     fullfile(datadir,'jlp02.mat'),...
     fullfile(datadir,'jlp03.mat'),...
     fullfile(datadir,'jlp04.mat'),...
     fullfile(datadir,'jlp05.mat'),...
     fullfile(datadir,'jlp06.mat'),...
     fullfile(datadir,'jlp07.mat'),...
     fullfile(datadir,'jlp08.mat'),...
     fullfile(datadir,'jlp09.mat'),...
     fullfile(datadir,'jlp10.mat')},...
  'metadata', fullfile(datadir,'metadata_TR5.mat'),...
  'cvfile', fullfile(datadir,'CV_schemes_TR5.mat'),...
  'cvscheme', 1, 'cvholdout', [2,3,4,5,6,7,8,9,10], 'finalholdout', 1, ...
  'lambda', 1, 'alpha', 0.5, ...
  'environment', 'chris','orientation','tlrc', ...
  'diameter', 18, 'overlap', 9, 'shape', 'sphere',...
  'normalize','zscore','bias',0)
