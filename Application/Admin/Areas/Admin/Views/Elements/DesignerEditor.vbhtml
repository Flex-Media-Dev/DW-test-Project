<!doctype html>
<html>

<link rel="stylesheet" href="http://codemirror.net/lib/codemirror.css" />
<script src="http://codemirror.net/4/lib/codemirror.js"></script>
<script src="http://codemirror.net/4/mode/javascript/javascript.js"></script>
<style type="text/css">

    html, body, article, form {margin:0px;padding:0px;border:none;overflow:hidden;}
    .CodeMirror {
        border: 1px solid #eee;
        height: 100%;
    }
</style>


<body>
<article>
    <form id="codeForm" target="DesignerSurface" action="~/Admin/Elements/DesignerSurface" method="post" style="position: absolute; top: 0px; bottom: 0px; left: 0px; right: 0px">
        <textarea id="code" name="code">
{
    "$type": "Screen",
    "Title": "TestScreen",
    "Elements" : [
        {
            "$type": "Breadcrumb",
            Title: "Test"
        },
        {
            "$type": "Breadcrumb",
            Title: "Test"
        },
        {
            "$type": "Card",
            Title: "My Card",
            "Elements" : [
                {
                "$type": "Section",
                Title: "My Section"
                }
            ]
        }
    ]
}
        </textarea>
    </form>

</article>

<script>
    var updateTimer;

	var editor = CodeMirror.fromTextArea(document.getElementById("code"), {
		lineWrapping: true,
        lineNumbers: true,
        mode: { name: "javascript", json: true },
	});

	// on and off handler like in jQuery
	editor.on('change', function (cMirror) {
		// get value right from instance
		sourcecode = cMirror.getValue();
		if (eval("[" + sourcecode + "]")) {
		    window.clearTimeout(updateTimer);
		    updateTimer = window.setTimeout(updateSurface, 2000);
		}
	});

	function updateSurface()
	{
	    document.getElementById("codeForm").submit();
	}

	updateSurface();

</script>



</body>
</html>