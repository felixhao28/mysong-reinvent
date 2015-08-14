function [ nodeList ] = xml_select( node, tagname )
    c = node.getChildNodes;
    for i=0:c.getLength-1
        n = c.item(i);
        if n.getNodeType==1 && strcmp(n.getTagName, tagname)
            nodeList = n;
            return
        end
    end
    nodeList = 0;
end

