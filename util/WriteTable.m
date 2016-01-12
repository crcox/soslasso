function WriteTable(filename,results,params,varargin)
  p = inputParser();
  addRequired(p, 'filename');
  addRequired(p, 'results');
  addRequired(p, 'params');
  addParameter(p, 'fields',{})
  addParameter(p, 'overwrite', false);
  parse(p, filename, results, params, varargin{:});

  filename  = p.Results.filename;
  results   = p.Results.results;
  params    = p.Results.params;
  fields    = p.Results.fields;
  OVERWRITE = p.Results.overwrite;

  if OVERWRITE
    fid = fopen(filename, 'w');
  else
    if exist(filename, 'file');
      error('%s already exists. To overwrite, use the set overwrite option to true.', filename);
    else
      fid = fopen(filename, 'w');
    end
  end

  % List all possible fields and their desired format code
  fieldFMT = struct( ...
    'iter'         , '%d'   , ...
    'finalholdout' , '%d'   , ...
    'cvholdout'    , '%d'   , ...
    'data'         , '%s'   , ...
    'target'       , '%s'   , ...
    'select'       , '%s'   , ...
    'subject'      , '%d'   , ...
    'Gtype'        , '%s'   , ...
    'lambda'       , '%.4f' , ...
    'lambda1'      , '%.4f' , ...
    'alpha'        , '%.4f' , ...
    'LambdaSeq'    , '%s'   , ...
    'tau'          , '%.4f' , ...
    'diff1'        , '%.4f' , ...
    'diff2'        , '%.4f' , ...
    'normalize'    , '%d'   , ...
    'dp1'          , '%.4f' , ...
    'dp2'          , '%.4f' , ...
    'p1'           , '%.4f' , ...
    'p2'           , '%.4f' , ...
    'cor1'         , '%.4f' , ...
    'cor2'         , '%.4f' , ...
    'err1'         , '%.4f' , ...
    'err2'         , '%.4f' , ...
    'h1'           , '%d' , ...
    'h2'           , '%d' , ...
    'f1'           , '%d' , ...
    'f2'           , '%d' , ...
    'nt1'          , '%d' , ...
    'nt2'          , '%d' , ...
    'nd1'          , '%d' , ...
    'nd2'          , '%d' , ...
    'Wnz'          , '%d' , ...
    'wnz'          , '%d' , ...
    'job'          , '%d' , ...
    'radius'       , '%d' , ...
    'diameter'     , '%.2f' , ...
    'overlap'      , '%.2f' , ...
    'pthr'         , '%.2f' , ...
    'shape'        , '%s' , ...
    'nz_rows'      , '%d');

  hdrFMT = strjoin(repmat({'%s'},1,length(fields)),',');
  tmp = cellfun(@(x) fieldFMT.(x), fields, 'unif', 0);
  dataFMT = strjoin(tmp,',');
  fprintf(fid,[hdrFMT,'\n'],fields{:});

  N = length(results);
  for i = 1:N
    R = results(i);
    if ~isempty(fieldnames(params))
        P = params(R.job);
    end
    out = cell(1,length(fields));
    for j = 1:length(fields);
      key = fields{j};
      if isfield(R,key)
        out{j} = R.(key);
      else
        disp(key)
        out{j} = full(P.(key));
      end
    end
    fprintf(fid,[dataFMT,'\n'], out{:});

  end
  fclose(fid);
end
