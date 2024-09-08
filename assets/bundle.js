class Form {
    constructor() {};

    // 用户点击提交按钮后，将数据传回dart
    submitMap(jsonString) {
        return webf.methodChannel.invokeMethod('submitMap', jsonString);
    }
}

window.form = new Form();
