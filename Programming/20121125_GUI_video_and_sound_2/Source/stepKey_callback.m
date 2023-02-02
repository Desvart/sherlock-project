function stepKey_callback(src, event)


    switch event.Key,

        case 'rightarrow', stepButton_callback([], [], '+');
        case 'leftarrow',  stepButton_callback([], [], '-');
        case 'return',      playButton_callback([], []);
        otherwise,         ;

    end


end