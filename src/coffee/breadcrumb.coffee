document.addEventListener 'DOMContentLoaded', () ->
  # TOPページ用表示用。HTMLタグの「data-blogs-uri-base」から拾ってくるのが一番スマートであるよ
  # 準備
  if (!(window._parentCategory instanceof Array))
    _parentCategory = window._parentCategory || []

  _categoryBody = document.querySelectorAll("header.entry-header div.categories")
  _breadcrumbHTML = document.createElement("div")
  # 単一ページの場合はカテゴリ表示は一つ。TOPページから見たら複数ある事もある。
  # 検索エンジンが混乱しないように、複数ある場合はスキップさせる。
  if (_categoryBody.length > 1) return


  make_BreadcrumbTree = (erem) ->
    # カテゴリの親子関係を調べて階層レベルとして返す。

    parentStr = _parentCategory.join('<>') + '<>'
    treeList = [0]
    treeLevel = 0

    if (erem.length === 0)
      # カテゴリの指定がない
      return treeList
    if(_parentCategory.length === 0){
      # 親カテゴリのデータが無い場合は、すべて親カテゴリにする
      for (i = 0 i < erem.length i++){
        treeList[i] = 0
      }
      return treeList
    }

    for (i = 0 i < erem.length i++){
      if (parentStr.indexOf(erem[i].innerHTML + '<>') > -1 || i === 0){
        # 最初のカテゴリ、または、親カテゴリだった
        treeLevel = 0
      }
      treeList[i] = treeLevel
      treeLevel++
    }
    return treeList


  make_BreadcrumbElem = (elem,child_flg) ->
    el_content = document.createElement("span")# itemscope
    el_link = document.createElement("a")# link
    el_title = el_content.cloneNode(true)# span - title

    # microdata部分を大まかに設定する
    el_content.setAttribute("itemscope", "")# set itemscope
    el_content.setAttribute("itemtype", "http:# data-vocabulary.org/Breadcrumb")# set itemtype - url
    el_link.setAttribute("itemprop", "url")# set itemprop - url
    el_title.setAttribute("itemprop", "title")# set itemprop - title

    el_title.innerText = elem.innerText# タイトルを入れる
    el_link.setAttribute("href", elem.href)# リンク先

    # 組み立てる
    el_link.appendChild(el_title)
    el_content.appendChild(el_link)

    if (child_flg){
      # 子として指定する
      el_content.setAttribute("itemprop", "child")
    }
    return el_content


  make_BreadcrumbNav = (Categories) ->
    nav_Breadcrumb = document.createElement("nav")
    categoryList = Categories.querySelectorAll("a")

    return if categoryList.length < 1

    treeList = make_BreadcrumbTree(categoryList)
    nav_Child = []
    nav_Parent = []

    # 逆順に回して子カテゴリから詰め込んでいく
    for val, i in treeList by -1
      if val == 0
        # 親カテゴリ
        nav_Parent = make_BreadcrumbElem(categoryList[i],0)
        for (index in nav_Child)
          nav_Parent.appendChild(nav_Child[index])
        nav_Breadcrumb.insertBefore(nav_Parent,nav_Breadcrumb.firstChild)
        nav_Child=[]
      else
        # 子カテゴリ
        nav_Child.unshift(make_BreadcrumbElem(categoryList[i],1))

      # 不要になった元のカテゴリ表示を消す
      Categories.removeChild(categoryList[i])
    # すべての処理が終わったら生成済みのパンくずリストを埋め込む


  make_BreadcrumbNav(_categoryBody[0])

