
type
  //TValue = string[50];
  //Funtype = function(v:TValue):boolean;
  ListItems = ^ListItem;
  ListItem<TValue> = record
    prev, next: ListItems;
    value: TValue;
  end;
  
  Iterator<TValue> = class
  private
    next{,prev}: ListItems;
  public
    constructor Create(initial: ListItems);
    destructor  Destroy;
    function hasNext : boolean;
    //function Iterator.hasPrev : boolean;
    procedure moveNext;
    function getNext:TValue;
    function takeNext : TValue;
    //function Iterator.getPrev : TValue;
  end;

constructor Iterator<TValue>.Create(initial: ListItems);
  begin
    next := initial;
    {if initial<>nil then prev := initial^.prev
    else prev:=nil;}
  end;
destructor Iterator.Destroy;
  begin
    next:=nil;
  end;
function Iterator<TValue>.hasNext : boolean;
  begin
    hasNext := next <> nil;
  end;
{function Iterator.hasPrev : boolean;
  begin
    hasPrev := prev <> nil;
  end;}
procedure Iterator<TValue>.moveNext;
  begin
    next:=next^.next;
  end;
function Iterator<TValue>.getNext:TValue;
  begin
    getNext:=next^.value;
  end;
function Iterator<TValue>.takeNext : TValue;
  begin
    Assert(hasNext, 'Iterator has no next item');
    takeNext := getNext;
    {prev := next;}
    moveNext;
  end;
{function Iterator.getPrev : TValue;
  begin
    Assert(hasPrev, 'Iterator has no prev item');
    getPrev := prev^.value;
    next := prev;
    prev := prev^.prev;
  end;}

type  
  List<TValue> = class
  private
    head, tail: ListItems;
    leng:word;   
  public
    constructor Create;
    destructor Destroy;
    function length:word;
    function isEmpty : boolean;
    procedure push(val: TValue);
    function get(ind: integer) : TValue;
    function getFromEnd(ind: integer) : TValue;
    function getFirst : TValue;
    function getLast : TValue;
    function getBegin : Iterator<TValue>;
    function getEnd : Iterator<TValue>;
    function getIterator(ind: integer) : Iterator<TValue>;
    procedure remove(it:Iterator<TValue>);
    procedure print;
    //function List.find(v:TValue):Iterator<TValue>
    ///function List.find(cond:Funtype<TValue>):Iterator<TValue>;
    //function List.find(v:TValue, from: Iterator):Iterator<TValue>
  end;
constructor List<TValue>.Create;
  begin
    leng:=0;
    head := nil;
    tail := nil;
  end;
destructor List<TValue>.Destroy;
  var iter:iterator;
  begin
    if head<>nil then begin
      leng:=0;
      tail:=nil;
      while head<>nil do begin
        iter:=Iterator.create(head);
        head:=head^.next;
        iter.next^.next:=nil;
        iter.next^.prev:=nil;
        dispose(iter.next);
        Iter.Destroy;
      end;
    end;
  end;
function List<TValue>.length:word;
  begin
    length:=leng;
  end;
function List<TValue>.isEmpty : boolean;
  begin
    isEmpty:= head=nil;
  end;
procedure List<TValue>.push(val: TValue);
  var item:ListItems;
  begin
    new(item);
    Inc(leng);
    with item^ do begin
      next:=nil;
      value:=val;
    end;
    if isEmpty then begin
      item^.prev:=nil;
      head:=item;
      tail:=item;
    end
    else begin
      tail^.next:=item;
      item^.prev:=tail;
      tail:=item;
    end;
  end;
function List<TValue>.getBegin : Iterator;
  begin
    getBegin := Iterator.Create(head);
  end;
function List<TValue>.getEnd : Iterator;
  begin
    getEnd := Iterator.Create(tail);
  end;
function List<TValue>.get(ind: integer) : TValue;
  begin
    get:=getIterator(ind).getNext;
  end;
function List<TValue>.getFromEnd(ind: integer) : TValue;
  var iterator:integer;
      point:ListItems;
  begin
    assert(not isEmpty, 'List is emty');
    assert( ((ind>0) and (ind<=length)), 'The wrong index of list item. Index "'+inttostr(ind)+'" is outside the boundaries of the array');
    point:=tail;
    for iterator:=2 to ind do
      point:=point^.next;
    getFromEnd:=point^.value;
  end;
function List<TValue>.getFirst : TValue;
  begin
    getFirst:=getBegin.takeNext;
  end;
function List<TValue>.getLast : TValue;
  begin
    getLast:=getEnd.takeNext;
  end;
function List<TValue>.getIterator(ind: integer) : Iterator;
  var iter:Iterator;
      i:word;
  begin
    assert( ((ind>0) and (ind<=length)), 'The wrong index of list item. Index "'+inttostr(ind)+'" is outside the boundaries of the array');
    iter:=Iterator.Create(head);
    for i:=2 to ind do begin
      {iter.prev:=iter.next;}
      iter.moveNext;      
    end;
    getIterator:=iter; 
  end;
procedure List<TValue>.remove(it:Iterator);
  var point:ListItems;
  begin
    point:=it.next;
    Inc(leng,-1);
    
    if point=head then
      head:=head^.next
    else
      point^.prev^.next:=point^.next;
    if point=tail then
      tail:=tail^.prev
    else
      point^.next^.prev:=point^.prev;
    point^.prev:=nil;
    point^.next:=nil;
    dispose(point); 
  end;
procedure List<TValue>.print;
  var it:iterator;
  begin
    it:=getBegin;
    while it.hasNext do
      write(it.takeNext,' ');
    writeln;
  end;
{function List<TValue>.find(cond:Funtype):Iterator;
  var it:iterator;
      isfind:boolean;
  begin
    isfind:=false;
    it:=getBegin;
    while it.hasNext and not (isfind) do begin
      if cond(it.getNext) then begin
        isfind:=true;
        break;
      end;
      it.moveNext;
    end;
    if isfind then find:=it
    else find:=nil;
  end;}
var
  lst: List<TValue>;
  val1, val2, v: TValue;
  it: Iterator;
begin
  //Test Destroy
  writeln('Test Destroy');
  lst := List.Create;
  lst.push('abcd');
  writeln(lst.getBegin);
  it:=Iterator.Create;
  it.next:=lst.head;
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
  writeln(lst.head^.next^.value);
  
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