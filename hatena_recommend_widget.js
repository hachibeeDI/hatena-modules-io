
/*
The MIT License (MIT)

Copyright (c) <2014> <OGURA_Daiki>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 */

(function() {
  (function() {

    /* ウィジェットを配置した要素のid */
    var BLOG_URL, EL_PLACE_HOLDER, ENABLE_BOOKMARKED_COUNT, ENABLE_EMBED_WIDGET_STYLE, ENABLE_TWEETBUZZED_COUNT, ID_OF_PLACEHOLDER, LIMIT_OF_SUGGESTIONS, TITLE_OF_SUGGESTIONS, createBookmarkedCount, createEachSuggestion, createRecommendHtmls, createTweetbuzzCount, initializeRealateEntry, loadAllEntry, loadRealateEntry, _param_attrs, _prepareWidgetEvents, _prepareWidgetWrapper;
    ID_OF_PLACEHOLDER = 'relate_entry';
    EL_PLACE_HOLDER = document.getElementById(ID_OF_PLACEHOLDER);
    if (!EL_PLACE_HOLDER) {
      return;
    }
    _param_attrs = EL_PLACE_HOLDER.attributes;

    /* 表示件数 */
    LIMIT_OF_SUGGESTIONS = parseInt(_param_attrs.getNamedItem('data-limit-suggestions').textContent, 10) || 4;
    TITLE_OF_SUGGESTIONS = _param_attrs.getNamedItem('data-title-suggestions').textContent || 'あわせて読みたい';

    /* oEmbedを使ったブログカードスタイル */
    ENABLE_EMBED_WIDGET_STYLE = true;

    /* ブックマーク数表示(ENABLE_EMBED_WIDGET_STYLEが有効だと無視されます) */
    ENABLE_BOOKMARKED_COUNT = true;

    /* ツイート数表示(同上) */
    ENABLE_TWEETBUZZED_COUNT = true;
    BLOG_URL = window.location.origin;
    google.load("feeds", "1");
    _prepareWidgetWrapper = function(category_name) {
      var container, l, relate_categories;
      container = document.getElementById(ID_OF_PLACEHOLDER);
      relate_categories = ((function() {
        var _i, _len, _ref, _results;
        _ref = document.querySelectorAll('.categories a');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          l = _ref[_i];
          _results.push(l.textContent);
        }
        return _results;
      })()).map(function(rel) {
        return "<option value=\"" + rel + "\" " + (rel === category_name ? 'selected' : void 0) + " >" + rel + "</option>";
      });
      return container.innerHTML = " <div class=\"cina--reccomend__title--wrapper\">\n  <h3 class=\"cina--reccomend__title\">" + TITLE_OF_SUGGESTIONS + "</h3>\n  <div class=\"cina--reccomend__category--dd-widget\">\n    <label for=\"cina--categories__select\">カテゴリー\n      <select id=\"cina--categories__select\">\n      <option value=\"all\">全て</option>\n      " + (relate_categories.join('')) + "\n      </select>\n    </label>\n    <button class=\"cina--reccomend__refresh-button btn\">更新</button>\n  </div>\n</div>\n<ul class=\"cina--recommend__ul\" style=\"padding-left:0;\">\n</ul>";
    };
    _prepareWidgetEvents = function() {
      var _load;
      _load = function(_cate) {
        if (_cate === 'all') {
          return loadAllEntry();
        } else {
          return loadRealateEntry(_cate);
        }
      };
      document.querySelector('.cina--reccomend__refresh-button').addEventListener('click', function(e) {
        return _load(document.querySelector('#cina--categories__select').value);
      });
      return document.querySelector('#cina--categories__select').addEventListener('change', function(e) {
        var selected_category;
        selected_category = e.target.value;
        return _load(selected_category);
      });
    };
    initializeRealateEntry = function() {
      var category_name, l, relate_links;
      relate_links = ((function() {
        var _i, _len, _ref, _results;
        _ref = document.querySelectorAll('.categories a');
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          l = _ref[_i];
          _results.push(l);
        }
        return _results;
      })()).sort(function() {
        return Math.random() - .5;
      });
      category_name = relate_links.length === 0 ? '' : relate_links[0].textContent;
      _prepareWidgetWrapper(decodeURIComponent(category_name));
      _prepareWidgetEvents();
      return loadRealateEntry(category_name);
    };
    loadRealateEntry = function(category_name) {
      var category_rss_link, feed;
      if (category_name == null) {
        category_name = '';
      }
      category_rss_link = "" + BLOG_URL + "/rss/category/" + (encodeURIComponent(category_name));
      feed = new google.feeds.Feed(category_rss_link);
      feed.setNumEntries(20);
      return feed.load(function(result) {
        if (!(result.error || result.feed.entries.length === 0)) {
          return createRecommendHtmls(result.feed.entries);
        }
      });
    };
    loadAllEntry = function() {
      var category_rss_link, feed;
      category_rss_link = "" + BLOG_URL + "/rss/category/";
      console.log(category_rss_link);
      feed = new google.feeds.Feed(category_rss_link);
      feed.setNumEntries(100);
      return feed.load(function(result) {
        if (!(result.error || result.feed.entries.length === 0)) {
          console.log(result.feed);
          return createRecommendHtmls(result.feed.entries);
        }
      });
    };
    google.setOnLoadCallback(initializeRealateEntry);
    createRecommendHtmls = function(entries) {
      var container, links, viewing_entry_uri;
      viewing_entry_uri = window.location.href;
      links = entries.filter(function(entry) {
        return entry.link !== viewing_entry_uri;
      }).sort(function() {
        return Math.random() - .5;
      }).slice(0, LIMIT_OF_SUGGESTIONS).map(createEachSuggestion);
      container = document.querySelector('.cina--recommend__ul');
      return container.innerHTML = " " + (links.join('')) + " ";
    };
    createEachSuggestion = (function() {
      if (ENABLE_EMBED_WIDGET_STYLE) {
        return function(entry) {
          return "<li class=\"cina--recommend__li\" style=\"list-style-type:none;\">\n<p><iframe src=\"" + (entry.link.replace("" + BLOG_URL + "/entry/", "" + BLOG_URL + "/embed/")) + "\" width=\"100%\" height=\"190px\" scrolling=\"no\" frameborder=\"0\"></iframe></p>\n</li>";
        };
      } else {
        return function(entry) {
          return "<li class=\"cina--recommend__li\" style=\"list-style-type:none;\">\n<p><a href=\"" + entry.link + "\" rel=\"nofollow\" target=\"_blank\">" + entry.title + "</a>\n" + (createBookmarkedCount(entry.link)) + "\n" + (createTweetbuzzCount(entry.link)) + "\n</p>\n</li>";
        };
      }
    })();
    createBookmarkedCount = (function() {
      if (ENABLE_BOOKMARKED_COUNT) {
        return function(link) {
          return "<a href=\"http://b.hatena.ne.jp/entry/" + link + "\" rel=\"nofollow\" target=\"_blank\">\n<img src=\"http://b.hatena.ne.jp/entry/image/" + link + "\" style=\"opacity:0.8\" />\n</a>";
        };
      } else {
        return function(link) {
          return '';
        };
      }
    })();
    return createTweetbuzzCount = (function() {
      if (ENABLE_TWEETBUZZED_COUNT) {
        return function(link) {
          return " <a href=\"http://tweetbuzz.jp/redirect?url=" + link + "\" rel=\"nofollow\" target=\"_blank\">\n<img src=\"http://tools.tweetbuzz.jp/imgcount?url=" + link + "\" />\n</a>";
        };
      } else {
        return function(link) {
          return '';
        };
      }
    })();
  })();

}).call(this);
