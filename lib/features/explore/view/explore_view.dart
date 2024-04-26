import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kooginapp/core/common/loading_page.dart';
import 'package:kooginapp/core/error/error_page.dart';
import 'package:kooginapp/core/theme/pallete.dart';
import 'package:kooginapp/features/explore/controller/explore_controller.dart';
import 'package:kooginapp/features/explore/widgets/search_tile.dart';

class ExploreView extends ConsumerStatefulWidget {
  const ExploreView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreViewState();
}

class _ExploreViewState extends ConsumerState<ExploreView> {
  final searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarTextFieldBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Pallete.searchBarColor,
        ));
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 45,
          child: TextField(
            onSubmitted: (value) {
              setState(() {
                isShowUsers = true;
              });
            },
            controller: searchController,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(15),
              filled: true,
              enabledBorder: appBarTextFieldBorder,
              focusedBorder: appBarTextFieldBorder,
            ),
          ),
        ),
      ),
      body: isShowUsers
          ? ref.watch(searchUserProvider(searchController.text)).when(
              data: (users) {
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index) {
                    final user = users[index];
                    return SearchTile(userModel: user);
                  },
                );
              },
              error: (error, stackTrace) {
                ErrorText(
                  error: error.toString(),
                );
                return null;
              },
              loading: () {
                return const Loader();
              },
            )
          : const SizedBox(),
    );
  }
}
