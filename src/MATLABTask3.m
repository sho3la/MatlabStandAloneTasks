function[matchedImg, Score] = MATLABTask3(test,t1,t2,t3,t4)
    [pp1, hole1] = GetPeaks(t1);
    [pp2, hole2] = GetPeaks(t2);
    [pp3, hole3] = GetPeaks(t3);
    [pp4, hole4] = GetPeaks(t4);
    
    [ppout, hole5] = GetPeaks(test);
    
    pp1 = pp1 / max(pp1);
    pp2 = pp2 / max(pp2);
    pp3 = pp3 / max(pp3);
    pp4 = pp4 / max(pp4);
    ppout = ppout / max(ppout);
    
    p1 = 0; p2 = 0; p3 =0; p4=0;
    for i = 1:length(ppout)
        p1 = p1+abs(pp1(i)-ppout(i));
        p2 = p2+abs(pp2(i)-ppout(i));
        p3 = p3+abs(pp3(i)-ppout(i));
        p4 = p4+abs(pp4(i)-ppout(i));
    end    
    
    Score = [p1 p2 p3 p4];
    mini = min(Score);
    
    
    if (hole5 == 0)
    
        if(mini == p1)
            matchedImg = t1;
        elseif (mini == p2)
            matchedImg = t2;
        elseif(mini == p3)
            matchedImg = t3;
        elseif(mini == p4)
            matchedImg = t4;
        end

        Score = [hole1 hole2 hole3 hole4 hole5];
    else
        matchedImg = t4;
        Score(4) = 0;
        Score = [hole1 hole2 hole3 hole4 hole5];
    end
end