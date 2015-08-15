notesStrings = {'C'; 'C#'; 'D'; 'bE'; 'E'; 'F'; 'F#'; 'G'; 'G#'; 'A'; 'bB'; 'B'};
%             1   2   3  4   5  6  7   8   9    10 11  12
%             do  #do re #re mi fa #fa sol #sol la #la si
score      = [12, 1,  4, 1,  8, 4, 1,  8,  4,   8, 2,  4];
global stickScore;
stickScore = [5,  1,  5, 1,  5, 5, 2,  5,  3,   5, 2,  5];
nBins = 100;
stickScoreCont = zeros(1, 12 * nBins);
for i = 1 : 12 * nBins
   offset = mod(i, nBins) / nBins;
   actualNoteNo = i / nBins;
   ceilNoteNo = mod(ceil(actualNoteNo), 12);
   floorNoteNo = mod(floor(actualNoteNo), 12);
   weightCeil = stickScore(ceilNoteNo + 1);
   weightFloor = stickScore(floorNoteNo + 1);
   pivot = weightFloor / (weightFloor + weightCeil);
   if offset < pivot
      % round to floor
      fixedNoteNo = floorNoteNo;
      scoreMod = 1 - offset;
   else
      fixedNoteNo = ceilNoteNo;
      scoreMod = offset;
   end
   stickScoreCont(i) = score(fixedNoteNo + 1) * scoreMod;
end

% decide frequency of C
freqs = csvread('0000000001.f0');
% notes = CFreq * pow2(x/12)
f = freqs(freqs>0);
mean_notes = mean(f);
% notes = log2(CFreq) + x/12
f = log2(f);
% notes = log2(CFreq)*12 + x;
f = f * 12;
% notes = (log2(CFreq)*12) + x
% let G = log2(CFreq) * 12 % 12
% let noteNo = x % 12
% notes = G + noteNo
f = mod(f, 12);
% we need to find G
n = histc(f, 0:12/(12*nBins-1):12);
maxScore = 0;
for i=1:12*nBins
   tempScore = circshift(stickScoreCont, [0 i]) * n;
   if tempScore > maxScore
      maxScore = tempScore;
      G = i;
   end
end
G = G / nBins;

% log2(CFreq) * 12 = 12*level + G
% log2(CFreq) = level + G/12
% CFreq = pow2(level + G/12) = pow2(level) * pow2(G/12)
level = round(log2(mean_notes/pow2(G/12)));
CFreq = pow2(level) * pow2(G/12);

note_classes = zeros(2,length(freqs));
for freq_i=1:length(freqs)
    freq = freqs(freq_i);
    [noteNo, accScore] = analyzeFreq(freq, CFreq);
    note_classes(1,freq_i) = noteNo;
    note_classes(2,freq_i) = accScore;
end