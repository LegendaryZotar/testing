# Testing App

A Test app to replicate the problem im having with AwesomeNotifications

## Steps to reproduce problem

1. Start App
2. Click Button right button
3. Deny Permission when prompted
4. Click Button in bottom right again
5. When sent to Settings don't do anything and return to app
- App is now still awaiting AwesomeNotifications().requestPermissionToSendNotifications() to return.

(You can also try turning the permission on and off, but this may cause a black screen when returning as mentioned [Here](https://github.com/rafaelsetragni/awesome_notifications/issues/842) )
