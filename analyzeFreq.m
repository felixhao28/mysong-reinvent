%% analyzeFreq: (frequency, CFreq) -> [expectedNote, outOfTuneScore]
function [expectedNote, outOfTuneScore] = analyzeFreq(freq, C)
  if C ~= 0 && freq ~= 0
    [actualNote, fixedNote] = fixNote(freq, C);
    noteNo = mod(fixedNote, 12);
    expectedNote = noteNo + 1;
    outOfTuneScore = (actualNote - fixedNote) * 100;
    % printf('%f -> %d (%d)\n', mod(actualNote, 12), noteNo, outOfTuneScore);
  else
    expectedNote = 0;
    outOfTuneScore = nan;
  end
end