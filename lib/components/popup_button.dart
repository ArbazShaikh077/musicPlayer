import 'package:flutter/material.dart';
import 'package:musicPlayer/screens/edit_info.dart';
import 'package:musicPlayer/util/config.dart';
import 'package:musicPlayer/providers/song_controller.dart';
import 'package:share/share.dart';
import 'create_playList.dart';

enum Options {
  AddToPlaylist,
  DeleteRemove,
  Share,
  EditInfo,
}

class PopUpButton extends StatelessWidget {
  PopUpButton({
    @required this.songList,
    @required this.canDelete,
    @required this.index,
    @required this.controller,
    @required this.dialogFunction,
  });

  final List songList;
  final bool canDelete;
  final SongController controller;
  final Function dialogFunction;
  final int index;

  PopupMenuItem _popupItem(
      {BuildContext context, String text, IconData icon, Options value}) {
    return PopupMenuItem(
      value: value,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: Config.textSize(context, 3.5),
                fontWeight: FontWeight.w400,
                fontFamily: 'Acme'),
          ),
          Icon(icon),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Theme.of(context).dialogBackgroundColor,
      icon: Icon(
        Icons.more_vert,
        size: Config.xMargin(context, 6),
      ),
      onSelected: (option) async {
        switch (option) {
          case Options.AddToPlaylist:
            showDialog(
              context: context,
              builder: (context) {
                return CreatePlayList(
                  songs: [songList[index]],
                  createNewPlaylist: false,
                );
              },
            );
            break;
          case Options.DeleteRemove:
            await dialogFunction(context, songList, index, controller);
            break;
          case Options.Share:
            final RenderBox box = context.findRenderObject();
            await Share.shareFiles([songList[index]['path']],
                subject: songList[index]['title'],
                sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
            break;
          case Options.EditInfo:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => EditInfo(
                  song: songList[index],
                ),
              ),
            );
            break;
          default:
        }
      },
      itemBuilder: (context) {
        return [
          _popupItem(
            context: context,
            text: 'Add to playlist',
            icon: Icons.playlist_add,
            value: Options.AddToPlaylist,
          ),
          _popupItem(
            context: context,
            text: canDelete ? 'Delete song' : 'Remove song',
            icon: canDelete ? Icons.delete : Icons.remove,
            value: Options.DeleteRemove,
          ),
          _popupItem(
            context: context,
            text: 'Share',
            icon: Icons.share,
            value: Options.Share,
          ),
          _popupItem(
            context: context,
            text: 'Edit info',
            icon: Icons.edit,
            value: Options.EditInfo,
          ),
        ];
      },
    );
  }
}
