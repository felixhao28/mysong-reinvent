function [ nodeList ] = xml_select_all( node, tagname )
    nodeList = {};
    index = 1;
    c = node.getChildNodes;
    for i=0:c.getLength-1
        n = c.item(i);
        if n.getNodeType==1 && strcmp(n.getTagName, tagname)
            nodeList{index} = n;
            index = index + 1;
        end
    end
end

