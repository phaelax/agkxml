# agkxml

An XML parser for the AppGameKit language. It's more of a DOM parser in the fact that it loads the entire document into memory.

Commands:
=========

.. code-block:: python

   arr[]  = xml_loadDocument(string filename)
   int    = xml_GetParentId(dom ref as XML_Element[], elementId as integer)
   int    = xml_GetAttributeCount(dom ref as XML_Element[], elementId as integer)
   int    = xml_GetAttributeKeyById(dom ref as XML_Element[], elementId as integer, attributeId as integer)
   int    = xml_GetAttributeValueById(dom ref as XML_Element[], elementId as integer, attributeId as integer)
   int    = xml_GetTagName(dom ref as XML_Element[], elementId as integer)
   int    = xml_GetChildCount(dom ref as XML_Element[], elementId as integer)
   string = xml_GetAttributeValueByName(dom ref as XML_Element[], elementId as integer, att as string))
   int    = xml_GetAttributeIdByName(dom ref as XML_Element[], elementId as integer, att as string))
   arr[]  = xml_GetAttributesArray(dom ref as XML_Element[], elementId as integer)
   string = xml_GetElementValue(dom ref as XML_Element[], elementId as integer)
   int    = xml_GetChildIdById(dom ref as XML_Element[], elementId as integer, childId as integer)
   arr[]  = xml_GetRootElementsArray(dom ref as XML_Element[])
