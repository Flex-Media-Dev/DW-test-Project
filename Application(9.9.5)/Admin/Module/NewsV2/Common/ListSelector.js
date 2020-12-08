function OnListSelectorChanged(storage, setSelection, selection)
{
    var i = 0;
    var ids = '';
    var cbox = document.getElementById(storage + '_0');
    while(cbox)
    {
        if (setSelection) 
            if (!cbox.disabled) cbox.checked = selection;
        if (cbox.checked)
        {
            if (ids.length > 0) ids += ',';
            ids += cbox.value;
        }
        cbox = document.getElementById(storage + '_' + (++i));
    }
    document.getElementById(storage).value = ids;
}


