/**
 * AirPrint
 */

(function(cordova) {

	function AirPrint() {}

AirPrint.prototype.callbackMap = {};
AirPrint.prototype.callbackIdx = 0;

/*
 print      - html string or DOM node (if latter, innerHTML is used to get the contents). REQUIRED.
 success    - callback function called if print successful.     {success: true}
 fail       - callback function called if print unsuccessful.  If print fails, {error: reason}. If printing not available: {available: false}
 options    -  {dialogOffset:{left: 0, right: 0}}. Position of popup dialog (iPad only).
 */
AirPrint.prototype.print = function(printHTML, success, fail, options) {
    if (typeof printHTML != 'string'){
        console.log("Print function requires an HTML string. Not an object");
        return;
    }


    //var printHTML = "";

    var dialogLeftPos = 0;
    var dialogTopPos = 0;


    if (options){
        if (options.dialogOffset){
            if (options.dialogOffset.left){
                dialogLeftPos = options.dialogOffset.left;
                if (isNaN(dialogLeftPos)){
                    dialogLeftPos = 0;
                }
            }
            if (options.dialogOffset.top){
                dialogTopPos = options.dialogOffset.top;
                if (isNaN(dialogTopPos)){
                    dialogTopPos = 0;
                }
            }
        }
    }

    var key = 'print' + this.callbackIdx++;
    window.plugins.airPrint.callbackMap[key] = {
        success: function(result) {
            delete window.plugins.airPrint.callbackMap[key];
            success(result);
        },
        fail: function(result) {
            delete window.plugins.airPrint.callbackMap[key];
            fail(result);
        },
    };

    var callbackPrefix = 'window.plugins.airPrint.callbackMap.' + key;
    return cordova.exec(success, fail, "AirPrint","print", [printHTML, dialogLeftPos, dialogTopPos, callbackPrefix + '.success', callbackPrefix + '.fail']);
};

/*
 * Callback function returns {available: true/false}
 */
AirPrint.prototype.isPrintingAvailable = function(callback) {
    var key = 'isPrintingAvailable' + this.callbackIdx++;
    window.plugins.airPrint.callbackMap[key] = function(result) {
        delete window.plugins.airPrint.callbackMap[key];
        callback(result);
    };

    var callbackName = 'window.plugins.airPrint.callbackMap.' + key;
    cordova.exec(null, null, "AirPrint", "isPrintingAvailable", callbackName);
};

cordova.addConstructor(function() {
		if(!window.plugins) window.plugins = {};
		window.plugins.airPrint = new AirPrint();
	});

})(window.cordova || window.Cordova || window.PhoneGap);