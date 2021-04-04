    # Filest

## Our Website

http://filest.ca/

## Description

Filest is a human resource iOS application that lets users schedule meetings, request vacation days, and self report absence from work due to illness or leisure. When you first download the app you can use it to start a business, have other employees join with your code, and see them displayed on your contact list. Filest is currently pending approval for the iOS App Store.

## Table of Contents

[Tools Used](#tools)

[1. Signing Up Example](#a)

[2. Log In Example](#b)

[3. Starting A New Business](#c)

[4. Editing Profile](#d)

[5. Contacts and Main Tab](#e)

[Extra](#f)


<a name="tools"></a>

## Tools Used

### - Google Firebase

  1. Authentication
    - Used for signing up, logging in, and email verification.
  2. Firestore
    - Stores Business information of tasks, employees, departments, etc..
  3. Storage
    - Stores profile photos
    
### - Xcode

  1. Constraints
    - Added constraints to have each view fit with every iphone. Programmatically changed constraints after viewdidload for buttons that move with keyboard. 
  2. NSCache
    - Caches UIImages for contacts and profile when downloaded from firebase to improve speed, user experience, and depand from firebase.
  3. UIImagePicker
    - Used to access photolibrary or camera to take a photo of you!
  4. NotificationCenter
    - Used to observe the keyboard to have the LogIn buttion slide up with the keyboard, and change color when user is about to log in.

<a name="a"></a>

# 1. Signing Up Example

<p align="center">
  <img src="Videos/SignUpExample.gif" width="45%" height="45%"/>
</p>

<a name="b"></a>

# 2. Log In Example

### After you have made your account and verified it you can log in.

<p align="center">
  <img src="Videos/LogInExampleWithVerification.gif" />
</p>

<a name="c"></a>

# 3. Starting A New Business

### Here you can see that you must start a business or join one to begin using the app! You can also see in real time the business code being generated and saved in firebase.

<img src="Videos/StartingBusinessExample.gif" />


<a name="d"></a>

# 4. Editing Profile

### After you have joined or started a business you can now edit your profile! It stores your basic information as well as your photo!

<p align="center">
  <img src="Videos/EditingProfileExample.gif" width="45%" height="45%"/>
</p>

<a name="e"></a>

# 5. Contacts and Main Tab

### Once people have joined your business you can see them on your contacts list! Then in your Main tab you can preform company tasks.

<p align="center">
  <img src="Videos/Contacts&MainExample.gif" width="45%" height="45%"/>
</p>

# Extra: 

<a name="f"></a>

## Email Verification

### When you tap sign up you are alerted to open one of three mail apps that you may have. Tapping on one will open the app if you have it installed. You are also sent an email verification via firebase email verification. Once you verify your email you can then log into Filest! Yay!

- Here you can see the alert

<p align="center">
  <img src="Videos/EmailVerificationExamplePart1.gif" width="45%" height="45%"/>
</p>

- Here is the email verification

![](Videos/EmailVerificationExamplePart2.gif)

### Here is a working example of the correct username and password, but without verifying your email.

<p align="center">
  <img src="Videos/LogInExampleNoVerification.gif" />
</p>
