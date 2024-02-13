import 'package:blogapp/features/communuty/controller/communty_controller.dart';
import 'package:blogapp/static_file/common/loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget{
  CreateCommunityScreen();
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CreateCommunityScreenState();
  }
}


class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen>{
  final CnameController = TextEditingController();

  void createCommunity(){
    ref.read(CommunityControllerProvider.notifier)
    .createCommunity(CnameController.text.trim(), context);
  }



  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(CommunityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create a Community'),
      ),
      body: isLoading? 
      Loader() :
       Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Align(alignment: Alignment.topLeft,child: Text('Community Name'),),
            SizedBox(height: 16,),
            TextField(
              controller: CnameController,
              decoration: InputDecoration(
                hintText: 'b/community name',
                filled: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(8)
              ),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: createCommunity,
              child: Text('Create Community'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                )
              ),
              ),
          ],
        ),
      ),
    );
  }
}