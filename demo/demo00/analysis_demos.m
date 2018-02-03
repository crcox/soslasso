%% Define a parameter file
% *WholeBrain_MVPA*, despite being written as a Matlab function, is a
% pretty atypical function.
%
% First of all, it does not return anything to the matlab environment. All
% results are written to disk. In addition, while it is possible to invoke
% *WholeBrain_MVPA* from within a script or at the interactive terminal, it
% is designed to take instructions from a json-formatted parameter filelook
% for a parameter file if no arguments are provided. This all makes
% *WholeBrain_MVPA* a bit counter-intuitive.
% 
% However, these design choices make
% much more sense when considered in a distributed computing environment.
% *WholeBrain_MVPA* can be deployed to a system, along with a json file
% containing parameters, and it will parse the file and execute according to
% the instructions. It is designed to be executed with bare minimum interaction.
%
% Defining a parameter file is simple. See the documentation for a list of
% valid parameters. *WholeBrain_MVPA* reads json (<http://www.json.org/>), which is
% a widely used text-based syntax for representing structured data.
%
% *The file must be named params.json!*
%
% I call this out in bold because it is important... but in practice, it
% isn't something you will need to think much about. Another bit of code,
% part of my <https://github.com/crcox/condortools CondorTools> repository,
% called *setupJobs*, will write you params.json files for you. But we are
% not quite there yet.
%
% To read and write json, you will need jsonlab
% (<http://www.mathworks.com/matlabcentral/fileexchange/33381-jsonlab--a-toolbox-to-encode-decode-json-files>)
% which is bundled with *WholeBrain_MVPA*.
%
% Put the parameter file where you want to run the analysis. Paths can be
% relative with respect to where you execute *WholeBrain_MVPA*, but in most
% cases it will probably make sense for them to be absolute. The following
% should translate into a valid json file for the purpose of the demo Lasso
% analysis that follows.

if ~exist('savejson','file')
    addpath(GetFullPath(fullfile(pwd,'..','..','dependencies','jsonlab')));
end
params = struct(...
    'regularization', 'lasso_glmnet', ...
    'bias', false, ...
    'alpha', 1,...
    'lambda', [], ...
    'cvscheme', 1, ...
    'cvholdout', 1:10, ...
    'finalholdout', 0, ...
    'target', 'faces',...
    'data', {{'./shared/s100.mat', './shared/s101.mat'}}, ...
    'data_var', 'X',...
    'normalize', 'zscore', ...
    'metadata', './shared/metadata.mat',...
    'metadata_var', 'metadata', ...
    'orientation', 'tlrc', ...
    'filters', {{'ROI01','GoodRows'}}, ...
    'SmallFootprint', false, ....
    'debug', false, ...
    'SaveResultsAs','mat', ...
    'subject_id_fmt','s%d.mat');

savejson('',params,'FileName','params.json','ForceRootName',false);

%% Run *WholeBrain_MVPA*: Lasso
% With data and metadata structured properly and saved to disk, and with a
% parameter file named params.json in a folder where you would like to execute
% the analysis and return results, all that remains is to boot up Matlab in the
% directory that contains 'params.json' and execute _WholeBrain_MVPA()_ at the
% command prompt. If you have compiled *WholeBrain_MVPA* into an executable (as
% would be necessary on a distributed computing cluster), you can execute
% *WholeBrain_MVPA* directly from the command line. In either case, it will read
% the parameter file and begin analysis. When it completes you will find a
% results.mat (or results.json) file in the directory where *WholeBrain_MVPA* was
% executed.
if ~exist('WholeBrain_MVPA','file')
    addpath(GetFullPath(fullfile(pwd,'..','..','src')));
end

WholeBrain_MVPA()

%% Run *WholeBrain_MVPA*: SOS Lasso
% Now, if we want to run SOS Lasso, all we need to do is add a couple more
% parameters, and change the regularization value.

if ~exist('WholeBrain_MVPA','file')
    addpath(GetFullPath(fullfile(pwd,'..','..','src')));
end
params = struct('regularization', 'soslasso', ...
    'bias', false, 'alpha', 0.8,...
    'lambda', 0.3, ...
    'shape', 'sphere', ...
    'diameter', 10, ...
    'overlap', 5, ...
    'cvscheme', 1, ...
    'cvholdout', 1:10, ...
    'finalholdout', 0, ...
    'target', 'faces',...
    'data', {{'./shared/s100.mat', './shared/s101.mat'}}, ...
    'data_var', 'X',...
    'normalize', 'zscore', ...
    'metadata', './shared/metadata.mat',...
    'metadata_var', 'metadata', ...
    'orientation', 'tlrc', ...
    'filters', {{'ROI01','GoodRows'}}, ...
    'SmallFootprint', false, ....
    'debug', false,...
    'SaveResultsAs','mat',...
    'subject_id_fmt','s%d.mat');

savejson('',params,'FileName','params.json','ForceRootName',false);
WholeBrain_MVPA()

%%  Run *WholeBrain_MVPA*: Searchlight
%  ===================================
% Put the parameter file where you want to run the analysis. Paths can be
% relative with respect to where you execute WholeBrain_MVPA, but in most cases
% it will probably make sense for them to be absolute. The following should
% translate into a valid json file for the purpose of this demo. 
if ~exist('WholeBrain_MVPA','file')
    addpath(GetFullPath(fullfile(pwd,'..','..','src')));
end
if ~exist('createMetaFromMask','file')
    addpath(GetFullPath(fullfile(pwd,'..','..','dependencies','Searchmight')));
end
if ~exist('coordsTo3dMask','file')
    addpath(GetFullPath(fullfile(pwd,'..','..','dependencies','mri_coordinate_tools')));
end
params = struct( ...
    'regularization', 'searchlight', ...
    'bias', false, ...
    'searchlight', false, ...
    'slclassifier', 'gnb_searchmight', ...
    'slradius', 5, ...
    'slTestToUse', 'accuracyOneSided_permutation', ...
    'slpermutations', 1000, ...
    'cvscheme', 1, ...
    'cvholdout', 1:10, ...
    'finalholdout', 0, ...
    'target', 'faces',...
    'data', './shared/s100.mat', ...
    'data_var', 'X',...
    'normalize', 'zscore', ...
    'metadata', './shared/metadata.mat',...
    'metadata_var', 'metadata', ...
    'orientation', 'tlrc', ...
    'filters', {{'ROI01','GoodRows'}}, ...
    'SmallFootprint', false, ....
    'debug', false,...
    'SaveResultsAs','mat',...
    'subject_id_fmt','s%d.mat');

savejson('',params,'FileName','params.json','ForceRootName',false);
WholeBrain_MVPA()

params.data = './shared/s101.mat';
savejson('',params,'FileName','params.json','ForceRootName',false);
WholeBrain_MVPA()

%% Compiling Results
% If you are using *WholeBrain_MVPA* on a distributed computing cluster, you will
% quickly find that the volume of results is difficult to manage effectively. I
% have written some utility functions in *WholeBrain_MVPA*/util that attempt to
% facilitate common actions, like loading data from many jobs into a single
% matlab structure, writing tables of data, dumping coordinates of identified
% voxels, etc.
% Alternatively, you may find that your volume of data demands a database
% solution. Although the default is to return data in .mat files, which makes
% it easy to read back into matlab, results can also be output in json format
% which facilitates storing in a SQL or NoSQL database like MongoDB. Setting up
% such a database solution is far beyond the scope of this demo, but the squall
% project (github.com/ikinsella/squall) is a developing solution that utilizes
% MongoDB to great effect.