# X (Twitter) Clone (Updated 2024)

Hello. I'm Taylan Özgür Ertaş. 

Finally I finished the course and created a full-stack Twitter clone project using Appwrite. 

Thanks for everything Rivaan Ranawat. While working on the project, I encountered some issues that I had seen frequently mentioned on GitHub and the other places. I think I resolved all of these common issues. 

![](https://resmim.net/cdn/2024/04/27/fohXwq.png)

Features: 

*Dark Mode <br>
*Light Mode <br>
*Sign Up With Email, Password <br>
*Sign In With Email, Password <br>
*Tweeting Text <br>
*Tweeting Image <br>
*Tweeting Link <br>
*Hashtag identification & storage <br>
*Displaying tweets <br>
*Liking tweet <br>
*Retweeting <br>
*Commenting/Replying <br>
*Follow user <br> 
*Search users <br>
*Display followers, following, recent tweets <br>
*Edit User Profile <br>
*Show tweets that have 1 hashtag <br>
*Twitter Blue <br>
*Notifications tab (replied to you, followed you, like your pic, retweeted) <br>

## Structure

This project uses feature first approach. features> .. > controller, view, widgets arc. This project contains a lot of things. This project has these techs: 

  cupertino_icons: ^1.0.2 <br>
  appwrite: ^12.0.1 <br>
  flutter_svg: ^2.0.10+1 <br>
  flutter_riverpod: ^2.5.1 <br>
  fpdart: ^1.1.0 <br>
  image_picker: ^1.0.7 <br>
  carousel_slider: ^4.2.1 <br>
  timeago: ^3.6.1 <br>
  any_link_preview: ^3.0.1 <br> 
  like_button: ^2.0.5 <br>

### Installation 

You need to install Docker first after that install Appwrite. And configure it for this project's auth and post db. 
You can find the configuration settings in Rivaan's video:

Install Appwrite <br>
Create Appwrite Project Locally <br>
Create Android & iOS Apps in the Dashboard <br>
Create Appwrite Database, Storage <br>
Modify Roles in Auth, Database, Storage <br>
Create Attributes for Tweets, Users, Notifications Collection <br>
Copy the required ids & change it in lib/constants/appwrite_constants.dart <br>
Change your IP Address in lib/constants/appwrite_constants.dart <br>

Server: Appwrite Auth, Appwrite Storage, Appwrite Database, Appwrite Realtime

Client: Flutter, Riverpod
