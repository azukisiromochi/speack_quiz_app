import 'package:quiz_app/app/models/room_user.dart';
import 'package:quiz_app/app/utils/importer.dart';
import 'package:quiz_app/app/utils/room_user_role.dart';
import 'package:quiz_app/app/widgets/components/space_box.dart';
import 'package:quiz_app/app/utils/user_playing_state.dart';

///
/// 参加者一覧を表示するブロック
///
class JoinUsersCardList extends StatelessWidget {
  final List<RoomUser> _users;
  final bool _isShowScore;

  const JoinUsersCardList({Key key, List<RoomUser> users, bool isShowScore})
      : _users = users,
        _isShowScore = isShowScore ?? false,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: 枠線の丸みは要調整
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        border: Border.all(color: Colors.black),
        color: Colors.white,
      ),
      margin: EdgeInsets.only(right: 30, left: 30),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _users.length,
        itemBuilder: (context, index) => _buildUserCard(context, _users[index]),
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, RoomUser user) {
    const borderRadius = const BorderRadius.all(Radius.circular(10.0));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      child: Container(
        height: 100,
        width: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: borderRadius,
        ),
        child: Column(
          children: <Widget>[
            // 顔写真
            ClipRRect(
              borderRadius: borderRadius,
              child: _buildUserImage(context, user.imageUrl),
            ),
            SpaceBox(height: 2),
            Text(user.name),
            _buildUserState(context, user),
          ],
        ),
      ),
    );
  }

  ///
  /// Build: 参加者のステータスを生成する
  ///
  Widget _buildUserState(BuildContext context, RoomUser user) {
    // スコア表示の有無を確認
    if (_isShowScore) {
      // プレイ中 または ゲーム終了時はスコアを表示する
      return IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              (user.score ?? 0).toString(),
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            VerticalDivider(
              thickness: 4,
              width: 0,
            ),
            Text((user.penalty ?? 0).toString(),
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                )),
          ],
        ),
      );
    } else {
      // ロビー中はユーザーの準備状況を表示
      String state =
          (user.role == RoomUserRole.MASTER) ? user.role.name : user.state.name;
      return Text(state);
    }
  }

  ///
  /// Build: ユーザーアイコン部分の生成
  ///
  Widget _buildUserImage(BuildContext context, String imageUrl) {
    // TODO: 整形する
    if (imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        width: 80,
        height: 50,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/images/empty_user_image.png",
        width: 80,
        height: 50,
        fit: BoxFit.cover,
      );
    }
  }
}
