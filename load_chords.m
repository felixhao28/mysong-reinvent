function info = load_chords()
    dic = Dictionary;
    dic('C') = 0;
    dic('D') = 2;
    dic('E') = 4;
    dic('F') = 5;
    dic('G') = 7;
    dic('A') = 9;
    dic('B') = 11;
    for i='CDEFGAB'
        dic(strcat(i, '#')) = mod(dic(i) + 1, 12);
        dic(strcat(i, 'b')) = mod(dic(i) - 1, 12);
    end
    chords_names = {'C' 'C7' 'G' 'G7' 'Gm' 'F' 'Fm' 'Am' 'A' 'A7' 'Dm' 'D' 'Em' 'E'};
    chords_order = [ 1   9    1   9    9    1   9    1    7   9    1    5   1    2 ];
    chords_str = {'C E G';
        'C E G Bb';
        'G B D';
        'G B D F';
        'G Bb D';
        'F A C';
        'F G# C';
        'A C E';
        'A C# E';
        'A C# F# E';
        'D F A';
        'D F# A';
        'E G B';
        'E G# B'
        };
    chords = zeros(length(chords_str), 12);
    for i=1:length(chords_str)
        chord = chords_str{i};
        notes = strsplit(chord, ' ');
        mainNote = notes{1};
        chords(i, dic(mainNote)+1) = 5;
        thirdNote = notes{2};
        chords(i, dic(thirdNote)+1) = 3;
        fifthNote = notes{3};
        chords(i, dic(fifthNote)+1) = 3;
        for j=4:length(notes)
            extra_note = notes{j};
            chords(i, dic(extra_note)+1) = 1;
        end
        chords(i, :) = chords(i, :) / sum(chords(i, :));
    end
    chords(chords==0) = chords(chords==0) - 1;
    info = struct('chords', chords, 'orders', chords_order, 'dic', dic);
end