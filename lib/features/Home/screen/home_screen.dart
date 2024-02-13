import 'package:blogapp/features/Home/delegates/search_community_delegate.dart';
import 'package:blogapp/features/Home/drawer/clist_drawer.dart';
import 'package:blogapp/features/Home/drawer/profile_drawer.dart';
import 'package:blogapp/features/auth/controller/auth_controller.dart';
import 'package:blogapp/static_file/constants/constants.dart';
import 'package:blogapp/theme/colors_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget{
  HomeScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen>{

  int _page = 0;

  void DisplayDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }

  void DisplayLeftDrawer(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }

  void onpageChange(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(ThemeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => DisplayDrawer(context),
               icon: Icon(Icons.menu));
          }
        ),
        actions: [
          IconButton(onPressed: (){
            showSearch(context: context, delegate: SearchCommunityDelegate(ref));
          }, icon: Icon(Icons.search)),
          // IconButton(onPressed: (){}, icon: Icon(Icons.person))
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () => DisplayLeftDrawer(context),
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
              );
            }
          )
        ],
      ),
      drawer: CommunityListDrawer(),
      endDrawer: ProfileDrawer(),
      body: Constants.tabWidgets[_page],
      bottomNavigationBar: CupertinoTabBar(
        activeColor: currentTheme.iconTheme.color,
        backgroundColor: currentTheme.backgroundColor,
        items: const [
         BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
            ),
      ],
      onTap: onpageChange,
      currentIndex: _page,
      ),
    );
  }
}