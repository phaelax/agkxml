//////////////////////////////////////////////////////////////////////
// Title: XML Parser
// Author: Phaelax
// Date: March 4, 2017
//
// Commands:
//    arr[]  = xml_loadDocument(string filename)
//    int    = xml_GetParentId(dom ref as XML_Element[], elementId as integer)
//    int    = xml_GetAttributeCount(dom ref as XML_Element[], elementId as integer)
//    int    = xml_GetAttributeKeyById(dom ref as XML_Element[], elementId as integer, attributeId as integer)
//    int    = xml_GetAttributeValueById(dom ref as XML_Element[], elementId as integer, attributeId as integer)
//    int    = xml_GetTagName(dom ref as XML_Element[], elementId as integer)
//    int    = xml_GetChildCount(dom ref as XML_Element[], elementId as integer)
//    string = xml_GetAttributeValueByName(dom ref as XML_Element[], elementId as integer, att as string))
//    int    = xml_GetAttributeIdByName(dom ref as XML_Element[], elementId as integer, att as string))
//    ar[]   = xml_GetAttributesArray(dom ref as XML_Element[], elementId as integer)
//    string = xml_GetElementValue(dom ref as XML_Element[], elementId as integer)
//    int    = xml_GetChildIdById(dom ref as XML_Element[], elementId as integer, childId as integer)
//    arr[]  = xml_GetRootElementsArray(dom ref as XML_Element[])


SetVirtualResolution(1920,1200)
SetWindowSize(1920, 1200, 0)
UseNewDefaultFonts(1)
SetSyncRate(60, 0 ) 
setPrintSize(20)


Type XML_Attribute
	key as string
	value as string
EndType

Type XML_Tag
	parent as integer
	name as string
	attributes as XML_Attribute[]
	value as string
EndType

Type XML_Element
	self as XML_Tag
	children as integer[-1]
EndType


dom as XML_Element[]

start = GetMilliseconds()
dom = xml_loadDocument("overworld22.tmx")
finish = getMilliseconds()

// Get the root elements of the dom tree
roots as integer[]
roots = xml_GetRootElementsArray(dom)



do
	
	print(finish-start)
	print("")


	for i = 0 to roots.length
		printElement(dom, roots[i], "")
	next i
	

    sync()
loop



function printElement(dom ref as XML_Element[], i as integer, space as string)
	name$  = xml_GetTagName(dom, i)
	parent = xml_GetParentId(dom, i)
	childCount = xml_GetChildCount(dom, i) 
	att as XML_Attribute[]
	att = xml_GetAttributesArray(dom, i)
	value$ = xml_GetElementValue(dom, i)
	printc(space+str(i)+")   "+name$)
	printc("    [")
	for k = 0 to att.length
		printc(att[k].key+"  =  "+att[k].value+" , ")
	next k
	printc("]")
	printc("    (childCount:  "+str(childCount)+")")
	print("        parentID:  "+str(parent))

	for j = 0 to childCount-1
		c = xml_GetChildIdById(dom, i, j)
		printElement(dom, c, space+"            ")
	next j
	print("")
endfunction



//////////////////////////////////////////////////////////////////////
// Return an array of indices of each element that is part of the dom root
//////////////////////////////////////////////////////////////////////
function xml_GetRootElementsArray(dom ref as XML_Element[])
	arr as integer[]
	for i = 0 to dom.length
		if dom[i].self.parent = 0 then arr.insert(i)
	next i
endfunction arr
//////////////////////////////////////////////////////////////////////
// Return the element id of the specified child element
//////////////////////////////////////////////////////////////////////
function xml_GetChildIdById(dom ref as XML_Element[], elementId as integer, childId as integer)
	if childId = -1 then exitfunction -1
endfunction dom[elementId].children[childId]

//////////////////////////////////////////////////////////////////////
// Return the element's value (inner content)
//////////////////////////////////////////////////////////////////////
function xml_GetElementValue(dom ref as XML_Element[], elementId as integer)
endfunction dom[elementId].self.value

//////////////////////////////////////////////////////////////////////
// Return an array of XML_Attribute
//////////////////////////////////////////////////////////////////////
function xml_GetAttributesArray(dom ref as XML_Element[], elementId as integer)
endfunction dom[elementId].self.attributes

//////////////////////////////////////////////////////////////////////
// Returns the parent ID of this element
//////////////////////////////////////////////////////////////////////
function xml_GetParentId(dom ref as XML_Element[], elementId as integer)
endfunction dom[elementId].self.parent

//////////////////////////////////////////////////////////////////////
// Returns the key/name of an attribute
//////////////////////////////////////////////////////////////////////
function xml_GetAttributeKeyById(dom ref as XML_Element[], elementId as integer, attributeId as integer)
endfunction dom[elementId].self.attributes[attributeId].key

//////////////////////////////////////////////////////////////////////
// Returns the value of an attribute given it's ID
//////////////////////////////////////////////////////////////////////
function xml_GetAttributeValueById(dom ref as XML_Element[], elementId as integer, attributeId as integer)
endfunction dom[elementId].self.attributes[attributeId].value

//////////////////////////////////////////////////////////////////////
// Returns the value of an attribute, looked up by the attribute name
//////////////////////////////////////////////////////////////////////
function xml_GetAttributeValueByName(dom ref as XML_Element[], elementId as integer, att as string)
	for i = 0 to dom[elementId].self.attributes.length
		if dom[elementId].self.attributes[i].key = att then exitfunction dom[elementId].self.attributes[i].value
	next i
endfunction ""

//////////////////////////////////////////////////////////////////////
// Returns the ID of an attribute of specified element
//////////////////////////////////////////////////////////////////////
function xml_GetAttributeIdByName(dom ref as XML_Element[], elementId as integer, att as string)
	for i = 0 to dom[elementId].self.attributes.length
		if dom[elementId].self.attributes[i].key = att then exitfunction i
	next i
endfunction -1

//////////////////////////////////////////////////////////////////////
// Return the tag name of this element
//////////////////////////////////////////////////////////////////////
function xml_GetTagName(dom ref as XML_Element[], elementId as integer)
endfunction dom[elementId].self.name

//////////////////////////////////////////////////////////////////////
// Returns the number of attributes for this element
//////////////////////////////////////////////////////////////////////
function xml_GetAttributeCount(dom ref as XML_Element[], elementId as integer)
endfunction dom[elementId].self.attributes.length+1

//////////////////////////////////////////////////////////////////////
// Returns the number of direct children under the specified element
//////////////////////////////////////////////////////////////////////
function xml_GetChildCount(dom ref as XML_Element[], elementId as integer)
endfunction dom[elementId].children.length+1

//////////////////////////////////////////////////
// Returns the index in xml array of the first
// occurrence of 'tag'
// Returns -1 if no match found
//////////////////////////////////////////////////

function xml_FindFirstTag(dom as XML_Element[], tag as string)
	for i = 0 to dom.length
		if dom[i].self.name  = tag then exitfunction i
	next i
endfunction -1

//////////////////////////////////////////////////
// Loads an XML file into a DOM-like structure
// and returns it as an array of XML_Element
//////////////////////////////////////////////////
function xml_loadDocument(file as string)
	elements as XML_Element[]

	openTags as integer[0]

	f = openToRead(file)


	q = 0
	repeat
		inc q
		// find tag
		s$ = readLine(f)
		L = len(s$)
		a1 = 0
		findAtts = 0
		tagFound = 0
		for i = 1 to L
			// tag opening
			b$ = mid(s$, i, 1)
			if b$ = "<"
				if mid(s$, i+1, 1) = "/"
					openTags.remove()
					exit
				else
					for j = i+1 to L
						c$ = mid(s$, j, 1)
						if c$ = " " or c$ = ">"
							tagFound = 1
							tag$ = mid(s$, i+1, j-i-1)
							e as XML_Element
							e.self.name = tag$
							e.self.parent = openTags[openTags.length]
							elements.insert(e)
							insertedElement = elements.length
							
							if e.self.parent > 0 then elements[e.self.parent].children.insert(insertedElement)
							
							a1 = j+1
							if c$ = " "
								findAtts = 1
							else
								// add this tag to open stack
								openTags.insert(elements.length)
							endif
							exit
						endif
					next j
				endif
			else
				if asc(b$) > 32 and asc(b$) < 127
					elements[openTags[openTags.length]].self.value = s$
					exit
				endif
			endif
		next i


		if findAtts = 1
			repeat
				n1 = 0 : n2 = 0
				v1 = 0 : v2 = 0
				insert = 0
				c1$ = ''
				// get attributes
				for i = a1 to L
					c$ = mid(s$, i, 1)
					// start of attribute name
					if c$ <> " " and n1=0 then n1 = i
					if c$ = "=" then n2 = i
					
					if c1$ <> ''
						if c$ = c1$
							v2 = i
							a1 = i+1
							insert = 1
							exit
						endif
					else
						if c$ = "'" or c$ = '"'
							c1$ = c$
							v1 = i+1
						endif
					endif
				next i
				
				if insert = 1
					a as XML_Attribute
					a.key = mid(s$, n1, n2-n1)
					a.value = mid(s$, v1, v2-v1)
					
					elements[elements.length].self.attributes.insert(a)
				endif
			until i >= L
			
			// Check next to last character to see if this is a singleton tag
			c$ = mid(s$, L-1, 1)
			if c$ = "/" or c$ = "?"
				// if singleton, do nothing
			else
				// opening tag, add to stack
				openTags.insert(elements.length)
			endif
			
		endif
	until fileEOF(f)
	closeFile(f)
endfunction elements
