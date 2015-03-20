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

do () ->
  # print = console.log.bind console
  $$CC = document.createElement.bind document
  $$Q = document.querySelector.bind document
  $$QA = document.querySelectorAll.bind document

  isEntryPage = $$Q('html').getAttribute('data-page') == 'entry'
  return unless isEntryPage

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
  return unless _CATEGORY_DEFINITIONS


  _setupMetadataAsPlaceholder = (placeholder) ->
    placeholder.setAttribute 'itemscope', ''
    placeholder.setAttribute 'itemtype', 'http://www.data-vocabulary.org/Breadcrumb/'
    placeholder


  _makeUrlProp = (title, uri) ->
    # print 'make url prop', uri, title
    anchor = $$CC 'a'
    anchor.className = 'breadcrumb--urlprop'
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
    # print 'build from top', top
    _genHolder = () ->
      holder = _setupMetadataAsPlaceholder $$CC 'div'
      holder.appendChild _makeUrlProp top.title, top.uri
      holder.className = 'breadcrumb--row'
      holder

    if _.isEmpty top.children
      # print 'create only top breadcrumb'
      holder = _genHolder()
      holder.appendChild _makeThisPageProp()
      return [holder]

    breadcrumbes = []
    for second in top.children
      # print 'create Breadcrumb second ', second
      if _.isEmpty second.children
        # print 'second has no children', second
        holder = _genHolder()
        secondElem = _makeChildProp second.title, second.uri
        secondElem.appendChild _makeThisPageProp()
        holder.appendChild secondElem
        breadcrumbes.push holder
      else
        for third in second.children
          holder = _genHolder()
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
    # print 'containedKeys', containedKeys
    definedParents = _.keys _CATEGORY_DEFINITIONS
    for key in category_key when not(key in containedKeys or key in definedParents)
      hierarchies.push 'title': key, 'uri': category[key]
    return hierarchies


  document.addEventListener 'DOMContentLoaded', () ->
    # BASE_URI = $('html').attr('data-blogs-uri-base')

    PLACE_HOLDER = $$Q '.categories'

    categories = _parseHatenaCategoryElements PLACE_HOLDER
    # print categories
    categories = categories.reduce(
      (x, y) ->
        x[y[0]] = y[1]
        return x
      ,
      {}
    )
    return if _.isEmpty categories
    # このタイミングならjQueryがロードされている
    $PLACE_HOLDER = $ PLACE_HOLDER
    $PLACE_HOLDER.hide()
    root = document.createElement('div')
    root.className = 'breadcrumb--root'
    hierarchies = _parseHierarchy categories
    # print 'hierarchies----', hierarchies
    # 2つあればいいよね
    for h in _.first hierarchies, 2
      _buildBreadcrumbFromHierarchy(h).forEach (e) -> root.appendChild e
    $PLACE_HOLDER.after(root)

