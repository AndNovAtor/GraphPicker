Unit ListObj;
interface
  type
    TValue = string[50];
    Funtype = function(v:TValue):boolean;
    ListItems = ^ListItem;
    ListItem = record
      prev, next: ListItems;
      value: TValue;
    end;
    
    Iterator = class
      public
        constructor Create(initial: ListItems);
        destructor  Destroy;
        function hasNext : boolean;
        //function Iterator.hasPrev : boolean;
        procedure moveNext;
        function getNext:TValue;
        function takeNext : TValue;
        //function Iterator.getPrev : TValue;
      private
        next{,prev}: ListItems;
    end;

    List = class
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
        function getBegin : Iterator;
        function getEnd : Iterator;
        function getIterator(ind: integer) : Iterator;
        procedure remove(it:Iterator);
        procedure print;
        //function List.find(v:TValue):Iterator
        function List.find(cond:Funtype):Iterator;
        //function List.find(v:TValue, from: Iterator):Iterator
      private
        head, tail: ListItems;
        leng:word;   
    end;
implementation
  constructor Iterator.Create(initial: ListItems);
    begin
      next := initial;
      {if initial<>nil then prev := initial^.prev
      else prev:=nil;}
    end;
  destructor Iterator.Destroy;
    begin
      next:=nil;
    end;
  function Iterator.hasNext : boolean;
    begin
      hasNext := next <> nil;
    end;
  {function Iterator.hasPrev : boolean;
    begin
      hasPrev := prev <> nil;
    end;}
  procedure Iterator.moveNext;
    begin
      next:=next^.next;
    end;
  function Iterator.getNext:TValue;
    begin
      getNext:=next^.value;
    end;
  function Iterator.takeNext : TValue;
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
  
  constructor List.Create;
    begin
      leng:=0;
      head := nil;
      tail := nil;
    end;
  destructor List.Destroy;
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
  function List.length:word;
    begin
      length:=leng;
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
  function List.getBegin : Iterator;
    begin
      getBegin := Iterator.Create(head);
    end;
  function List.getEnd : Iterator;
    begin
      getEnd := Iterator.Create(tail);
    end;
  function List.get(ind: integer) : TValue;
    begin
      get:=getIterator(ind).getNext;
    end;
  function List.getFromEnd(ind: integer) : TValue;
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
  function List.getFirst : TValue;
    begin
      getFirst:=getBegin.takeNext;
    end;
  function List.getLast : TValue;
    begin
      getLast:=getEnd.takeNext;
    end;
  function List.getIterator(ind: integer) : Iterator;
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
  procedure List.remove(it:Iterator);
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
  procedure List.print;
    var it:iterator;
    begin
      it:=getBegin;
      while it.hasNext do
        write(it.takeNext,' ');
      writeln;
    end;
  function List.find(cond:Funtype):Iterator;
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
    end;
begin
end.