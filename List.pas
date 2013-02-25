
type
  TValue = string[50];
  ListItems = ^ListItem;
  ListItem = record
    prev, next: ListItems;
    value: TValue;
  end;
  
  Iterator = class
  private
    next,prev: ListItems;
  public
    constructor Create(initial: ListItems);
    function Iterator.hasNext : boolean;
    function Iterator.hasPrev : boolean;
    function Iterator.getNext : TValue;
    function Iterator.getPrev : TValue;
  end;

constructor Iterator.Create(initial: ListItems);
  begin
    next := initial;
  end;

function Iterator.hasNext : boolean;
  begin
    hasNext := next <> nil;
  end;
function Iterator.hasPrev : boolean;
  begin
    hasPrev := prev <> nil;
  end;

function Iterator.getNext : TValue;
  begin
    Assert(hasNext, 'Iterator has no next item');
    getNext := next^.value;
    next := next^.next;
  end;
function Iterator.getPrev : TValue;
  begin
    Assert(hasPrev, 'Iterator has no prev item');
    getPrev := prev^.value;
    prev := prev^.prev;
  end;

type  
  List = class
  private
    head, tail: ListItems;
    leng:word;
    
  public
    constructor Create;
    function List.length:word;
    procedure List.push(val: TValue);
    function List.isEmpty : boolean;
    function List.get(ind: integer) : TValue;
    function List.getFromEnd(ind: integer) : TValue;
    function List.getFirst : TValue;
    function List.getLast : TValue;
    function List.getBegin : Iterator;
    function List.getEnd : Iterator;
    //function List.getIterator(ind: integer) : Iterator;
    //procedure List.remove(Iterator)
    //function List.find(v:TValue):Iterator
    //function List.find(cond:function(TValue):boolean):Iterator
    //function List.find(v:TValue, from: Iterator):Iterator
  end;
function List.getBegin : Iterator;
  begin
    getBegin := Iterator.Create(head);
  end;
function List.getEnd : Iterator;
  begin
    getEnd := Iterator.Create(tail);
  end;
function List.length:word;
  begin
    length:=leng;
  end;

constructor List.Create;
  begin
    leng:=0;
    head := nil;
    tail := nil;
  end;
function List.isEmpty : boolean;
  begin
    isEmpty:= head=nil;
  end;
procedure List.push(val: TValue);
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
function List.get(ind: integer) : TValue;
  var iterator:integer;
      point:ListItems;
  begin
    assert( ((ind>0) and (ind<=length)), 'The wrong index of list item. Index "'+inttostr(ind)+'" is outside the boundaries of the array');
    point:=head;
    for iterator:=2 to ind do
      point:=point^.next;
    get:=point^.value;
  end;
function List.getFromEnd(ind: integer) : TValue;
  var iterator:integer;
      point:ListItems;
  begin
    assert( ((ind>0) and (ind<=length)), 'The wrong index of list item. Index "'+inttostr(ind)+'" is outside the boundaries of the array');
    point:=tail;
    for iterator:=2 downto ind do
      point:=point^.next;
    getFromEnd:=point^.value;
  end;
function List.getFirst : TValue;
  begin
    getFirst:=getBegin.getNext;
  end;
function List.getLast : TValue;
  begin
    getLast:=getEnd.getNext;
  end;
var
  lst: List;
  val1, val2, v: TValue;
  it: Iterator;
begin
  // Test push
  lst := List.Create;
  Assert( lst.isEmpty, 'List not empty before push' );
  lst.push('abcd');
  lst.push('ab');
  Assert( not lst.isEmpty, 'List is empty after push' );
  writeln(lst.head^.next^.value);
  
  // Test get
  lst := List.Create;
  val1 := '123';
  val2 := 'bac';
  lst.push(val1);
  lst.push(val2);
  writeln( lst.length );
  Assert( lst.get(1) = val1, 'First item is wrong' );
  Assert( lst.get(2) = val2, 'Second item is wrong' );
  
  it := lst.getBegin;
  while it.hasNext do begin
    v := it.getNext;
    writeln( v );
  end;
end.