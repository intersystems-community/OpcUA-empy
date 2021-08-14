Class dc.opcua.Client
{

/// do ##class(dc.opcua.Client).Test()
ClassMethod Test()
{
	set url = "opc.tcp://py:4840/freeopcua/server/"
	set uri = "http://examples.freeopcua.github.io"
	set parent = "MyObject"
	set asyncua = ##class(%SYS.Python).Import("asyncua.sync")
	set client = asyncua.Client(url)
	do client.connect()
	
	set idx = client."get_namespace_index"(uri)
	//set children = client.nodes.root."get_children"()
	//zw idx,children
	
	set builtins = ##class(%SYS.Python).Builtins()
	
	set nodes = ##class(%ListOfObjects).%New()
	
	set path = builtins.list()
	do path.append(idx _ ":" _ parent)
	set nodesPy = client.nodes.objects."get_child"(path)."get_children"()
	
	for i=0:1:builtins.len(nodesPy)-1 {
		do nodes.Insert(nodesPy."__getitem__"(i))
	}
	
	write !,nodes.GetAt(1)."read_display_name"().Text,!
	
	/*for i=0:1:99 {
		set path = builtins.list()
		do path.append(idx _ ":MyObject")
		do path.append(idx _ ":MyVariable" _ i)
		set node = client.nodes.objects."get_child"(path)
		
		do nodes.Insert(node)
	}*/
	
	do ..getValues(nodes)
	//set value = node."read_value"()
	
	//zw value
}

ClassMethod getValues(nodes As %ListOfObjects)
{
	set start = $zdt($zts,3,1,3)
	set values = ""
	for i=1:1:nodes.Count() {
		set values = values _ $lb(nodes.GetAt(i)."read_value"())
	}
	set end = $zdt($zts,3,1,3)
	
	write "start: ", start, !
	write "end: ", end, !
	zw values
}

}