(function () {
    const resolution = {
        desktop1: { width: '1280', height: '612' },
        desktop2: { width: '1024', height: '612' },
        tablet1: { width: '980', height: '1024' },
        tablet2: { width: '768', height: '1024' },
        mobile: { width: '640', height: '360' }
    }

    const deviceType = {
        Desktop: 'Desktop',
        Tablet: 'Tablet',
        Mobile: 'Mobile'
    };

    const state = {
        Published: 'published',
        Draft: 'draft'
    }

    const omc = {
        Variants: 'variants',
        Original: 'original'
    }

    class Preview {
        constructor({ preview, pageId, page }) {
            this._preview = preview;
            this._pageId = pageId;
            this._page = page;
            this._init(preview);
        }

        _init(preview) {
            this._loader = preview.querySelector('.js-preview-loader');
            this._frame = preview.querySelector('.js-preview-frame');
            this._rotateTrigger = preview.querySelector('.js-preview-rotate');
            this._isDraft = preview.querySelector('#isDraft');
            this._isOMC = preview.querySelector('#isOMC');
            this._testUrl = preview.querySelector('#testurl');

            this.changeFrame(this._preview.querySelector('#prevSizeList'));

            this._rotateTrigger.addEventListener('click', this._rotateFrame.bind(this));
            this.disableProfileTest = this.disableProfileTest.bind(this);

            this._changeFrameUrl(this._frame, (url) => {
                if (url.indexOf(`devicetype=${this._selectedDevice}`) == -1) {
                    var newUrl = this._updateQueryStringParameter(this._getCurrentUrl(), 'devicetype', this._selectedDevice);
                    this._frame.contentDocument.location.href = newUrl;
                }
            });
        }

        _loadFrame(queryName, paramName, paramValue) {
            let url = this._updateQueryStringParameter(this._getCurrentUrl(), paramName, paramValue)

            this._testUrl.value = url;
            this._frame.src = url;

            this._loader.hidden = false;
            this._preview.classList.remove('preview--loaded');
            
            this._frame.onload = () => {
                this._loader.hidden = true;
                this._preview.classList.add('preview--loaded');
            }           
        }

        _rotateFrame(e) {
            let frame = this._frame;
            let frameWidth = frame.style.width;
            let frameHeight = frame.style.height;

            this._preview.classList.toggle('preview--rotate');

            frame.style.width = frameHeight;
            frame.style.height = frameWidth;
        }

        _resizeFrame(width, height) {
            this._frame.style.width = width + 'px';
            this._frame.style.height = height + 'px';
        }

        _toggleMobileView(view, add) {
            if (add) {
                this._preview.classList.add(view);
            } else {
                this._preview.classList.remove(view);
            }
        }

        _updateQueryStringParameter(a, k, v) {
            let re = new RegExp('([?|&])' + k + '=.*?(&|$)', 'i'),
                separator = a.indexOf('?') !== -1 ? '&' : '?';

            if (a.match(re)) return a.replace(re, '$1' + k + '=' + v + '$2');
            else return a + separator + k + '=' + v;
        }

        _getCurrentUrl() {
            return this._frame.contentDocument.location.href !== 'about:blank' ? this._frame.contentDocument.location.href : this._page;
        }

        _setCookie(document, queryName, cookie) {
            document.cookie = `AdminPanelPreview${queryName}=${cookie}`;
        }

        _removeCookie(name) {
            let date = new Date(0);
            document.cookie = `AdminPanelPreview${name}=''; path=/; expires=${date.toUTCString()}`;
        }

        //https://stackoverflow.com/questions/8915725/how-can-i-get-iframe-event-before-load
        _changeFrameUrl(iframe, callback) {
            let unloadHandler = () => {
                // Timeout needed because the URL changes immediately after
                // the `unload` event is dispatched.
                setTimeout(() => {
                    callback(iframe.contentWindow.location.href);
                }, 0);
            };

            let attachUnload = () => {
                // Remove the unloadHandler in case it was already attached.
                // Otherwise, the change will be dispatched twice.
                iframe.contentWindow.removeEventListener("unload", unloadHandler);
                iframe.contentWindow.addEventListener("unload", unloadHandler);
            }

            iframe.addEventListener("load", attachUnload);
            attachUnload();
        }

        disableProfileTest(e) {
            let url = this._testUrl.value + '&profile_stop=true';
            new Ajax.Request(url,
                {
                    method: 'get',
                    onSuccess: function (transport) {
                        let i = 0;
                    },
                    onFailure: function () { alert('Something went wrong... Will retry'); previewDisableProfileTest() }
                });
        }

        changeFrame(select) {
            let frameSize = resolution[select.value];
            let activeOption = select.options[select.options.selectedIndex];
            this._selectedDevice = activeOption.dataset.dataobject;

            this._loadFrame('Device', 'devicetype', this._selectedDevice);
            this._resizeFrame(frameSize.width, frameSize.height);

            if (this._selectedDevice === deviceType.Tablet || this._selectedDevice === deviceType.Mobile) {
                this._toggleMobileView('preview--mobile', true);
            } else {
                this._toggleMobileView('preview--mobile', false);
            }

            this._preview.classList.remove('preview--rotate');
        }

        changeOMC(select) {
            let url;

            if (this._isDraft.value === '1') {
                url = this._testUrl.value + '&Preview=' + this._pageId;
            } else {
                url = this._testUrl.value;
            }

            if (select.value === omc.Variants && this._isOMC.value === '1') {
                this._frame.src = url + '&variation=2';
            } else if (select.value === omc.Original && this._isOMC.value === '1') {
                this._frame.src = url + '&variation=1';
            }
        }

        //Select Publish or Draft
        changeState(select) {
            let variation = 'none';
            let prevOMCList = this._preview.querySelector('#prevOMCList');

            if (prevOMCList.value === omc.Variants && this._isOMC.value === '1') {
                variation = '2'
            } else if (prevOMCList.value === omc.Original && this._isOMC.value === '1') {
                variation = '1'
            }

            switch (select.value) {
                case state.Published:
                    this._isDraft.value = '0';
                    this._loadFrame('State', 'variation', variation);
                    break;
                case state.Draft:
                    this._isDraft.value = '1';
                    this._loadFrame('State', 'Preview', this._pageId);
                    break;
            }
        }

        changeProfile(select) {
            this._loadFrame('Profile', 'profile', select.value);
        }
    }

    class PreviewVariation {
        constructor() {
            this._init();
        }

        _init() {
            this._frame = document.getElementById("previewFrame");
            this._link1 = document.getElementById("link1");
            this._link2 = document.getElementById("link2");
            this._testurl = document.getElementById("testurl").value;
        }

        test(variation) {
            if (variation == "2") {
                this._link2.className = "active";
                this._link1.className = "";
            } else {
                this._link1.className = "active";
                this._link2.className = "";
            }

            this._frame.src = this._testurl + '&variation=' + variation;
        }
    }

    window.Preview = Preview;
    window.PreviewVariation = PreviewVariation;
})()
