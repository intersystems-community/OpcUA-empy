Class dc.opcua.Value Extends %Persistent
{

Property node As Node;

Property value As %Decimal(SCALE = 2);

Property ts As %TimeStamp;

Index nodeIndex On node [ Type = bitmap ];

Index tsIndex On ts;

ClassMethod Add(nodeId As %Integer, value As %Decimal, ts As %TimeStamp = {$zdt($now(),3,1,6)}) As %Status
{
	set obj = ..%New()
	do obj.nodeSetObjectId(nodeId)
	set obj.value = value
	set obj.ts = ts
	quit obj.%Save()
}

Storage Default
{
<Data name="ValueDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>node</Value>
</Value>
<Value name="3">
<Value>value</Value>
</Value>
<Value name="4">
<Value>ts</Value>
</Value>
</Data>
<DataLocation>^dc.opcua.ValueD</DataLocation>
<DefaultData>ValueDefaultData</DefaultData>
<IdLocation>^dc.opcua.ValueD</IdLocation>
<IndexLocation>^dc.opcua.ValueI</IndexLocation>
<StreamLocation>^dc.opcua.ValueS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}