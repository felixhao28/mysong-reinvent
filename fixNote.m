%% functions
%% fixNote: try fix a note
function [actualNote, fixedNote] = fixNote(freq, C)
  global stickScore;
  ratio = freq / C;
  actualNote = 12 * log2(ratio);
  ceilNote = ceil(actualNote);
  floorNote = floor(actualNote);
  ceilNoteNo = mod(ceilNote, 12);
  floorNoteNo = mod(floorNote, 12);
  weightCeil = stickScore(ceilNoteNo + 1);
  weightFloor = stickScore(floorNoteNo + 1);
  pivot = weightFloor / (weightFloor + weightCeil);
  offset = actualNote - floorNote;
  if offset < pivot
    % round to floor
    fixedNote = floorNote;
  else
    fixedNote = ceilNote;
  end
end

