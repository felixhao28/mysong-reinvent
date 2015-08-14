function keysig = getKeySig(measure)
    key = xml_select(measure, 'KeySig');
    if key~=0
        accidental = xml_select(key, 'accidental');
        if accidental~=0
            acc = str2double(accidental.getTextContent);
        else
            accidental = xml_select(key, 'subtype');
            if accidental~=0
                acc = accidental.getTextContent;
                acc = str2double(acc);
                acc = mod(acc, 16);
            else
                keysig = -1;
                return;
            end
        end
        keysig = translateTPC(acc + 14) - 1;
    else
        keysig = -1;
    end
end