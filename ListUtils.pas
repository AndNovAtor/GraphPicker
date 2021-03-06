Unit ListUtils;
interface
  type
    ListItem<TValue> = class
    public
      constructor Create(val: TValue);
    private
      prev, next: ListItem<TValue>;
      value: TValue;  
    end;
    
    Predicate<TValue> = interface
      function check(val:TValue):boolean;
    end;
    Iterator<TValue> = class
      public
        constructor create;
        constructor Create(initial: ListItem<TValue>);
        destructor  Destroy;
        procedure unSet;
        function hasNext : boolean;
        procedure moveNext;
        function Iterator<TValue>.nextIter:Iterator<TValue>;
        function getNext:TValue;
        function takeNext : TValue;
      private
        next: ListItem<TValue>;
    end;

    List<TValue> = class
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
        procedure change(iter:Iterator<TValue>;val:TValue);
        procedure remove(it:Iterator<TValue>);
        procedure removeAll(val:TValue);
        procedure removeAll(condition:Predicate<TValue>);
        procedure print;
        function find(condition:Predicate<TValue>;from:Iterator<TValue>):Iterator<TValue>;
        function find(condition:Predicate<TValue>):Iterator<TValue>;
        function find(val:TValue; from:Iterator<TValue>):Iterator<TValue>;
        function find(val:TValue):Iterator<TValue>;
      private
        head, tail: ListItem<TValue>;
        leng:word;   
    end;
implementation
  constructor ListItem<TValue>.Create(val: TValue);
    begin
      next:=nil;
      prev:=nil;
      value:=val;
    end;
  
  constructor Iterator<TValue>.create;
    begin
      next := nil;
    end;  
  constructor Iterator<TValue>.Create(initial: ListItem<Tvalue>);
    begin
      next := initial;
    end;
  destructor Iterator<TValue>.Destroy;
    begin
      next:=nil;
    end;
  procedure Iterator<TValue>.unSet;
    begin
      next:=nil;
    end;
  function Iterator<TValue>.hasNext : boolean;
    begin
      hasNext := next <> nil;
    end;
  procedure Iterator<TValue>.moveNext;
    begin
      next:=next.next;
    end;
  function Iterator<TValue>.nextIter:Iterator<TValue>;
    begin
      nextIter:=new Iterator<TValue>(next.next);
    end;
  function Iterator<TValue>.getNext:TValue;
    begin
      assert(next<>nil,'next=nil!');
      getNext:=next.value;
    end;
  function Iterator<TValue>.takeNext : TValue;
    begin
      Assert(hasNext, 'Iterator has no next item');
      takeNext := getNext;
      {prev := next;}
      moveNext;
    end;

  constructor List<TValue>.Create;
    begin
      leng:=0;
      head := nil;
      tail := nil;
    end;
  destructor List<TValue>.Destroy;
    {var iter:Iterator<TValue>;}
    begin
      // TODO: fix this function
      {if head<>nil then begin
        leng:=0;
        tail:=nil;
        while head<>nil do begin
          iter:=new Iterator<TValue>(head);
          head:=head^.next;
          iter.next^.next:=nil;
          iter.next^.prev:=nil;
          dispose(iter.next);
          Iter.Destroy;
        end;
      end;}
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
    var item:ListItem<TValue>;
    begin
      item := new ListItem<TValue>(val);
      Inc(leng);
      if isEmpty then begin
        item.prev:=nil;
        head:=item;
        tail:=item;
      end
      else begin
        tail.next:=item;
        item.prev:=tail;
        tail:=item;
      end;
    end;
  function List<TValue>.getBegin : Iterator<TValue>;
    begin
      getBegin := new Iterator<TValue>(head);
    end;
  function List<TValue>.getEnd : Iterator<TValue>;
    begin
      getEnd := new Iterator<TValue>(tail);
    end;
  function List<TValue>.get(ind: integer) : TValue;
    begin
      get:=getIterator(ind).getNext;
    end;
  function List<TValue>.getFromEnd(ind: integer) : TValue;
    var iterator:integer;
        point:ListItem<TValue>;
    begin
      assert(not isEmpty, 'List is emty');
      assert( ((ind>0) and (ind<=length)), 'The wrong index of list item. Index "'+inttostr(ind)+'" is outside the boundaries of the array');
      point:=tail;
      for iterator:=2 to ind do
        point:=point.next;
      getFromEnd:=point.value;
    end;
  function List<TValue>.getFirst : TValue;
    begin
      getFirst:=getBegin.takeNext;
    end;
  function List<TValue>.getLast : TValue;
    begin
      getLast:=getEnd.takeNext;
    end;
  function List<TValue>.getIterator(ind: integer) : Iterator<TValue>;
    var iter:Iterator<TValue>;
        i:word;
    begin
      assert( ((ind>0) and (ind<=length)), 'The wrong index of list item. Index "'+inttostr(ind)+'" is outside the boundaries of the array');
      iter:=new Iterator<TValue>(head);
      for i:=2 to ind do begin
        iter.moveNext;      
      end;
      getIterator:=iter; 
    end;
  procedure List<TValue>.change(iter:Iterator<TValue>;val:TValue);
    begin
      assert(iter.hasNext, 'Point to item of list is nil!');
      iter.next.value:=val;
    end;
  procedure List<TValue>.remove(it:Iterator<TValue>);
    var point:ListItem<TValue>;
    begin
      point:=it.next;
      Inc(leng,-1);
      if point=head then
        head:=head.next
      else
        point.prev.next:=point.next;
      if point=tail then
        tail:=tail.prev
      else
        point.next.prev:=point.prev;
      point.prev:=nil;
      point.next:=nil;
    end;
  function List<Tvalue>.find(condition:Predicate<TValue>;from:Iterator<TValue>):Iterator<TValue>;
    begin
      if (isEmpty) or (not from.hasNext) then find:=new Iterator<TValue>
      else if (not isEmpty) and (from.hasNext) then begin
        while from.hasNext do
          if condition.check(from.getNext) then break
          else from.moveNext;
        find:=from;
      end;
    end;
  function list<Tvalue>.find(condition:Predicate<TValue>):Iterator<TValue>;
    begin
      find:=find(condition,getBegin);
    end;
  function List<Tvalue>.find(val:TValue; from:Iterator<TValue>):Iterator<TValue>;
    begin
      if (isEmpty) or (not from.hasNext) then find:=new Iterator<TValue>
      else if (not isEmpty) and (from.hasNext) then begin
        while from.next<>nil do
          if val=from.getNext then break
          else from.moveNext;
        find:=from;
      end;
    end;
  function List<Tvalue>.find(val:TValue):Iterator<TValue>;
    begin  
      find:=find(val,getBegin);
    end;
  procedure List<TValue>.removeAll(val:TValue);
    var finditer,iter:iterator<TValue>;
    begin
      finditer:=find(val);
      while finditer.hasNext do begin
        iter:=find(val,finditer.nextIter);
        remove(finditer);
        finditer:=iter;
      end;
    end;
  procedure List<TValue>.removeAll(condition:Predicate<TValue>);
    var finditer,iter:iterator<TValue>;
    begin
      finditer:=find(condition);
      while finditer.hasNext do begin
        iter:=find(condition,finditer.nextIter);
        remove(finditer);
        finditer:=iter;
      end; 
    end;
  procedure List<TValue>.print;
    var it:Iterator<TValue>;
    begin
      it:=getBegin;
      while it.hasNext do
        write(it.takeNext,' ');
      writeln;
    end;
begin
end.