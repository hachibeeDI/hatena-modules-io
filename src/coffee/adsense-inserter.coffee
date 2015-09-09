do ($$D=document) ->
  $$Q = $$D.querySelector.bind document
  $$QA = $$D.querySelectorAll.bind document
  TYPE_THIS_PAGE = $$Q('html').getAttribute('data-page')
  VALID_PAGES = ['index', 'archive']

  $$D.addEventListener('DOMContentLoaded', (eve) ->
    # console.log 'aaaaaaaaaaaaaaaaaaaaaaa'
    # console.log VALID_PAGES
    return unless _.contains(VALID_PAGES, TYPE_THIS_PAGE)
    CONTENTS = [
      """
      <div style="margin: 25px auto 25px">
        <ins class="adsbygoogle"
          style="display:inline-block;width:300px;height:250px"
          data-ad-client="ca-pub-2840889474156734"
          data-ad-slot="7162362001"></ins>
      </div>
      """,
    ]
    # entryFooters = $$QA('.entry-footer')
    seeMoreButtons = $$QA('.entry-see-more')
    CONTAINER_AREAES = if TYPE_THIS_PAGE == 'index' then seeMoreButtons else $$QA('.archive-entry')
    return unless CONTAINER_AREAES?
    _.chain(CONTAINER_AREAES)
      .zip(CONTENTS)
      .each((z) ->
        # console.log z
        [area, content] = z
        return unless content?
        area.insertAdjacentHTML('afterend', content)
        initializer = $$D.createElement('script')
        initializer.innerHTML = '(adsbygoogle = window.adsbygoogle || []).push({});'
        area.nextSibling.appendChild(initializer)
      )
  )

