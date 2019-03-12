function success = RaiseIssue(handles, ex)
    if nargin < 2
        ex = handles.ME; 
    end
    
    opt = weboptions(...
        'Username', 'pkurockmagbot', ...
        'Password', 'ak5Dfp*6n>s', ...
        'ContentType', 'json', ...
        'HeaderFields', {'Accept' 'application/vnd.github.v3+json'}); 
    
    upload_success = false; 
    try
        filepath = handles.filename;
        text = fileread(handles.filename); 
        encodedtext = char(base64encode(gzipencode(text))); 
        url = 'https://api.github.com/repos/thomasberndt/FFT-FORC_issues/git/blobs'; 
        data = struct();
        data.content = encodedtext; 
        data.encoding = 'base64'; 
        S = webwrite(url, data, opt);
        sha = S.sha;
        if length(sha) > 10
            upload_success = true; 
        end
    catch
    end


    success = false;
    url = 'https://api.github.com/repos/thomasberndt/FFT-FORC_issues/issues'; 
    data = struct();
    data.title = ex.message;
    try 
        data.title = sprintf('%s - %s', data.title, handles.files{handles.n}); 
    catch
    end
    data.body = getReport(ex);
    try
        data.body = sprintf('%s\n\n%s', data.body, handles.filename);
    catch
    end
    if upload_success
        data.body = sprintf('%s\n\n%s', data.body, sha);
    end
    try
        S = webwrite(url, data, opt);
        success = true; 
    catch
    end
end