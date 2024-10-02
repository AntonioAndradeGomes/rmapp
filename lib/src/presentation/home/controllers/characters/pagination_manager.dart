class PaginationManager {
  int _page = 1;
  bool _hasMoreItems = true;

  int get page => _page;
  bool get hasMoreItems => _hasMoreItems;

  void reset() {
    _page = 1;
    _hasMoreItems = true;
  }

  void nextPage() {
    _page++;
  }

  void noMoreItems() {
    _hasMoreItems = false;
  }
}
