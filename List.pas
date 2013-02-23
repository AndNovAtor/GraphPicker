
type
   TValue = string[50];
   ListElem = record
    prev, next: ^ListElem;
    value: TValue;
  end;

  List = class
    head, tail: ^ListElem;
    
    constructor Create;
    //procedure List.push(val: TValue);
    function List.isEmpty : boolean;
    //function List.get(ind: integer) : TValue;
  end;
  
  constructor List.Create;
    begin
      head := nil;
      tail := nil;
    end;
  function List.isEmpty : boolean;
    begin
      isEmpty:= head=nil;
    end;
var
  lst: List;
  val1, val2: TValue;
begin
  // Test push
  lst := List.Create;
  //lst.push('abcd');
  Assert( not lst.isEmpty, 'List is empty after push' );
  
  // Test get
//  lst := List.Create;
//  val1 := '123';
//  val2 := 'bac';
//  lst.push(val1);
//  lst.push(val2);
//  Assert( lst.get(1) = val1, 'First item is wrong' );
//  Assert( lst.get(2) = val1, 'Secnd item is wrong' );
end.