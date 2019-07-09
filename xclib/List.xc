// File author is Ítalo Lima Marconato Matias
//
// Created on July 05 of 2019, at 15:41 BRT
// Last edited on July 08 of 2019, at 13:26 BRT

class ListItem {
	public var Data : Any, Next : ListItem, Prev : ListItem;						// This is a linked list, so we need pointers to the next item and to the previous one
	
	method ListItem(data : Any, next : ListItem, prev : ListItem) {
		Data = data;
		Next = next;
		Prev = prev;
	}
}

class List {
	private var head : ListItem = null, length = 0;									// The initial length is 0
	
	public method Add(data : Any) {
		AddToEnd(data);																// The default Add function redirects to AddToEnd (it will add the item to the end of the list)
	}
	
	public method AddList(list : List) {
		if (list != null) {															// Null pointer check
			for (var i = 0; i < list.GetLength(); i++) {							// Let's add everything from this list
				Add(list.Get(i));
			}
		}
	}
	
	public method AddToStart(data : Any) {
		head = new ListItem(data, head, null);										// Just create a new head with the field 'Next' pointing to the old head
		length++;																	// And increase the length
	}
	
	public method AddToEnd(data : Any) {
		if (head == null) {															// First item?
			head = new ListItem(data, null, null);									// Yes, create the head and return
			length++;																// And increase the length
			return;
		}
		
		var cur : ListItem = head;													// No, so we need to find the last item
		
		for (; cur.Next != null; cur = cur.Next) ;
		
		cur.Next = new ListItem(data, null, cur);									// Create the new item
		length++;																	// And increase the length
	}
	
	public method AddAt(idx, data : Any) : Int8 {
		if (idx == 0) {																// Add to the start?
			AddToStart(data);														// Yes, just redirect to AddToStart
			return 1;
		}
		
		var cur : ListItem = GoToIndex(idx);										// Try to get whatever item is in the 'idx' position
		
		if (cur == null) {
			return 0;																// No item here, just return false (0)
		}
		
		cur.Prev = new ListItem(data, cur, cur.Prev);								// Create the new item
		length++;																	// And increase the length
		
		return 1;
	}
	
	public method AddAfter(value : Any, data : Any) {
		var cur : ListItem = GoToItem(value);										// Try to find the item where the field 'Data' is 'value'
		
		if (cur == null) {
			AddToEnd(data);															// It doesn't exists, so let's add it to the end
			return;
		}
		
		cur.Next = new ListItem(data, cur.Next, cur);								// Create the new item
		length++;																	// And increase the length
	}
	
	public method AddBefore(value : Any, data : Any) {
		var cur : ListItem = GoToItem(value);										// Try to find the item where the field 'Data' is 'value'
		
		if (cur == null) {
			AddToEnd(data);															// It doesn't exists, so let's add it to the end
			return;
		}
		
		cur.Prev = new ListItem(data, cur, cur.Prev);								// Create the new item
		length++;																	// And increase the length
	}
	
	public method Remove(data : Any) {
		var cur : ListItem = GoToItem(data);										// Try to find the item where the field 'Data' is 'value'
		
		if (cur != null) {
			if (cur.Prev == null) {													// Found! Does it have the 'Prev' field?
				head = cur.Next;													// No, so it's the head, let's set it to the new first item
			} else {
				cur.Prev.Next = cur.Next;											// Yes!
			}
			
			if (cur.Next != null) {													// Does it have the 'Next' field?
				cur.Next.Prev = cur.Prev;											// Yes :)
			}
			
			length--;																// And decrease the length
		}
	}
	
	public method RemoveAt(idx) : Any {
		var cur : ListItem = GoToIndex(idx);										// Try to get whatever item is in the 'idx' position
		
		if (cur != null) {
			if (cur.Prev == null) {													// Found! Does it have the 'Prev' field?
				head = cur.Next;													// No, so it's the head, let's set it to the new first item
			} else {
				cur.Prev.Next = cur.Next;											// Yes!
			}
			
			if (cur.Next != null) {													// Does it have the 'Next' field?
				cur.Next.Prev = cur.Prev;											// Yes :)
			}
			
			length--;																// Decrease the length
			
			return cur.Data;														// And return the item's data
		}
		
		return null;																// Not found, so let's return null :(
	}
	
	public method Contains(value : Any) : Int8 {
		return GoToItem(value) != null;												// Return if we can find this file
	}
	
	public method Get(idx) : Any {
		var item : ListItem = GoToIndex(idx);										// Try to get whatever item is in the 'idx' position
		
		if (item == null) {
			return null;															// Not found, so let's return null :(
		}
		
		return item.Data;															// Return the item's data
	}
	
	public method GetLength : Int32 {
		return length;																// Return our internal length variable
	}
	
	private method GoToIndex(idx) : ListItem {
		if (idx >= length) {														// Valid index?
			return null;															// Nope :(
		}
		
		for (var cur : ListItem = head, i = 0; cur != null; cur = cur.Next) {		// Follow the 'Next' field links
			if (i++ == idx) {														// Right idx?
				return cur;															// Yes, return the list item :)
			}
		}
		
		return null;
	}
	
	private method GoToItem(data : Any) : ListItem {
		for (var cur : ListItem = head; cur != null; cur = cur.Next) {				// Follow the 'Next' field links
			if (cur.Data == data) {													// Wanted data found?
				return cur;															// Yes, return the list item :)
			}
		}
		
		return null;
	}
}
