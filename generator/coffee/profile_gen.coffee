RENDER_TWITTER = (id, name) ->
  if id then """
    <div class=\"twitter--follow__button--box\">
      <a
        class=\"btn twitter--follow__button\"
        title=\"Twitterで#{name} (@#{id})さんをフォローしましょう\"
        href=\"https://twitter.com/intent/follow?region=follow_link&screen_name=#{id}&tw_p=followbutton\">
        <span class=\"label\">@#{id}さんをフォロー</span>
      </a>
    </div>""" else ''

TEMPLATE = (hatena_id, nickname, intro, twitter_name, twitter_id, photo_url) ->
  return '' unless hatena_id
  photo_url = "http://cdn1.www.st-hatena.com/users/ha/#{hatena_id}/profile.gif" unless photo_url
  return """
<div class=\"hatena-module hatena-module-profile\">
  <div class=\"hatena-module-body\">
    <a href=\"http://#{hatena_id}.hateblo.jp/about\" class=\"profile-icon-link\">
      <img src=\"#{photo_url}\" alt=\"id:#{hatena_id}\" class=\"profile-icon\">
    </a>
    <span class=\"id\">
      <a href=\"http://#{hatena_id}.hateblo.jp/about\" class=\"hatena-id-link\"><span data-load-nickname=\"1\" data-user-name=\"#{hatena_id}\"><span class=\"user-name-nickname\">#{nickname}</span> <span class=\"user-name-paren\">(</span><span class=\"user-name-hatena-id\">id:#{hatena_id}</span><span class=\"user-name-paren\">)</span></span></a>
    </span>
    <div class=\"profile-description\">
      <p>#{intro}</p>
    </div>

    <div class=\"hatena-follow-button-box btn-subscribe\">
      <a href=\"#\" class=\"hatena-follow-button\">
        <span class=\"subscribing\">
          <span class=\"foreground\">購読中です</span>
          <span class=\"background\">読者をやめる</span>
        </span>
        <span class=\"unsubscribing\" data-track-name=\"profile-widget-subscribe-button\" data-track-once=\"\">
          <span class=\"foreground\">読者になる</span>
          <span class=\"background\">読者になる</span>
        </span>
      </a>
      <div class=\"subscription-count-box\" style=\"display: block;\">
        <i></i>
        <u></u>
        <span class=\"subscription-count\">0</span>
      </div>
    </div>
    #{RENDER_TWITTER(twitter_id, twitter_name)}
  </div>
</div>
"""


app = new Vue({
  el: '#datas'
  data:
    hatena_id: ''
    hatena_nickname: ''
    introduction: ''
    twitter_name: ''
    twitter_id: ''
    photo_url: ''
    preview_data: ''
  methods:
    render_preview: () ->
      @preview_data = TEMPLATE @hatena_id, @hatena_nickname, @introduction, @twitter_name, @twitter_id, @photo_url
})



SOURCE_EXAMPLE = document.querySelector('#gen--source-area')

SOURCE_EXAMPLE
 .addEventListener 'click', (ev) ->
   SOURCE_EXAMPLE.select()

