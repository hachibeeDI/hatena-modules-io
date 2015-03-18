###
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
###


do ->

  ### ウィジェットを配置した要素のid ###
  ID_OF_PLACEHOLDER = 'relate_entry'
  EL_PLACE_HOLDER = document.getElementById ID_OF_PLACEHOLDER
  return unless EL_PLACE_HOLDER

  _param_attrs = EL_PLACE_HOLDER.attributes
  ### 表示件数 ###
  LIMIT_OF_SUGGESTIONS = parseInt(_param_attrs.getNamedItem('data-limit-suggestions').textContent, 10) || 4
  TITLE_OF_SUGGESTIONS = _param_attrs.getNamedItem('data-title-suggestions').textContent || 'あわせて読みたい'

  ### oEmbedを使ったブログカードスタイル ###
  ENABLE_EMBED_WIDGET_STYLE = true
  ### ブックマーク数表示(ENABLE_EMBED_WIDGET_STYLEが有効だと無視されます) ###
  ENABLE_BOOKMARKED_COUNT = true
  ### ツイート数表示(同上) ###
  ENABLE_TWEETBUZZED_COUNT = true

  BLOG_URL = window.location.origin

  google.load("feeds", "1")


  _prepareWidgetWrapper = (category_name) ->
    container = document.getElementById(ID_OF_PLACEHOLDER)
    relate_categories = (l.textContent for l in document.querySelectorAll('.categories a'))
      .map (rel) -> "<option value=\"#{rel}\" #{if rel == category_name then 'selected'} >#{rel}</option>"
    container.innerHTML =
      """ <div class=\"cina--reccomend__title--wrapper\">
        <h3 class=\"cina--reccomend__title\">#{TITLE_OF_SUGGESTIONS}</h3>
        <div class=\"cina--reccomend__category--dd-widget\">
          <label for=\"cina--categories__select\">カテゴリー
            <select id=\"cina--categories__select\">
            <option value=\"all\">全て</option>
            #{relate_categories.join('')}
            </select>
          </label>
          <button class=\"cina--reccomend__refresh-button btn\">更新</button>
        </div>
      </div>
      <ul class=\"cina--recommend__ul\" style=\"padding-left:0;\">
      </ul>
    """

  _prepareWidgetEvents = () ->
    _load = (_cate) ->
      if _cate == 'all'
        loadAllEntry()
      else
        loadRealateEntry(_cate)
    # NOTE: 複数個設置に対応させるかも
    document.querySelector('.cina--reccomend__refresh-button')
      .addEventListener('click', (e) ->
        _load(document.querySelector('#cina--categories__select').value)
      )

    document.querySelector('#cina--categories__select')
      .addEventListener('change', (e) ->
        selected_category = e.target.value
        _load(selected_category)
      )

  # wrapperの準備。以後ulの中身だけ更新する
  initializeRealateEntry = () ->
    relate_links = (l for l in document.querySelectorAll('.categories a'))
      .sort () -> Math.random() - .5
    category_name = if relate_links.length == 0 then '' else relate_links[0].textContent  # categoryが空 = 過去の全記事
    _prepareWidgetWrapper(decodeURIComponent(category_name))
    _prepareWidgetEvents()
    loadRealateEntry(category_name)


  loadRealateEntry = (category_name='') ->
    category_rss_link = "#{BLOG_URL}/rss/category/#{encodeURIComponent(category_name)}"
    feed = new google.feeds.Feed(category_rss_link)
    feed.setNumEntries(20)
    feed.load (result) ->
      unless (result.error || result.feed.entries.length == 0)
        createRecommendHtmls(result.feed.entries)

  loadAllEntry = () ->
    category_rss_link = "#{BLOG_URL}/rss/category/"
    console.log category_rss_link
    feed = new google.feeds.Feed(category_rss_link)
    feed.setNumEntries(100)
    feed.load (result) ->
      unless (result.error || result.feed.entries.length == 0)
        console.log result.feed
        createRecommendHtmls(result.feed.entries)


  google.setOnLoadCallback(initializeRealateEntry)


  createRecommendHtmls = (entries) ->
    viewing_entry_uri = window.location.href
    links = entries
      .filter (entry) -> entry.link != viewing_entry_uri
      .sort () -> Math.random() - .5  # instant shuffle
      .slice 0, LIMIT_OF_SUGGESTIONS
      .map createEachSuggestion
    container = document.querySelector('.cina--recommend__ul')
    container.innerHTML = """ #{links.join('')} """

  createEachSuggestion = do ->
    if ENABLE_EMBED_WIDGET_STYLE
      (entry) -> """<li class=\"cina--recommend__li\" style=\"list-style-type:none;\">
        <p><iframe src=\"#{entry.link.replace("#{BLOG_URL}/entry/", "#{BLOG_URL}/embed/")}\" width=\"100%\" height=\"190px\" scrolling=\"no\" frameborder=\"0\"></iframe></p>
        </li>"""
    else
      (entry) -> """<li class=\"cina--recommend__li\" style=\"list-style-type:none;\">
        <p><a href=\"#{entry.link}\" rel=\"nofollow\" target=\"_blank\">#{entry.title}</a>
        #{createBookmarkedCount(entry.link)}
        #{createTweetbuzzCount(entry.link)}
        </p>
        </li>"""


  createBookmarkedCount = do ->
    if ENABLE_BOOKMARKED_COUNT
      (link) -> """<a href=\"http://b.hatena.ne.jp/entry/#{link}\" rel=\"nofollow\" target=\"_blank\">
        <img src=\"http://b.hatena.ne.jp/entry/image/#{link}\" style=\"opacity:0.8\" />
        </a>"""
    else
      (link) -> ''

  createTweetbuzzCount = do ->
    if ENABLE_TWEETBUZZED_COUNT
      (link) -> """ <a href=\"http://tweetbuzz.jp/redirect?url=#{link}\" rel=\"nofollow\" target=\"_blank\">
        <img src=\"http://tools.tweetbuzz.jp/imgcount?url=#{link}\" />
        </a>"""
    else
      (link) -> ''

