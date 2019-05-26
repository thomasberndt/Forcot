function DecodeForc(sha)
    opt = weboptions(...
        'Username', 'pkurockmagbot', ...
        'Password', 'ak5Dfp*6n>s', ...
        'ContentType', 'json', ...
        'HeaderFields', {'Accept' 'application/vnd.github.v3+json'}, ...
        'Timeout', 30); 
    
    url = 'https://api.github.com/repos/thomasberndt/FFT-FORC_issues/git/blobs'; 
    url2 = sprintf('%s/%s', url, sha); 
    S = webread(url2, opt); 
    content = base64decode(S.content); 
    unzipped = gzipdecode(content); 
    filepath = sprintf('../issues/%s.frc', sha); 
    fileID = fopen(filepath,'w');
    fwrite(fileID, unzipped); 
    fclose(fileID); 
end

