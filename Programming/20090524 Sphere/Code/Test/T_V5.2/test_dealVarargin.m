function test(varargin)
    
    defaultValues = {100,72}; 
    nonemptyIdx = ~cellfun('isempty',varargin); 
    defaultValues(nonemptyIdx) = varargin(nonemptyIdx); 
    [a b] = deal(defaultValues{:});
    
    disp(a);disp(b);
    
    test2(varargin);

end

function test2(varargin)
    defaultValues = {100,72}; 
    nonemptyIdx = ~cellfun('isempty',varargin{1}); 
    defaultValues(nonemptyIdx) = varargin{1}(nonemptyIdx); 
    [a b] = deal(defaultValues{:});
    
    disp(a);disp(b);
end