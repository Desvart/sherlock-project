function h = waitbarCreation(nbCrossvalidation)

    h = waitbar(0, ['Iteration : 1/', int2str(nbCrossvalidation)], ...
            'Name', 'Progression');
    
    
%     h = waitbar(0, ['Iteration : 1/', int2str(nbCrossvalidation)], ...
%             'Name', 'Progression',...
%             'CreateCancelBtn', 'setappdata(gcbf, ''canceling'', 1)');
%     setappdata(h, 'canceling', 0);

end
