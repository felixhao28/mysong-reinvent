function meter = getMeter(measure)
    timeSig = xml_select(measure, 'TimeSig');
    if timeSig~=0
        sigN = xml_select(timeSig, 'sigN');
        if sigN~=0
            sigN = str2double(sigN.getTextContent);
            sigD = xml_select(timeSig, 'sigN');
            sigD = str2double(sigD.getTextContent);
        else
            sigN = xml_select(timeSig, 'nom1');
            sigN = str2double(sigN.getTextContent);
            sigD = xml_select(timeSig, 'den');
            sigD = str2double(sigD.getTextContent);
        end
        meter = sigN/sigD;
    else
        meter = 0;
    end
end