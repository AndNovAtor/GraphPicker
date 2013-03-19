Uses ListObj;
var
  lst: List;
  val1, val2, v: TValue;
  it: Iterator;
begin
  //Test Destroy
  writeln('Test Destroy');
  lst := List.Create;
  lst.push('abcd');
  it:=lst.getBegin;
  lst.push('abcd');
  lst.Destroy;
  it.Destroy;
  // Test push
  writeln('Test push');
  lst := List.Create;
  Assert( lst.isEmpty, 'List not empty before push' );
  lst.push('abcd');
  lst.push('ab');
  Assert( not lst.isEmpty, 'List is empty after push' );
  
  // Test get
  writeln('Test get');
  lst := List.Create;
  val1 := '123';
  val2 := 'bac';
  lst.push(val1);
  lst.push(val2);
  writeln( lst.length );
  Assert( lst.get(1) = val1, 'First item is wrong' );
  Assert( lst.get(2) = val2, 'Second item is wrong' );
  //Test hasNext
  writeln('Test hasNext');
  it := lst.getBegin;
  while it.hasNext do begin
    v := it.takeNext;
    writeln( v );
  end;
  //Test get-,take-,move Next
  writeln('Test get-,take-,move Next');
  lst.Destroy;
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
  writeln('Test remove');
  lst.Destroy;
  lst.push('1');
  lst.push('2');
  lst.push('3');
  lst.push('4');
  lst.push('5');
  lst.push('6');
  writeln(lst.getBegin.next^.value);
  lst.remove(lst.getBegin);
  lst.remove(lst.getEnd);
  lst.remove(lst.getIterator(4));
  lst.print;
end.