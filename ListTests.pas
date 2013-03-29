Uses ListUtils;
procedure AssertEq(expected,actual: string;what:string);
  begin
    assert(expected=actual,'Incorrect '+what+' "'+actual.ToString+'" got, but "'+expected.ToString+'" expected');
    writeln(String.Format('{0,-17}', what+' = '+expected.ToString),' -  OK');
  end;
var
  lst: List<string>;
  val1, val2, v: string;
  it: Iterator<string>;
begin
  {//Test Destroy
  writeln('Test Destroy');
  lst := new List<string>;
  lst.push('abcd');
  it:=lst.getBegin;
  lst.push('abcd');
  lst := new List<string>;;
  it.Destroy;}
  
  // Test push
  writeln('----Test push');
  lst := new List<string>;
  Assert( lst.isEmpty, 'List not empty before push' );
  writeln('lst.isEmpty       -  OK');
  lst.push('abcd');
  lst.push('ab');
  Assert( not lst.isEmpty, 'List is empty after push' );
  writeln('not lst.isEmpty   -  OK');
  
  // Test get
  writeln('----Test get');
  lst := new List<string>;
  val1 := '123';
  val2 := 'bac';
  lst.push(val1);
  lst.push(val2);
  Assert(lst.length=2, 'Incorrect length of list: "'+inttostr(lst.length)+'"get but "2" expected');
  writeln('lst.length=2      -  OK');
  Assert( lst.get(1) = val1, 'First item is "'+lst.get(1)+'" but "'+val1+'" expected');
  //AssertEq( expected, actual: string );
  Assert( lst.get(2) = val2, 'Second item is wrong' );
  writeln('lst.get(2)=val2   -  OK');
  
  //Test hasNext
  writeln('----Test hasNext');
  it := lst.getBegin;
  while it.hasNext do begin
    v := it.takeNext;
    writeln( v );
  end;
  
  //Test get-,take-,move Next
  writeln('----Test get-,take-,move Next');
  lst := new List<string>;;
  lst.push('1');
  lst.push('2');
  lst.push('3');
  lst.push('4');
  lst.push('5');
  lst.push('6');
  it:=lst.getIterator(2);
  writeln(it.getNext);
  it.moveNext;
  it.moveNext;
  writeln(it.getNext);
  writeln(it.takeNext);
  writeln(it.getNext);
  
  //Test remove
  writeln('----Test remove');
  lst := new List<string>;
  lst.push('1');
  lst.push('2');
  lst.push('3');
  lst.push('4');
  lst.push('5');
  lst.push('6');
  lst.remove(lst.getBegin);
  AssertEq('2',lst.getFirst,'first item');
  lst.remove(lst.getEnd);
  AssertEq('5',lst.getLast,'last item');
  lst.remove(lst.getIterator(4));
  AssertEq('4',lst.getLast,'last item');
  lst.print;
  
  //Test change
  writeln('----Test change');
  lst := new List<string>;
  lst.push('1');
  lst.push('2');
  lst.push('3');
  lst.change(lst.getIterator(3),'4');
  AssertEq('4',lst.getLast,'last item');
end.