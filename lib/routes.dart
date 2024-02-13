import 'package:blogapp/features/Home/screen/home_screen.dart';
import 'package:blogapp/features/Home/user_profile/screens/edit_profile_screen.dart';
import 'package:blogapp/features/Home/user_profile/screens/user_profile_screen.dart';
import 'package:blogapp/features/auth/screen/login_screen.dart';
import 'package:blogapp/features/communuty/screens/add_mod_screen.dart';
import 'package:blogapp/features/communuty/screens/community_screen.dart';
import 'package:blogapp/features/communuty/screens/create_com_screen.dart';
import 'package:blogapp/features/communuty/screens/edit_community_screen.dart';
import 'package:blogapp/features/communuty/screens/mod_tools_screen.dart';
import 'package:blogapp/features/post/screen/add_post_type_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/' : (_) =>  MaterialPage(child: loginScreen()),
});


final loggedInRoute = RouteMap(routes: {
  '/' : (_) =>  MaterialPage(child: HomeScreen()),

  '/createCommunity' : (_) => MaterialPage(child: CreateCommunityScreen()),

  '/b/:name' : (route) => MaterialPage(child: CommunityScreen(
    name: route.pathParameters['name']!,
  )),

  '/mod_tools/:name':(Routedata) => MaterialPage(child: ModToolSscreen(
    name: Routedata.pathParameters['name']!,
  )),

  '/edit_community/:name':(Routedata) => MaterialPage(child: EditCommunityScreen(
    name: Routedata.pathParameters['name']!,
  )),

  '/add_mods/:name':(Routedata) => MaterialPage(child: AddModerator(
    name: Routedata.pathParameters['name']!,
  )),

  '/u/:uid':(RouteData)=>MaterialPage(child: UserProfileScreen(
      uid: RouteData.pathParameters['uid']!
  )),

  '/edit_profile/:uid':(RouteData)=>MaterialPage(child: EditProfileScreen(
      uid: RouteData.pathParameters['uid']!
  )),

  '/add_post/:type':(RouteData)=>MaterialPage(child: AddPostTypeScreen(
      type: RouteData.pathParameters['type']!
  )),
  
});

