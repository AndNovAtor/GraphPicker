
type
  TValue = string[50];
  ListItems = ^ListItem;
  ListItem = record
    prev, next: ListItems;
    value: TValue;
  end;

  List = class
    head, tail: ListItems;
    length:word;
    
    constructor Create;
    procedure List.push(val: TValue);
    function List.isEmpty : boolean;
    function List.get(ind: integer) : TValue;
    function List.getEnd(ind: integer) : TValue;
    function List.getFirst : TValue;
    function List.getLast : TValue;
  end;
  
constructor List.Create;
  begin
    length:=0;
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
    Inc(length);
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
function List.getEnd(ind: integer) : TValue;
  var iterator:integer;
      point:ListItems;
  begin
    assert( ((ind>0) and (ind<=length)), 'The wrong index of list item. Index "'+inttostr(ind)+'" is outside the boundaries of the array');
    point:=tail;
    for iterator:=2 downto ind do
      point:=point^.next;
    getEnd:=point^.value;
  end;
function List.getFirst : TValue;
  begin
  end;
function List.getLast : TValue;
  begin
  end;
var
  lst: List;
  val1, val2: TValue;
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
end.