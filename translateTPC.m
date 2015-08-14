% C..B => 0..11
function pitch_class = translateTPC(tpc)
    tpcMap = [3, 10, 5, 0, 7, 2, 9];
    yy = mod(tpc+1,7);
    xx = floor((tpc+1)/7);
    pitch_class = mod(xx+tpcMap(yy + 1),12) + 1;
end