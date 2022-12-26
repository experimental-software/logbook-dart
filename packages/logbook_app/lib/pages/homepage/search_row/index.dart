import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logbook_app/pages/homepage/state.dart';

import '../../../state.dart';

class SearchRow extends StatefulWidget {
  const SearchRow({Key? key}) : super(key: key);

  @override
  State<SearchRow> createState() => _SearchRowState();
}

// TODO Reset search term controller after app update

class _SearchRowState extends State<SearchRow> {
  final TextEditingController _searchTermController = TextEditingController();
  bool useRegexSearch = false;
  bool negateSearch = false;

  @override
  void dispose() {
    _searchTermController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homepageBloc = context.read<HomepageBloc>();

    return BlocListener<LogbookBloc, LogbookState>(
      listener: (context, state) {
        homepageBloc.add(
          SearchSubmitted(
            _searchTermController.text.trim(),
            useRegexSearch: useRegexSearch,
            negateSearch: negateSearch,
          ),
        );
      },
      child: _buildSearchRow(context),
    );
  }

  Widget _buildSearchRow(BuildContext context) {
    final homepageBloc = context.read<HomepageBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SizedBox(
            width: 200,
            child: TextField(
              controller: _searchTermController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Search log entries...',
                suffixIcon: Column(
                  children: [
                    InkWell(
                      child: useRegexSearch
                          ? const Icon(Icons.emergency, size: 20)
                          : const Icon(Icons.emergency_outlined, size: 20),
                      onTap: () {
                        setState(() {
                          useRegexSearch = !useRegexSearch;
                        });
                        final searchTerm = _searchTermController.text.trim();
                        homepageBloc.add(
                          SearchSubmitted(
                            searchTerm,
                            useRegexSearch: useRegexSearch,
                            negateSearch: negateSearch,
                          ),
                        );
                      },
                    ),
                    InkWell(
                      child: negateSearch
                          ? const Icon(Icons.remove_circle, size: 20)
                          : const Icon(Icons.remove_circle_outline, size: 20),
                      onTap: () {
                        setState(() {
                          negateSearch = !negateSearch;
                        });
                        final searchTerm = _searchTermController.text.trim();
                        homepageBloc.add(
                          SearchSubmitted(
                            searchTerm,
                            useRegexSearch: useRegexSearch,
                            negateSearch: negateSearch,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              onSubmitted: (query) {
                final searchTerm = _searchTermController.text.trim();
                homepageBloc.add(
                  SearchSubmitted(
                    searchTerm,
                    useRegexSearch: useRegexSearch,
                    negateSearch: negateSearch,
                  ),
                );
              },
              autofocus: true,
            ),
          ),
        )
      ],
    );
  }
}
