Class dc.opcua.QueryService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property Adapter As Ens.InboundAdapter;

Property client As %SYS.Python;

Property nodesPy As %SYS.Python;

/// Server Address
Property url As %VarString;

/// Namespace uri
Property uri As %VarString;

/// Parent object to the nodes we want to collect
Property parent As %VarString;

Parameter SETTINGS = "url:OpcUA,uri:OpcUA,parent:OpcUA";

Method PyInit() [ Language = python ]
{
	import asyncua.sync
	import builtins
	import iris
	
	self.client = asyncua.sync.Client(self.url)
	self.client.connect()

	idx = str(self.client.get_namespace_index(self.uri))
	self.nodesPy = self.client.nodes.objects.get_child([idx+":"+self.parent]).get_children()

	for node in self.nodesPy:
		nodeName = node.read_display_name().Text
		nodeId = iris.cls("dc.opcua.Node").GetNodeId(self.uri, self.parent, nodeName)
}

Method PyProcessInput() [ Language = python ]
{
	import iris
	for node in self.nodesPy:
		nodeName = node.read_display_name().Text
		nodeId = iris.cls("dc.opcua.Node").GetNodeId(self.uri, self.parent, nodeName)
		value = node.read_value()
		iris.cls("dc.opcua.Value").Add(nodeId, value)
}

Method PyTearDown() [ Language = python ]
{
	self.client.disconnect()
}

/// This user callback method is called via initConfig() from %OnNew() or in the case of SOAP Services from OnPreSOAP()
Method OnInit() As %Status
{
	#dim sc As %Status = $$$OK
	try {
		do ..PyInit()
	} catch ex {
		set sc = ex.AsStatus()
	}
	
	quit sc
}

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
	#dim sc As %Status = $$$OK
	try {
		do ..PyProcessInput()
	} catch ex {
		#dim ex As %Exception.General
		set sc1 = $$$ERROR($$$GeneralError, "Exception on processing node: ")
		set sc = $$$ADDSC(sc1,ex.AsStatus())
	}
	quit sc
}

/// This user callback method is called from %OnClose()
Method OnTearDown() As %Status
{
	try {
		do ..PyTearDown()
	} catch ex {
		#dim ex As %Exception.General
		$$$LOGWARNING("Exception during disconnect: " _ ex.DisplayString())
	}
	
	quit ##super()
}

}
