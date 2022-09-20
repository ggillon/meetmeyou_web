import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meetmeyou_web/constants/color_constants.dart';
import 'package:meetmeyou_web/constants/route_constants.dart';
import 'package:meetmeyou_web/helper/shared_pref.dart';
import 'package:meetmeyou_web/provider/base_provider.dart';
import 'package:meetmeyou_web/view/base_view.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
 const VideoPlayer({Key? key}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {

  late VideoPlayerController videoPlayerController;
  ChewieController? _chewieController;

  @override
  void dispose() {
    videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final videoUrl = SharedPreference.prefs!.getString(SharedPreference.eventGalleryVideoUrl);
  @override
  Widget build(BuildContext context) {

    return BaseView<BaseProvider>(
      onModelReady: (provider) async {
        videoPlayerController = await VideoPlayerController.network(videoUrl.toString())..initialize().then((_) {
          _chewieController = ChewieController(
              videoPlayerController: videoPlayerController,
              autoPlay: true,
              looping: true,
              fullScreenByDefault: false
          );
          provider.updateLoadingStatus(true);
        });

        // if(!videoPlayerController.value.isInitialized){
        //
        //   _chewieController = ChewieController(
        //       videoPlayerController: videoPlayerController,
        //       autoPlay: true,
        //       looping: true,
        //       fullScreenByDefault: true
        //   );
        // }


        videoPlayerController.addListener(() {
          provider.updateLoadingStatus(true);
        });
        provider.updateLoadingStatus(true);
      },
      builder: (context, provider, _){
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: ColorConstants.colorBlack,
          appBar: AppBar(
            backgroundColor: ColorConstants.colorWhite,
            leading: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                 context.go(RouteConstants.eventGalleryPage);
                },
                child: Icon(Icons.arrow_back_ios,
                    color: ColorConstants.primaryColor, size: 30)),
          ) ,
          body:  SafeArea(
            child: Center(
              child: (_chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized)
                  ? Chewie(
                controller: _chewieController!,
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
