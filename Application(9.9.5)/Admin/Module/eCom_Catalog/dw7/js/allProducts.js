

var allProducts = {
    editProduct: function (e, productId) {
        if (e != null) {
            var t = $(e.srcElement || e.target);
            if (t.tagName == "IMG" && t.id.indexOf("img_") == 0) {
                return;
            }
        }

        queryString.init(location.pathname);
        queryString.set("psearch", $("products_search").value);
        queryString.set("ppagenumber", $("products_pagenumber").value);
        queryString.set("ppagesize", $("products_pagesize").value);
        queryString.set("psort", $("products_sort").value);
        queryString.set("psortcolid", $("products_sortColId").value);
        queryString.set("psortcoldir", $("products_sortColDir").value);
        queryString.set("ShowOnlyEcomProducts", $("show_only_ecom_products").value);
        queryString.remove("selectedLangID");

        var backUrl = escape(queryString.toString());

        var url = "edit/EcomProduct_Edit.aspx?ID=" + encodeURIComponent(productId) + "&backUrl=" + backUrl;
        document.location.href = url;
    }
};
