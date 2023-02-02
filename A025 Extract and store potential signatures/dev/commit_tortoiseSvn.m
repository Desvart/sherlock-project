function commit_tortoiseSvn(fileFPath)

    dateStr = datestr(now, 'yyyy.mm.dd - HH:MM:SS.FFF');
    svnRequest = ['!TortoiseProc.exe /command:commit ', ...
                  '/path:"', fileFPath, '" ', ...
                  '/logmsg:"Compilation : ', dateStr, '" ', ...
                  '/closeonend:0'];
    eval(svnRequest);

end
