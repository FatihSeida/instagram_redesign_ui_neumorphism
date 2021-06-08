import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_instagram/blocs/blocs.dart';
import 'package:flutter_instagram/cubits/cubits.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:flutter_instagram/screens/profile/bloc/profile_bloc.dart';
import 'package:flutter_instagram/screens/profile/widgets/widgets.dart';
import 'package:flutter_instagram/screens/screens.dart';
import 'package:flutter_instagram/widgets/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreenArgs {
  final String userId;

  const ProfileScreenArgs({@required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  static Route route({@required ProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
          likedPostsCubit: context.read<LikedPostsCubit>(),
        )..add(ProfileLoadUser(userId: args.userId)),
        child: ProfileScreen(),
      ),
    );
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: NeumorphicAppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(state.user.username,
                  style: Theme.of(context).textTheme.headline6),
            ),
            actions: [
              if (state.isCurrentUser)
                InkWell(
                  onTap: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                    context.read<LikedPostsCubit>().clearAllLikedPosts();
                  },
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.convex,
                      depth: 5,
                      intensity: 0.75,
                      surfaceIntensity: 0.75,
                      lightSource: LightSource.topLeft,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(40)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        FontAwesomeIcons.signOutAlt,
                        size: 20.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    switch (state.status) {
      case ProfileStatus.loading:
        return Center(child: CircularProgressIndicator());
      default:
        return RefreshIndicator(
          onRefresh: () async {
            context
                .read<ProfileBloc>()
                .add(ProfileLoadUser(userId: state.user.id));
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Neumorphic(
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        depth: 5,
                        intensity: 0.75,
                        lightSource: LightSource.topLeft,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(
                          Radius.circular(20),
                        )),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, bottom: 5.0, top: 20),
                              child: UserProfileImage(
                                radius: 60.0,
                                profileImageUrl: state.user.profileImageUrl,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                                vertical: 5,
                              ),
                              child: ProfileInfo(
                                username: state.user.username,
                                bio: state.user.bio,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 30.0,
                                right: 30,
                                top: 10,
                              ),
                              child: ProfileStats(
                                isCurrentUser: state.isCurrentUser,
                                isFollowing: state.isFollowing,
                                posts: state.posts.length,
                                followers: state.user.followers,
                                following: state.user.following,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey[50],
                      tabs: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Tab(
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                depth: 5,
                                intensity: 0.75,
                                surfaceIntensity: 0.75,
                                lightSource: LightSource.topLeft,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(10)),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF0059D6),
                                        Color(0xFF04BFBF),
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      tileMode: TileMode.clamp),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  FontAwesomeIcons.th,
                                  size: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Tab(
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                depth: 5,
                                intensity: 0.75,
                                surfaceIntensity: 0.75,
                                lightSource: LightSource.topLeft,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(10)),
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF0059D6),
                                        Color(0xFF04BFBF),
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      tileMode: TileMode.clamp),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: Icon(
                                  FontAwesomeIcons.thList,
                                  size: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      indicatorWeight: 3.0,
                      onTap: (i) => context
                          .read<ProfileBloc>()
                          .add(ProfileToggleGridView(isGridView: i == 0)),
                    ),
                  ),
                ),
                state.isGridView
                    ? SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 2.0,
                          crossAxisSpacing: 2.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final post = state.posts[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Neumorphic(
                                style: NeumorphicStyle(
                                  border: NeumorphicBorder(
                                    color: Color(0x33000000),
                                    width: 0.8,
                                  ),
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(12)),
                                  shape: NeumorphicShape.flat,
                                  depth: 3,
                                  intensity: 0.75,
                                  lightSource: LightSource.topLeft,
                                ),
                                child: Container(
                                  child: GestureDetector(
                                    onTap: () =>
                                        Navigator.of(context).pushNamed(
                                      CommentsScreen.routeName,
                                      arguments: CommentsScreenArgs(post: post),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12.0),
                                      child: CachedNetworkImage(
                                        imageUrl: post.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: state.posts.length,
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final post = state.posts[index];
                            final likedPostsState =
                                context.watch<LikedPostsCubit>().state;
                            final isLiked =
                                likedPostsState.likedPostIds.contains(post.id);
                            return PostView(
                              post: post,
                              isLiked: isLiked,
                              onLike: () {
                                if (isLiked) {
                                  context
                                      .read<LikedPostsCubit>()
                                      .unlikePost(post: post);
                                } else {
                                  context
                                      .read<LikedPostsCubit>()
                                      .likePost(post: post);
                                }
                              },
                            );
                          },
                          childCount: state.posts.length,
                        ),
                      ),
              ],
            ),
          ),
        );
    }
  }
}
