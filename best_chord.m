function [ gof, chord_i ] = best_chord(chord_info, part )
    chords = chord_info.chords;
    chords_order = chord_info.orders;
    chord_gof = chords * part';
    gof = 0;
    chord_i = 1;
    for i=1:length(chord_gof)
        this_gof = chord_gof(i);
        if this_gof > gof || (this_gof == gof && chords_order(i) < chords_order(chord_i))
            gof = this_gof;
            chord_i = i;
        end
    end
end

