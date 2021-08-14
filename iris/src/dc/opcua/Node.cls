Class dc.opcua.Node Extends %Persistent
{

Property namespace As %VarString;

Property parent As %VarString;

Property name As %VarString;

Property type As %String;

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
<Value name="5">
<Value>type</Value>
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