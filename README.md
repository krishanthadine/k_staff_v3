# flutter_application_2

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.
 <!-- flutter build apk --split-per-abi -->
 C:\Users\Admin>keytool -genkey -v -keystore F:\flutterr\koobiyo_rider\android\app\upload-keystore.jks ^
More?         -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 ^
More?         -alias upload
Enter keystore password:
Re-enter new password:
They don't match. Try again
Enter keystore password:123456789
Re-enter new password:
What is your first and last name?
  [Unknown]:  darshana
What is the name of your organizational unit?
  [Unknown]:  flutter
What is the name of your organization?
  [Unknown]:  koombiyoIt
What is the name of your City or Locality?
  [Unknown]:  pitakotte
What is the name of your State or Province?
  [Unknown]:  west
What is the two-letter country code for this unit?
  [Unknown]:  sl
Is CN=darshana, OU=flutter, O=koombiyoIt, L=pitakotte, ST=west, C=sl correct?
  [no]:  yes

Generating 2,048 bit RSA key pair and self-signed certificate (SHA256withRSA) with a validity of 10,000 days
        for: CN=darshana, OU=flutter, O=koombiyoIt, L=pitakotte, ST=west, C=sl
Enter key password for <upload>
        (RETURN if same as keystore password):
Re-enter new password:
[Storing F:\flutterr\koobiyo_rider\android\app\upload-keystore.jks]

Warning:
The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using "keytool -importkeystore -srckeystore F:\flutterr\koobiyo_rider\android\app\upload-keystore.jks -destkeystore F:\flutterr\koobiyo_rider\android\app\upload-keystore.jks -deststoretype pkcs12".
<!-- flutter build apk --split-per-abi -->
https://fcm.googleapis.com/v1/projects/myproject-b5ae1/messages:send HTTP/1.1
//{
   "message":{
      "token":"APA91bGHXQBB...9QgnYOEURwm0I3lmyqzk2TXQ",
      "data":{
        "hello": "This is a Firebase Cloud Messaging device group message!"
      }
   }
}
A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
