function info = measure_info( measure, n_divisions, meter, keySig )
    info = zeros(n_divisions,12);
    c = measure.getChildNodes;
    position = zeros(1,10);
    divistion_len = meter/n_divisions;
    for i=0:c.getLength-1
        n = c.item(i);
        if n.getNodeType==1
            if strcmp(n.getTagName, 'Rest')
                duration = getDuration(n, meter);
                track = getTrack(n);
                if track>0
                    position(track) = position(track) + duration;
                end
            elseif strcmp(n.getTagName, 'Chord')
                duration = getDuration(n, meter);
                track = getTrack(n);
                if track>0
                    notes = xml_select_all(n, 'Note');
                    for k=1:length(notes)
                        note = notes{k};
                        tpc = xml_select(note, 'tpc');
                        tpc = str2double(tpc.getTextContent);
                        pitch_class = translateTPC(tpc);
                        pitch_class = mod((pitch_class - 1) - keySig + 12, 12) + 1;
                        sectionId = floor(position(track) / divistion_len)+1;
                        if sectionId > n_divisions
                            % error in the sheet but we respect
                            sectionId = n_divisions;
                        end
                        info(sectionId, pitch_class) = info(sectionId, pitch_class) + duration;
                    end
                    position(track) = position(track) + duration;
                end
            end
        end
    end
end

function duration = getDuration(node, meter)
    durationType = xml_select(node, 'durationType');
    durationType = durationType.getTextContent;
    if strcmp(durationType, 'eighth')
        duration = 0.125;
    elseif strcmp(durationType, 'quarter')
        duration = 0.25;
    elseif strcmp(durationType, 'half')
        duration = 0.5;
    elseif strcmp(durationType, 'measure')
        duration = meter;
    elseif strcmp(durationType, 'whole')
        duration = 1;
    elseif strcmp(durationType, '16th')
        duration = 1/16;
    elseif strcmp(durationType, '32nd')
        duration = 1/32;
    elseif strcmp(durationType, '64th')
        duration = 1/64;
    elseif strcmp(durationType, '128th')
        duration = 1/128;
    else
        disp('undefined durationType');
    end
end

function track = getTrack(node)
    track=0;
    move = xml_select(node, 'move');
    if move~=0
        move = move.getTextContent;
        move = str2double(move);
        if move==-1
            track = -1;
        end
    end
    if track ~=-1
        track = xml_select(node, 'track');
        if track~=0
            track = track.getTextContent;
            track = str2double(track);
        end
        track = track + 1;
    end
end
