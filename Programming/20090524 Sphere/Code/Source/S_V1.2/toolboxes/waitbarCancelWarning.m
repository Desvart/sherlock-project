function waitbarCancelWarning(crossId, nbCrossvalidation)
    beep;
	disp(['WARNING : Sound recognition process has been stopped at iteration ', ...
              int2str(crossId), '/' int2str(nbCrossvalidation), '.']);
end
