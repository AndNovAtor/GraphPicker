uses ListUtils;
type
  TValue = integer;
  NowPred = class (Predicate<TValue>)
    public
      function check(val:TValue):boolean;
  end;
function NowPred.check(val:TValue):boolean;
  begin
    check:= val=7;
  end;
var iter:iterator<TValue>;
    lst:list<TValue>;
    con:NowPred;
begin
  lst:= new list<TValue>;
  lst.push(12);
  lst.push(244);
  lst.push(243);
  lst.push(1);
  lst.push(7);
  lst.push(1);
  lst.print;
  con:=new NowPred;
  lst.remove(lst.find(con));
  lst.print;
  lst.push(7);
  lst.remove(lst.find(1));
  lst.print;
end.
  