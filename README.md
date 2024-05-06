# DiaryUploader
自用工具把日记草稿拆分上传到谷歌日历，


## macos
按桌面版走，不按ios的来，  
原理是监听端口，唤起浏览器登录后回调localhost传code回来，  

## web
实际使用官方的google_sign_in，需要开放people api，原因不明，  

## android
奇怪了，用web端的client id才行，debug/release都正常，  
明明使用的是官方的google_sign_in，难道官方自己也没走安卓sdk？这有点坑啊，  
而且web凭据设置的“已获授权的 JavaScript 来源”好像也没啥用，  
有人说要上firebase下载google-services.json，官方示例也有这个， 但是也没用，  

## 参考
https://support.syncfusion.com/kb/article/10505/how-to-add-google-calendar-events-to-the-flutter-event-calendar  
https://github.com/jonataslaw/get_cli/blob/master/README-zh_CN.md  
https://stackoverflow.com/a/56037554/5615186  
https://github.com/flutter/packages/blob/main/packages/google_sign_in/google_sign_in/example/android/app/google-services.json  
