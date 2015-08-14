diary 'output.log'
diary on

chord_info = load_chords();
nChords = size(chord_info.chords,1);
% +1 start(i=nChords+1) and +1 end(i=nChords+2)
ctp = zeros(nChords + 2, nChords + 2);
map = zeros(nChords, 12);
listing = dir('mscx/*.mscx');
lastfile = '_1088.mscx';
begin = 1;
for file = listing'
    disp(file.name);
    if begin==0 && strcmp(file.name, lastfile)
        begin = 1;
        disp('start');
    end
    if begin
        try
            [ctp, map] = parseSheetMusic(file.name, chord_info, ctp, map);
        catch ME
            disp(ME);
        end
    end
end

diary off