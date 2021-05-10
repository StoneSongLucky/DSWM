function showSeiData(seiData,title, first, last)

if nargin < 2
    title = '';
end

warning off;
if nargin < 4
    s_wplot(s_convert(seiData',0,1),{'title',title},{'quality','high'},{'deflection',1.25});
else
    s_wplot(s_convert(seiData',0,1),{'title',title},{'quality','high'},{'times',first,last});
end

end

