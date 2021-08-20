Class dc.opcua.Node Extends %Persistent
{

Property namespace As %VarString;

Property parent As %VarString;

Property name As %VarString;

Index pathIndex On (namespace, parent, name) [ Unique ];

ClassMethod Add(namespace, parent, name, Output id) As %Status
{
	set node = ..%New()
	set node.namespace = namespace
	set node.parent = parent
	set node.name = name
	set sc = node.%Save()
	
	set id = node.%Id()
	quit sc
}

ClassMethod GetNodeId(namespace, parent, name) As %Integer
{
	if '..pathIndexExists(namespace, parent, name, .id) {
		$$$TOE(sc,..Add(namespace, parent, name, .id))
	}
	
	quit id
}

Storage Default
{
<Data name="NodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>namespace</Value>
</Value>
<Value name="3">
<Value>parent</Value>
</Value>
<Value name="4">
<Value>name</Value>
</Value>
</Data>
<DataLocation>^dc.opcua.NodeD</DataLocation>
<DefaultData>NodeDefaultData</DefaultData>
<IdLocation>^dc.opcua.NodeD</IdLocation>
<IndexLocation>^dc.opcua.NodeI</IndexLocation>
<StreamLocation>^dc.opcua.NodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}