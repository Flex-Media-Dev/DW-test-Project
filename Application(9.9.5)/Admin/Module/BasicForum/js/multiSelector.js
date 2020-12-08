// Multiple file selector by Stickman -- http://www.the-stickman.com 
// Used by the multifile upload feature
function MultiSelector(list_target, max) {
    this.list_target = list_target;
    this.count = 0;
    this.id = 0;

    if (max) {
        this.max = max;
    } else {
        this.max = -1;
    };

    this.addElement = function (element) {
        if (element.tagName == 'INPUT' && (element.type == 'file' || element.type == 'hidden')) {
            element.name = 'file_' + this.id++;
            element.multi_selector = this;

            element.onchange = function () {
                if (this.files.length < 1) {
                    return false;
                }
                
                var new_element = document.createElement('input');
                new_element.type = 'file';
                new_element.style.display = 'none';

                var uploadButton = document.getElementById("uploadButton");
                uploadButton.onclick = function () {
                    new_element.click();
                }

                this.parentNode.insertBefore(new_element, this);
                this.multi_selector.addElement(new_element);
                this.multi_selector.addListRow(this);
                this.style.display = 'none';
            }

            if (this.max != -1 && this.count >= this.max) {
                element.disabled = true;
                var uploadButton = document.getElementById("uploadButton");
                if (uploadButton) {
                    uploadButton.disabled = true;
                }
            }

            this.count++;
            this.current_element = element;
        }
    }

    this.addListRow = function (element) {
        var new_row = document.createElement('div');
        var file_name = document.createElement('div');
        var new_row_button = document.createElement('a');
        var new_row_button_icon = document.createElement('i');
        var new_row_clear = document.createElement('div');

        new_row.element = element;
        new_row.className = 'forum-post-file';

        new_row_button.setAttribute('href', 'javascript:void(0);');
        new_row_button.setAttribute('title', 'Delete');

        new_row_button_icon.className = "fa fa-remove color-danger";
        new_row_button_icon.setAttribute('title', 'Delete');

        new_row_button.appendChild(new_row_button_icon);

        new_row_button.onclick = function () {

            if (this.parentNode.element.type == 'file') {
                this.parentNode.element.parentNode.removeChild(this.parentNode.element);
            }
            else if (this.parentNode.element.type == 'hidden') {
                this.parentNode.element.id = 'deleted_' + this.parentNode.element.id;
                this.parentNode.element.name = 'deleted_' + this.parentNode.element.name;
            }

            this.parentNode.parentNode.removeChild(this.parentNode);
            this.parentNode.element.multi_selector.count--;
            this.parentNode.element.multi_selector.current_element.disabled = false;

            if (this.parentNode.element.multi_selector.count <= 1) {

                this.parentNode.element.multi_selector.list_target.style.display = 'none';
            }

            return false;
        }

        file_name.className = 'file-name';
        file_name.setAttribute('title', element.value);

        file_name.appendChild(document.createTextNode(element.value));

        new_row_clear.className = 'forum-post-clear';

        new_row.appendChild(file_name);
        new_row.appendChild(new_row_button);
        new_row.appendChild(new_row_clear);

        this.list_target.appendChild(new_row);

        this.list_target.style.display = 'block';
    }
}