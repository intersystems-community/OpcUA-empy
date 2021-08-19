Class dc.opcua.Threshold Extends %Persistent
{

Property node As Node;

Property value As %Decimal(SCALE = 2);

Property type As %String(VALUELIST = ",warning,error");

/// do ##class(dc.opcua.Threshold).ActiveFunc(100).%Display()
Query Active(period) As %SQLQuery
{
SELECT 
	t.node->name node,  
	t.type type, 
	t.value threshold, 
	ROUND(AVG(v.value),2) value
FROM dc_opcua.Threshold t
JOIN dc_opcua.Value v ON v.node = t.node AND DATEADD("ss", -:period, NOW())<v.ts AND v.value >= t.value
GROUP BY t.id
}

/// do ##class(dc.opcua.Threshold).Init()
ClassMethod Init() As %Status
{
	#dim sc As %Status = $$$OK
	do ..%KillExtent()
	for threshold = $lb(1, 10, "warning"), $lb(1, 15, "error") {
		set sc = ..Add($lg(threshold, 1), $lg(threshold, 2), $lg(threshold, 3))
		quit:$$$ISERR(sc)
	}
	quit sc
}

ClassMethod Add(nodeId As %Integer, value As %Decimal(SCALE=2), type As %String) As %Status
{
	set obj = ..%New()
	do obj.nodeSetObjectId(nodeId)
	set obj.value = value
	set obj.type = type
	quit obj.%Save()
}

Storage Default
{
<Data name="ThresholdDefaultData">
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
<Value>period</Value>
</Value>
<Value name="5">
<Value>type</Value>
</Value>
</Data>
<DataLocation>^dc.opcua.ThresholdD</DataLocation>
<DefaultData>ThresholdDefaultData</DefaultData>
<IdLocation>^dc.opcua.ThresholdD</IdLocation>
<IndexLocation>^dc.opcua.ThresholdI</IndexLocation>
<StreamLocation>^dc.opcua.ThresholdS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}