%EglyDriverIES

ntrials = 50
slist = table
slist.TTL = repmat([repmat([255 255 225 8 255], 5, 1); repmat([255 255 225 255 255], 5, 1)], 5, 1)
slist.cue_target_interval = randsample([500:1200], ntrials)'

for i = 1:size(slist,1)
    slist.stim_time(i) = randsample([100:(slist.cue_target_interval(i) -300)], 1)';
end


randsample([100:500 -300], 1)