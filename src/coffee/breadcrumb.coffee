do () ->

  print = console.log.bind console
  $$CC = document.createElement.bind document
  $$Q = document.querySelector.bind document
  $$QA = document.querySelectorAll.bind document


  _setupMetadataAsPlaceholder = (placeholder) ->
    placeholder.setAttribute 'itemscope', ''
    placeholder.setAttribute 'itemtype', 'http://www.data-vocabulary.org/Breadcrumb/'
    placeholder


  _makeUrlProp = (title, uri) ->
    print 'make url prop', uri, title
    anchor = $$CC 'a'
    anchor.setAttribute 'itemprop', 'url'
    anchor.setAttribute 'href', uri
    titleElem = $$CC 'span'
    titleElem.setAttribute 'itemprop', 'title'
    titleElem.innerText = title
    anchor.appendChild titleElem
    anchor

  _makeChildProp = (title, uri) ->
    holder = _setupMetadataAsPlaceholder $$CC 'div'
    holder.className = 'breadcrumb--child inline-block'
    holder.setAttribute 'itemprop', 'child'
    holder.appendChild _makeUrlProp title, uri
    holder

  _makeThisPageProp = () ->
    uri = window.location.href
    title = $$Q('.entry-title a').text
    _makeChildProp title, uri


  ### 無制限にも実装出来るけど三つあれば充分っしょ ###
  _buildBreadcrumbFromHierarchy = (top) ->
    print 'create Breadcrumb from ', top
    unless top.children
      holder = _setupMetadataAsPlaceholder $$CC 'div'
      holder.appendChild _makeUrlProp top.title, top.uri
      holder.appendChild _makeThisPageProp()
      return [holder]

    breadcrumbes = []
    for second in top.children
      print 'create Breadcrumb second ', second
      if _.isEmpty second.children
        print 'second has no children', second
        holder = _setupMetadataAsPlaceholder $$CC 'div'
        holder.appendChild _makeUrlProp top.title, top.uri
        secondElem = _makeChildProp second.title, second.uri
        secondElem.appendChild _makeThisPageProp()
        holder.appendChild secondElem
        breadcrumbes.push holder
      else
        for third in second.children
          holder = _setupMetadataAsPlaceholder $$CC 'div'
          holder.appendChild _makeUrlProp top.title, top.uri
          secondElem = _makeChildProp second.title, second.uri
          thirdElem = _makeChildProp third.title, third.uri
          thirdElem.appendChild _makeThisPageProp()
          secondElem.appendChild thirdElem
          holder.appendChild secondElem
          breadcrumbes.push holder
    breadcrumbes
  ### parse anchores as uri and title ###
  _parseHatenaCategoryElements = (parent) ->
    return unless parent
    anchors = parent.querySelectorAll 'a'
    _.map anchors, (elem) -> [elem.text, elem.href]


  ###
  example:
    var _CATEGORY_DEFINITIONS = {
      'programming': {
        'JavaScript': ['jQuery', 'React', 'Vue'],
        'Python': ['Django', 'Flask', 'numpy'],
        'Haskell': []
      },
      'foods': {
        'cooking': ['bread', 'meet'],
        'alcohol': ['beer', 'wine']
      }
    }
  ###
  _CATEGORY_DEFINITIONS = window._CATEGORY_DEFINITIONS

  ### category: {title: uri} ###
  _parseHierarchy = (category) ->
    category_key = _.keys category
    hierarchies = []
    containedKeys = []
    for parent, _child of _CATEGORY_DEFINITIONS when parent in category_key
      parentObj = 'title': parent, 'uri': category[parent], 'children': []
      containedKeys.push parent
      for child, g_children of _child when child in category_key
        containedKeys.push child
        childObj = 'title': child, 'uri': category[child], 'children': []
        parentObj.children.push childObj
        for g_child in g_children when g_child in category_key
          containedKeys.push g_child
          childObj.children.push 'title': g_child, 'uri': category[g_child]
      hierarchies.push parentObj

    # undefined keys are all in parent hierarchy
    print 'containedKeys', containedKeys
    definedParents = _.keys _CATEGORY_DEFINITIONS
    for key in category_key when not(key in containedKeys or key in definedParents)
      hierarchies.push 'title': key, 'uri': category[key]
    return hierarchies


  document.addEventListener 'DOMContentLoaded', () ->
    BASE_URI = $('html').attr('data-blogs-uri-base')

    PLACE_HOLDER = $$Q '.categories'
    # TODO: 記事ページ以外での終了処理

    categories = _parseHatenaCategoryElements PLACE_HOLDER
    print categories
    categories = categories.reduce(
      (x, y) ->
        x[y[0]] = y[1]
        return x
      ,
      {}
    )
    return if _.isEmpty categories
    PLACE_HOLDER.innerHTML = ''
    hierarchies = _parseHierarchy categories
    print 'hierarchies----', hierarchies
    for h in hierarchies
      _buildBreadcrumbFromHierarchy(h).forEach (e) -> PLACE_HOLDER.appendChild e

