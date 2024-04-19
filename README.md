# video_player_app

Outline:

The video player can be accessed by users either by logging in with a mobile number or by utilizing the guest user feature. If logging in, users are required to set up their profile by providing their name, email, date of birth, and profile image. The player's side drawer on the left side provides access to users' profiles and the ability to manage the app's theme. On the right side, a user image is displayed, and selecting it brings up a sign-out button. If the user is not signed in, a sign-in button will be displayed.

The player features all necessary controls, including forward, backward, previous, next, and volume. A download button with a download icon is located below the player, and if the video is already downloaded, the button icon displays a tick mark. When a user tries to download without logging in, they will be redirected to the login page. Beneath that, there is a list of videos that users can select to play. While playing, a popup displaying the video's origin will appear.

Login/Registration via Mobile & OTP:

Implemented Firebase mobile OTP-based authentication system for user login and registration.

Menu Options:

Implemented a menu with options for sign-in/registration, profile creation.
Profile section displays user information such as name, user image, email, and date of birth.
Theme section allows users to change the app theme between light and dark modes.

Video Player:

Integrated a video player within the main activity.
Implemented video downloading functionality to the device.
Implemented logic to play videos locally from the device if available.
Provided UI buttons for video playback controls (play, pause, next, previous, fast-forward, rewind).
fast-forward, rewind has the functionalities (single tap - next, previous, Double tap- fast-forward, rewind).
Volume button will mute and unmute audio.

Additional Features:

Pop Ups:
Implement pop-ups throughout the app for user interactions.

Screenshot:
Screenshots and screen recordings have been disabled using flutter_windowmanager

![Screenshot_1713519426](https://github.com/Sajidpv/Video-player/assets/125041012/8491374c-2cad-4ecf-b924-dbf24b409164)
![Screenshot_1713507548](https://github.com/Sajidpv/Video-player/assets/125041012/49da582c-189b-42cc-8c70-7a383b8ed586)





