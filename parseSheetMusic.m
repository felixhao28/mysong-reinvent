function [ctp, map] = parseSheetMusic(filename, chord_info, ctp, map)
    inv_dic = {'C', 'C#', 'D', 'Eb', 'E', 'F', 'F#', 'G', 'G#', 'A', 'Bb', 'B'};
    do_inv_dic = {'do', 'do#', 're', 'mib', 'mi', 'fa', 'fa#', 'sol', 'sol#', 'la', 'sib', 'si'};
    chord_names = {'C' 'C7' 'G' 'G7' 'Gm' 'F' 'Fm' 'Am' 'A' 'A7' 'Dm' 'D' 'Em' 'E'};
    nChords = size(chord_info.chords,1);
    xDoc = xmlread(filename);
    xRoot = xDoc.getDocumentElement;
    score = xml_select(xRoot, 'Score');
    if score~=0
        staffs = xml_select_all(score, 'Staff');
    else
        staffs = xml_select_all(xRoot, 'Staff');
    end
    if length(staffs) ~= 2
        disp('skip mono track');
        return;
    end
    a = xml_select_all(staffs{1}, 'Measure');
    b = xml_select_all(staffs{2}, 'Measure');
    meter = 1;
    len = min(length(a),length(b));
    a_keySig = 0;
    b_keySig = 0;

    previous_chord = nChords+1;
    for i=1:len
        fprintf('measure %d/%d\n',i,len);
        a_measure = a{i};
        b_measure = b{i};
        a_meter = getMeter(a_measure);
        b_meter = getMeter(b_measure);
        if a_meter && b_meter && a_meter~=b_meter
            print('skip');
            continue;
        end
        if a_meter
            meter = a_meter;
        end
        if b_meter
            meter = b_meter;
        end
        a_keySig_new = getKeySig(a_measure);
        if a_keySig_new >= 0
            a_keySig = a_keySig_new;
        end
        b_keySig_new = getKeySig(b_measure);
        if b_keySig_new >= 0
            b_keySig = b_keySig_new;
        end
        if mod(meter/2, 0.25) == 0
            n_parts = 2;
        else
            n_parts = 1;
        end
        a_info = measure_info(a_measure, n_parts, meter, a_keySig);
        b_info = measure_info(b_measure, n_parts, meter, b_keySig);
        % merge?
        if n_parts > 1
            merge = 0;
            if all(b_info(1,:) == b_info(2,:))
                merge = 1;
            end
            if merge == 0
                merged_b_info = b_info(1,:) + b_info(2,:);
                [gof, ~] = best_chord(chord_info, merged_b_info);
                if gof/meter > 0.4
                    merge = 1;
                end
            end
            if merge
                a_info = a_info(1,:) + a_info(2,:);
                b_info = b_info(1,:) + b_info(2,:);
            end
        end
        for part = 1:size(b_info,1)
            a_part = a_info(part,:);
            b_part = b_info(part,:);
            [gof, chord_i] = best_chord(chord_info, b_part);
            if gof > 0
                %fprintf(chord_names{chord_i});disp(do_inv_dic(b_part~=0));
                ctp(previous_chord, chord_i) = ctp(previous_chord, chord_i) + 1;
                map(chord_i, :) = map(chord_i, :) + a_part;
                previous_chord = chord_i;
            end
        end
    end
    chord_i = nChords+2;
    ctp(previous_chord, chord_i) = ctp(previous_chord, chord_i) + 1;
 end